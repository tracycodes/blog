echo "Starting build process.."


for mode in theme site; do
    echo "Compiling $mode CSS.."
    cd /opt/$PROJECT/static/$mode/css
    output_dir="/opt/$PROJECT/hugo"
    if [[ $mode == "site" ]]; then
        output_dir="$output_dir/themes/blog-theme/static/css"
    elif [[ $mode == "theme" ]]; then
        output_dir="$output_dir/static/css"
    fi;

    if [[ $( find . -name *.css | wc -l) -gt 0 ]]; then
        echo "Executing postcss.."
        postcss_output=$(
            postcss \
            --use postcss-autoreset \
            --use postcss-initial \
            --use postcss-neat \
            --dir $output_dir \
            *.css 2>&1
        )
    else
        echo "Skipping postcss. No styles."
    fi;

    if [[ $? != 0 ]]; then
        echo "Error compiling CSS:"
        echo $postcss_output
        exit 1
    else
        echo "Compiled $mode CSS."
    fi;
done

echo "Building site.."
cd /opt/$PROJECT/hugo
hugo_output=$(
    hugo \
    --verbose \
    --buildDrafts \
    --buildFuture \
    2>&1
)
if [[ $(echo "$hugo_output" | grep -e "^ERROR:" | wc -l) -gt 0 ]]; then
    echo "Error building site:"
    echo "$hugo_output"
    exit 1
else
    echo "Site built."
fi;

echo "Starting hugo server.."
hugo server
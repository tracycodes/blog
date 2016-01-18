echo "Starting build process.."

echo "Compiling theme CSS.."
cd static/theme/css
postcss_output=$(
    postcss \
    --use postcss-autoreset \
    --use postcss-initial \
    --use postcss-neat \
    --dir /opt/$PROJECT/hugo/hugo-theme/static/css \
    *.css 2>&1
)

if [[ $? != 0 ]]; then
    echo "Error compiling CSS:"
    echo $postcss_output
    exit 1
else
    echo "Compiled theme CSS."
fi;

echo "Compiling site CSS.."
cd static/site/css
postcss_output=$(
    postcss \
    --use postcss-autoreset \
    --use postcss-initial \
    --use postcss-neat \
    --dir /opt/$PROJECT/hugo/static/css \
    *.css 2>&1
)

if [[ $? != 0 ]]; then
    echo "Error compiling CSS:"
    echo $postcss_output
    exit 1
else
    echo "Compiled site CSS."
fi;


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
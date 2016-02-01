find $1 -type f -not -path '*/\.*' -execdir \
    bash -c 'hugo new --source "$1" --theme casper post/"$0" && cat "$0" >> $1/content/post/"$0"' {} $2 \;

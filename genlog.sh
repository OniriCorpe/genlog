#!/usr/bin/env bash

# some useful things
# https://sharats.me/posts/shell-script-best-practices/
set -o errexit
set -o pipefail


# creating a temporary directory for our working stuff
tempdir="$(mktemp -d)"


# checking args
if [[ -n "$1" ]]
then
    # if there's an arg, using it as a working path
    source_path="$1"
else
    # if not, using the 'content' directory as working path
    source_path=content
fi


# get the current date for the footer (UTC and ISO 8601 with hours and minutes)
date=$(date -u --iso-8601=minutes)
sed "s/GEN_DATE/$date/" html/footer.html > "$tempdir/footer.html"


# finding recursively all ".gmi" files on the working path
find "$source_path" -wholename "*.gmi" -type f | while read -r gmi_file
do

    # deleting the '#' of the first line and save it as title
    title="$(sed -n '1{s/# //p}' "$gmi_file") $2"

    # in the header.html, replacing the "<\-- TITLE -->" by the previously
    # saved title, and save the modified file in our temporary directory
    sed "s#<\!-- TITLE -->#$title#" html/header.html > "$tempdir/header.html"

    # convertig .gmi files in .html
    /usr/local/bin/gmnitohtml < "$gmi_file" > "$tempdir/body.html"

    # retrieving of the path of the current .gmi file
    file_path="$(dirname "$gmi_file")"
    # retrieving of the filename of the current .gmi file, without its extension
    file_name="$(basename "$gmi_file" .gmi)"

    # assembling the header, the converted page and the footer and saving it in the working path
    cat "$tempdir/header.html" "$tempdir/body.html" "$tempdir/footer.html" > "$file_path/$file_name.html"

    # i think it's all good
    echo "OK: $title"
    echo "    ⤷ $file_path/$file_name.html"

done


# removing the temporary directory, it's useless now
rm -r "$tempdir"


# this time it's really the end
echo "All done."

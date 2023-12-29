#!/usr/bin/env bash

: '
LICENCE
THE "HOT CHOCOLATE LICENSE ☕" (HCL revision 1312.2):

OniriCorpe wrote this file. As long as you retain this
notice and you are an anarchist/communist who supports oppressed and
marginalized groups (ie and not exclusively queer folks, BIPOC, intersex,
disabled comrades, etc), you can do whatever you want with this stuff.
If we meet some day, and you think this stuff is worth it, you can buy me a
hot chocolate or any other non-alcoholic drink that suits me in return.

OniriCorpe 🏴
'


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


# if header or footer file exists in the substitutes folder, use it instead of the default ones
if [ -f html/substitutes/header.html ]; then
    header_template="html/substitutes/header.html"
else
    header_template="html/header.html"
fi

if [ -f html/substitutes/footer.html ]; then
    footer_template="html/substitutes/footer.html"
else
    footer_template="html/footer.html"
fi


# get the current date for the footer (UTC and ISO 8601 with hours and minutes)
date=$(date -u --iso-8601=minutes)
sed "s/GEN_DATE/${date}/" "$footer_template" > "$tempdir/footer.html"


# finding recursively all ".gmi" files on the working path
find "$source_path" -wholename "*.gmi" -type f | while read -r gmi_file
do

    # deleting the '#' of the first line and save it as title
    title="$(sed -n '1{s/# //p}' "$gmi_file") $2"
    # escaping eventual '&' (otherwise causing a bug where it is replaced by '<\!-- TITLE -->')
    # shellcheck disable=SC2001
    title=$(echo "$title" | sed "s#&#\\\&#g")

    # in the header.html, replacing the "<\-- TITLE -->" by the previously
    # saved title, and save the modified file in our temporary directory
    sed "s#<\!-- TITLE -->#${title}#" "$header_template" > "$tempdir/header.html"

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

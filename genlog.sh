#!/bin/bash

mkdir ${PWD}/temp/

find "${PWD}" -wholename "*.gmi" -type f | while read gmi_file
do

    mkdir ${PWD}/temp/

    echo "sed 1"
    # récupérer la 1ère ligne du fichier .gmi et remplacer "# " par ""
    title=$(sed -n "1{s/# //p}" $gmi_file)

    echo "sed 2"
    # dans le header.html, remplacer "<\-- TITLE -->" par le titre récupéré
    # puis enregistrer le fichier ainsi modifié dans "temp/header.html"
    sed "s/<\!-- TITLE -->/${title//\//\\/}/" ${PWD}/html/header.html > ${PWD}/temp/header.html

    echo "sed 3"
    date=$(date)
    sed "s/GEN_DATE/$date/" ${PWD}/html/footer.html > ${PWD}/temp/footer.html

    # conversion du .gmi en .html
    gmnitohtml < $gmi_file > ${PWD}/temp/body.html

    path=$(dirname $gmi_file)

    cat ${PWD}/temp/header.html ${PWD}/temp/body.html ${PWD}/temp/footer.html > $path/index.html

    rm -r ${PWD}/temp/*

    echo "OK: $gmi_file"

done

rm -r ${PWD}/temp/

echo "Done."

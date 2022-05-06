#!/bin/bash

# on créé un répertoire de taff temporaire pour foutre nos fichiers en cours de traitement dedans
tempdir="$(mktemp -d)"


# on vérifie s'il y a un argument passé à notre script
if [ -n "$1" ]
then
    # si oui, on l'utilise comme path ou aller taffer
    source_path="$1"
else
    # sinon on utilise le dossier "content" à la racine de notre script
    source_path="${PWD}"/content
fi


# on génère la date et on la fout dans le footer
date="$(date)"
sed "s/GEN_DATE/$date/" "${PWD}"/html/footer.html > "$tempdir/footer.html"


# on cherche récursivement tous les fichiers ".gmi" dans le dossier de taff
find "$source_path" -wholename "*.gmi" -type f | while read -r gmi_file
do

    # récupérer la 1ère ligne du fichier .gmi et remplacer "# " par ""
    title="$(sed -n '1{s/# //p}' "$gmi_file") $2"

    # dans le header.html, remplacer "<\-- TITLE -->" par le titre récupéré
    # puis enregistrer le fichier ainsi modifié dans "temp/header.html"
    sed "s#<\!-- TITLE -->#$title#" "${PWD}"/html/header.html > "$tempdir/header.html"

    # conversion du .gmi en .html
    gmnitohtml < "$gmi_file" > "$tempdir/body.html"

    # on récupère juste le path du dossier qui contient le .gmi
    file_path="$(dirname "$gmi_file")"
    # on récupère juste le nom du fichier .gmi sans son extenstion ".gmi"
    file_name="$(basename "$gmi_file" .gmi)"

    # on assemble les 3 morceaux et on l'écrit dans le dossier du .gmi qui est traité
    cat "$tempdir/header.html" "$tempdir/body.html" "$tempdir/footer.html" > "$file_path/$file_name.html"

    # je crois c'est bon
    echo "OK: $title"
    echo "    ⤷ $file_path/$file_name.html"

done


# on vire le dossier de taff devenu inutile
rm -r "$tempdir"


# cette fois c'est vraiment fini
echo "All done."

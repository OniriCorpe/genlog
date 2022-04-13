#!/bin/bash

# on créé un répertoire de taff temporaire pour foutre nos fichiers en cours de traitement dedans
tempdir="$(mktemp -d)"

# on cherche récursivement tous les fichiers ".gmi" dans le dossier "content"
find "${PWD}"/content -wholename "*.gmi" -type f | while read gmi_file
do

    # récupérer la 1ère ligne du fichier .gmi et remplacer "# " par ""
    title="$(sed -n '1{s/# //p}' $gmi_file)"

    # dans le header.html, remplacer "<\-- TITLE -->" par le titre récupéré
    # puis enregistrer le fichier ainsi modifié dans "temp/header.html"
    sed "s#<\!-- TITLE -->#$title#" "${PWD}"/html/header.html > "$tempdir/header.html"

    # on génère la date et on la fout dans le footer
    date="$(date)"
    sed "s/GEN_DATE/$date/" "${PWD}"/html/footer.html > "$tempdir/footer.html"

    # conversion du .gmi en .html
    gmnitohtml < $gmi_file > "$tempdir/body.html"

    # on récupère juste le path du dossier qui contient le .gmi
    path="$(dirname $gmi_file)"
    # on récupère juste le nom du fichier .gmi sans son extenstion ".gmi"
    filename="$(basename $gmi_file .gmi)"

    # on assemble les 3 morceaux et on l'écrit dans le dossier du .gmi qui est traité
    cat "$tempdir/header.html" "$tempdir/body.html" "$tempdir/footer.html" > $path/$filename.html

    # on nettoie le dossier de taff
    rm "$tempdir/*"

    # je crois c'est bon
    echo "OK: $gmi_file"

done

# on vire le dossier de taff devenu inutile
rm -rf "$tempdir"

# cette fois c'est vraiment fini
echo "Done."

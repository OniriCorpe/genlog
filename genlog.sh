#!/bin/bash

# on créé un répertoire de taff temporaire pour foutre nos fichiers en cours de traitement dedans
mkdir "${PWD}"/temp/

# on cherche récursivement tous les fichiers ".gmi" dans le dossier "content"
find "${PWD}" -wholename "*.gmi" -type f | while read gmi_file
do

    # récupérer la 1ère ligne du fichier .gmi et remplacer "# " par ""
    title=$(sed -n "1{s/# //p}" $gmi_file)

    # dans le header.html, remplacer "<\-- TITLE -->" par le titre récupéré
    # puis enregistrer le fichier ainsi modifié dans "temp/header.html"
    sed "s/<\!-- TITLE -->/${title//\//\\/}/" "${PWD}"/html/header.html > "${PWD}"/temp/header.html

    # on génère la date et on la fout dans le footer
    date=$(date)
    sed "s/GEN_DATE/$date/" "${PWD}"/html/footer.html > "${PWD}"/temp/footer.html

    # conversion du .gmi en .html
    gmnitohtml < $gmi_file > "${PWD}"/temp/body.html

    # on récupère juste le path du dossier qui contient le .gmi
    path=$(dirname $gmi_file)

    # on assemble les 3 morceaux et on l'écrit dans le dossier du .gmi qui est traité
    cat "${PWD}"/temp/header.html "${PWD}"/temp/body.html "${PWD}"/temp/footer.html > $path/index.html

    # on nettoie le dossier de taff
    rm "${PWD}"/temp/*

    # je crois c'est bon
    echo "OK: $gmi_file"

done

# on vire le dossier de taff devenu inutile
rm -r "${PWD}"/temp/

# cette fois c'est vraiment fini
echo "Done."

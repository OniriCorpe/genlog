import subprocess
import os

entree = os.open("./index.gmi", os.O_RDONLY)
sortie = os.open("./temp.html", os.O_WRONLY)

subprocess.run(
    "gmnitohtml",
    stdin=entree,
    stdout=sortie,
    stderr=None,
    shell=True,
    timeout=None,
)

header = os.open("./html/header.html", os.O_RDONLY)
body = os.open("./temp.html", os.O_RDONLY)
footer = os.open("./html/footer.html", os.O_RDONLY)
fichier = os.open("./out.html", os.O_APPEND)

fichier = header + body + footer
for line in header:
    print(line)

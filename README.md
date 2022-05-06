# genlog

install [scdoc](https://git.sr.ht/~sircmpwn/scdoc) and [gmnitohtml](https://git.sr.ht/~adnano/gmnitohtml)

clone this repo

``` chmod +x genlog.sh ```

your .gmi files are converted in html and concatenated with the html/header.html and the html/footer.html  
the .html file is witen in the directory of the .gmi file which has been treated  
this script will recursively search all .gmi files contained in the "content" folder or a path given as an argument to the script, even in the other folders it includes

feel free to customize the html/header.html and the html/footer.html as you like

please keep the

```HTML
    <title>
        <!-- TITLE -->
    </title>
```

in the html/header.html file if you want your generated pages to have a properly defined title in the HTML

## usage

put your files in the "content" folder
``` ./genlog.sh ```

or

``` ./genlog.sh /path/to/your/choosen/folder ```

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

put your files to be processed in the "content" folder then lauch the script  
``` ./genlog.sh ```

or

you can also put the path to your folder with the files to be processed as the first argument  
``` ./genlog.sh /path/to/your/choosen/folder ```

or

you can optionally add a text at the end of the HTML page title as the second argument  
```./genlog.sh /path/to/your/choosen/folder "Your custom title"```

you can also put your own `header.html` or `footer.html` in the `html/substitutes` folder  
so they will be used instead of the default ones and you can freely personalize them

this project uses the [HotChocolateLicence](https://codeberg.org/OniriCorpe/HotChocolateLicence)

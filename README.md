#############
README
#############


## Submitting content yourself

You can also fork this Blockstream Docs repository and use [Sphinx](http://www.sphinx-doc.org) to generate and run the site locally. This is useful if you want to add new content to the site and are comfortable using Git and markdown. 


### Sphinx installation instructions

Install sphinx and the sphinx_rtd_theme:

```
$ pip3 install sphinx
$ pip3 install sphinx_rtd_theme
```


### Adding, editing and viewing changes locally

Documentation is organized by products, which each have their own folder. Within the folders are `.rst` files that contain markdown that Sphinx uses to generate static html files.

After any changes are made, run the following from your `~/keybase-user.keybase.pub` directory in order to clear the contents of the output directory and rebuild the html files:

```
$ make clean && make keybase-public

OR

$ make clean && make gh-pages
```

To view the generated html files, navigate to `_build/html/` and open `index.html` in your browser.


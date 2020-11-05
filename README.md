#############
README
#############

Sphinx installation instructions
================================

Install sphinx and the sphinx_rtd_theme:
----------------------------------------

``pip3 install sphinx``

``pip3 install sphinx_rtd_theme``


Adding, editing and viewing changes locally
-------------------------------------------

git clone
---------

``git clone https://github.com/RandyMcMillan/randymcmillan.github.io.git ~``

``git clone https://github.com/RandyMcMillan/randymcmillan.keybase.pub.git ~``

keybase
-------

``git remote add keybase keybase://private/randymcmillan/randymcmillan.keybase.pub``

``git push keybase``

build and deploy
----------------

After any changes are made, run the following from your `~/<keybase-user>.keybase.pub` directory in order to clear the contents of the output directory and rebuild the html files:

``cd ~/randymcmillan.keybase.pub``

``make``

OR
--

``make keybase``

``make gh-pages``


To view the generated html files, navigate to ``_build/html/`` and open ``index.html`` in your browser.



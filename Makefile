# Makefile for randymcmillan.keybase.pub

TIME := $(shell date +%s)
export TIME

BASENAME := $(shell basename -s .git `git config --get remote.origin.url`)
export BASENAME

ifeq ($(kbuser),)
# My default change to your keybase user name
KB_USER := randymcmillan
else
KB_USER = $(kbuser)
endif
export KB_USER

ifeq ($(ghuser),)
# My default change to your keybase user name
GH_USER := randymcmillan
else
GH_USER = $(ghuser)
endif
export GH_USER

# Force the user to explicitly select public or private
# export KB_PRIVATE=private && make keybase-private
ifeq ($(KB_PRIVATE),)
KB_PRIVATE := false# change from false to private
else
	@echo "export KB_PRIVATE=private && make keybase-private"
endif
export KB_PRIVATE
# export KB_PUBLIC=public && make keybase-public
ifeq ($(KB_PUBLIC),)
KB_PUBLIC  := public# change from false to public
else
	@echo "export KB_PUBLIC=public && make keybase-public"
endif
export KB_PUBLIC
# You can set these variables from the command line.
SPHINXOPTS            =
SPHINXBUILD           = sphinx-build
PAPER                 =
BUILDDIR              = _build
PRIVATE_BUILDDIR      = _private_build

# Internal variables.
PAPEROPT_a4           = -D latex_paper_size=a4
PAPEROPT_letter       = -D latex_paper_size=letter
ALLSPHINXOPTS         = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
PRIVATE_ALLSPHINXOPTS = -d $(PRIVATE_BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

.PHONY: help
help:
	@echo ""
	@echo "Please use \`make <target>' where <target> is one of"
	@echo ""
	@echo "Keybase usage:"
	@echo ""
	@echo "  make depends"
	@echo "  make all"
	@echo "  make push-all"
	@echo "  make reload"
	@echo "  make rebuild"
	@echo "  make serve"
	@echo ""
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  applehelp  to make an Apple Help Book"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  epub3      to make an epub3"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   to make LaTeX files and run them through pdflatex"
	@echo "  latexpdfja to make LaTeX files and run them through platex/dvipdfmx"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  texinfo    to make Texinfo files"
	@echo "  info       to make Texinfo files and run them through makeinfo"
	@echo "  gettext    to make PO message catalogs"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  xml        to make Docutils-native XML files"
	@echo "  pseudoxml  to make pseudoxml-XML files for display purposes"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"
	@echo "  coverage   to run coverage check of the documentation (if enabled)"
	@echo "  dummy      to check syntax errors of document sources"

.PHONY: depends
depends:
	pip3 install sphinx sphinx_rtd_theme glpi sphinx-reload --user blockcypher
	git remote add keybase keybase://private/$(KB_USER)/$(KB_USER).keybase.pub
	bash -c rm -rf ~/$(GH_USER)/$(GH_USER).github.io
	git clone git@github.com:$(GH_USER)/$(GH_USER).github.io.git ~/$(GH_USER).github.io

.PHONY: all
.ONESHELL:
all: make-kb-gh

.PHONY: push-all
.ONESHELL:
push-all: make-kb-gh
	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master && git push -f keybase +master:master"
	bash -c "cd ~/$(GH_USER).github.io && git add . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"

.PHONY: make-kb-gh
.ONESHELL:
make-kb-gh: keybase gh-pages
	curl https://api.travis-ci.org/bitcoin-core/gui.svg?branch=master --output _static/gui.svg
	curl https://api.travis-ci.org/bitcoin/bitcoin.svg?branch=master  --output _static/bitcoin.svg

.PHONY: reload
.ONESHELL:
reload: keybase gh-pages
	sphinx-reload .

.PHONY: rebuild
.ONESHELL:
rebuild: keybase gh-pages
	rm -rf $(BUILDDIR)/*
	make make-kb-gh

.PHONY: clean
.ONESHELL:
clean:
	bash -c "rm -rf $(BUILDDIR)"

.PHONY: serve
.ONESHELL:
serve: keybase gh-pages
	bash -c "mkdir -p /keybase/public/$(KB_USER)"
	bash -c "python3 -m http.server 8000 -d _build/$(KB_USER).keybase.pub &"

#.PHONY: html
#.ONESHELL:
#html:
#	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
#	@echo
#	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
#	@echo "Build finished. The HTML pages are in $(PWD)/$(BUILDDIR)/html"

#.PHONY: dirhtml
#.ONESHELL:
#dirhtml:
#	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
#	@echo
#	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
#	@echo "Build finished. The HTML pages are in $(PWD)/$(BUILDDIR)/dirhtml"

.PHONY: singlehtml
.ONESHELL:
singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	#bash -c "keybase sign -i $(PWD)/$(BUILDDIR)/singlehtml/index.html -o $(PWD)/$(BUILDDIR)/singlehtml/index.sig"
	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
	@echo "Build finished. The HTML page is in $(PWD)/$(BUILDDIR)/singlehtml"

.PHONY: keybase
.ONESHELL:
keybase:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/$(KB_USER).keybase.pub
	#$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) /keybase/$(KB_PUBLIC)/$(KB_USER)
	@echo
	#bash -c "sudo mkdir -p /keybase/public/$(KB_USER)"
	#bash -c "sudo install -v keybase.txt /keybase/public/$(KB_USER)/keybase.txt"
	#bash -c "keybase sign -i /keybase/public/$(KB_USER)/keybase.txt -o /keybase/public/$(KB_USER)/keybase.txt.sig"
	
	bash -c "keybase sign -i keybase.txt -o keybase.txt.sig"
	bash -c "install -v keybase.txt $(BUILDDIR)/$(KB_USER).keybase.pub/keybase.txt"
	bash -c "install -v keybase.txt.sig $(BUILDDIR)/$(KB_USER).keybase.pub/keybase.txt.sig"
	
	#bash -c "keybase sign -i $(BUILDDIR)/$(KB_USER).keybase.pub/index.html -o  $(BUILDDIR)/$(KB_USER).keybase.pub/index.html.sig"
	#bash -c "keybase sign -i /keybase/$(KB_PUBLIC)/$(KB_USER)/index.html -o /keybase/$(KB_PUBLIC)/$(KB_USER)/index.html.sig"
	
	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
	@echo "Build finished. The HTML page is in $(BUILDDIR)/$(KB_USER).keybase.pub"

#.PHONY: keybase-private
#.ONESHELL:
#keybase-private: html
#	$(SPHINXBUILD) -b singlehtml $(PRIVATE_ALLSPHINXOPTS) /keybase/$(KB_PRIVATE)/$(KB_USER)
#	@echo
#	#bash -c "keybase sign -i /keybase/$(KB_PRIVATE)/$(KB_USER)/index.html -o /keybase/$(KB_PRIVATE)/$(KB_USER)/index.sig"
#	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
#	@echo "Build finished. The HTML page is in /keybase/$(KB_PRIVATE)/$(KB_USER)"

.PHONY: gh-pages
.ONESHELL:
gh-pages:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/$(GH_USER).github.io
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) ~/$(GH_USER).github.io
	@echo
	bash -c "install -v keybase.txt ~/$(GH_USER).github.io/keybase.txt"
	bash -c "keybase sign -i ~/$(GH_USER).github.io/keybase.txt -o ~/$(GH_USER).github.io/keybase.txt.sig"
	
	#bash -c "keybase sign -i ~/$(GH_USER).github.io/index.html -o ~/$(GH_USER).github.io/index.html.sig"
	
	bash -c "keybase sign -i $(PWD)/keybase.txt -o $(BUILDDIR)/$(GH_USER).github.io/keybase.txt.sig"
	bash -c "install -v $(PWD)/keybase.txt $(BUILDDIR)/$(GH_USER).github.io/keybase.txt"
	
	#bash -c "keybase sign -i $(BUILDDIR)/$(GH_USER).github.io/index.html -o  $(BUILDDIR)/$(GH_USER).github.io/index.html.sig"
	
	bash -c "cd ~/$(GH_USER).github.io && git add . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
	@echo "Build finished. The HTML page is in ~/$(GH_USER).github.io"

#.PHONY: pickle
#.ONESHELL:
#pickle:
#	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
#	@echo
#	@echo "Build finished; now you can process the pickle files."

#.PHONY: json
#.ONESHELL:
#json:
#	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
#	@echo
#	@echo "Build finished; now you can process the JSON files."

#.PHONY: htmlhelp
#.ONESHELL:
#htmlhelp:
#	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
#	@echo
#	@echo "Build finished; now you can run HTML Help Workshop with the" \
#	      ".hhp project file in $(BUILDDIR)/htmlhelp."

#.PHONY: qthelp
#.ONESHELL:
#qthelp:
#	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
#	@echo
#	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
#	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
#	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/LiquidNetwork.qhcp"
#	@echo "To view the help file:"
#	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/LiquidNetwork.qhc"

#.PHONY: applehelp
#.ONESHELL:
#applehelp:
#	$(SPHINXBUILD) -b applehelp $(ALLSPHINXOPTS) $(BUILDDIR)/applehelp
#	@echo
#	@echo "Build finished. The help book is in $(BUILDDIR)/applehelp."
#	@echo "N.B. You won't be able to view it unless you put it in" \
#	      "~/Library/Documentation/Help or install it in your application" \
#	      "bundle."

#.PHONY: devhelp
#.ONESHELL:
#devhelp:
#	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
#	@echo
#	@echo "Build finished."
#	@echo "To view the help file:"
#	@echo "# mkdir -p $$HOME/.local/share/devhelp/LiquidNetwork"
#	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/LiquidNetwork"
#	@echo "# devhelp"

#.PHONY: epub
#.ONESHELL:
#epub:
#	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
#	@echo
#	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."
#
#.PHONY: epub3
#.ONESHELL:
#epub3:
#	$(SPHINXBUILD) -b epub3 $(ALLSPHINXOPTS) $(BUILDDIR)/epub3
#	@echo
#	@echo "Build finished. The epub3 file is in $(BUILDDIR)/epub3."
#
#.PHONY: latex
#.ONESHELL:
#latex:
#	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
#	@echo
#	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
#	@echo "Run \`make' in that directory to run these through (pdf)latex" \
#	      "(use \`make latexpdf' here to do that automatically)."
#
#.PHONY: latexpdf
#.ONESHELL:
#latexpdf:
#	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
#	@echo "Running LaTeX files through pdflatex..."
#	$(MAKE) -C $(BUILDDIR)/latex all-pdf
#	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."
#
#.PHONY: latexpdfja
#.ONESHELL:
#latexpdfja:
#	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
#	@echo "Running LaTeX files through platex and dvipdfmx..."
#	$(MAKE) -C $(BUILDDIR)/latex all-pdf-ja
#	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

.PHONY: text
.ONESHELL:
text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

#.PHONY: man
#.ONESHELL:
#man:
#	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
#	@echo
#	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

#.PHONY: texinfo
#.ONESHELL:
#texinfo:
#	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
#	@echo
#	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
#	@echo "Run \`make' in that directory to run these through makeinfo" \
#	      "(use \`make info' here to do that automatically)."

#.PHONY: info
#.ONESHELL:
#info:
#	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
#	@echo "Running Texinfo files through makeinfo..."
#	make -C $(BUILDDIR)/texinfo info
#	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

#.PHONY: gettext
#.ONESHELL:
#gettext:
#	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
#	@echo
#	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."
#
#.PHONY: changes
#.ONESHELL:
#changes:
#	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
#	@echo
#	@echo "The overview file is in $(BUILDDIR)/changes."
#
#.PHONY: linkcheck
#.ONESHELL:
#linkcheck:
#	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
#	@echo
#	@echo "Link check complete; look for any errors in the above output " \
#	      "or in $(BUILDDIR)/linkcheck/output.txt."
#
#.PHONY: doctest
#.ONESHELL:
#doctest:
#	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
#	@echo "Testing of doctests in the sources finished, look at the " \
#	      "results in $(BUILDDIR)/doctest/output.txt."
#
#.PHONY: coverage
#.ONESHELL:
#coverage:
#	$(SPHINXBUILD) -b coverage $(ALLSPHINXOPTS) $(BUILDDIR)/coverage
#	@echo "Testing of coverage in the sources finished, look at the " \
#	      "results in $(BUILDDIR)/coverage/python.txt."
#
#.PHONY: xml
#.ONESHELL:
#xml:
#	$(SPHINXBUILD) -b xml $(ALLSPHINXOPTS) $(BUILDDIR)/xml
#	@echo
#	@echo "Build finished. The XML files are in $(BUILDDIR)/xml."
#
#.PHONY: pseudoxml
#.ONESHELL:
#pseudoxml:
#	$(SPHINXBUILD) -b pseudoxml $(ALLSPHINXOPTS) $(BUILDDIR)/pseudoxml
#	@echo
#	@echo "Build finished. The pseudo-XML files are in $(BUILDDIR)/pseudoxml."
#
#.PHONY: dummy
#.ONESHELL:
#dummy:
#	$(SPHINXBUILD) -b dummy $(ALLSPHINXOPTS) $(BUILDDIR)/dummy
#	@echo
#	@echo "Build finished. Dummy builder generates no files."
#

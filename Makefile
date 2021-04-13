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

# Force the user to explicitly select public - public=true
# export KB_PUBLIC=public && make keybase-public
ifeq ($(public),true)
KB_PUBLIC  := public
else
KB_PUBLIC  := private
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
	git remote add keybase keybase://$(KB_PUBLIC)/$(KB_USER)/$(KB_USER).keybase.pub
	bash -c rm -rf ~/$(GH_USER)/$(GH_USER).github.io
	#git remote add github git@github.com:$(GH_USER)/$(GH_USER).github.io.git
	git clone git@github.com:$(GH_USER)/$(GH_USER).github.io.git ~/$(GH_USER).github.io

.PHONY: all
.ONESHELL:
all: make-kb-gh

.PHONY: make-kb-gh
.ONESHELL:
make-kb-gh: keybase gh-pages
	curl https://api.travis-ci.org/bitcoin-core/gui.svg?branch=master --output _static/gui.svg
	curl https://api.travis-ci.org/bitcoin/bitcoin.svg?branch=master  --output _static/bitcoin.svg

.PHONY: push-all
.ONESHELL:
push-all: make-kb-gh
	bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)'"
	git push -f origin	+master:master
	git push -f keybase	+master:master
	git push -f github	+master:master
	#bash -c "pushd ~/$(GH_USER).github.io && git add * && git pull -f https://github.com/randymcmillan/randymcmillan.keybase.io && git push -f origin +master:master"
	bash -c "pushd ~/$(GH_USER).github.io && git add * && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"

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
	bash -c "mkdir -p /keybase/$(KB_PUBLIC.keybase.io)/$(KB_USER)"
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
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/$(GH_USER).github.io
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/$(KB_USER).keybase.pub
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) /keybase/$(KB_PUBLIC)/$(KB_USER)
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) ~/$(GH_USER).github.io
	@echo
	#bash -c "keybase sign -i $(PWD)/$(BUILDDIR)/singlehtml/index.html -o $(PWD)/$(BUILDDIR)/singlehtml/index.sig"
	#bash -c "git add _build _static . && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
	@echo "Build finished. The HTML page is in $(PWD)/$(BUILDDIR)/singlehtml"

.PHONY: keybase
.ONESHELL:
keybase: singlehtml
	@echo
	bash -c "keybase sign -i			/keybase/$(KB_PUBLIC)/$(KB_USER)/keybase.txt -o /keybase/$(KB_PUBLIC)/$(KB_USER)/keybase.txt.sig"
	bash -c "keybase sign -i			/keybase/$(KB_PUBLIC)/$(KB_USER)/index.html  -o /keybase/$(KB_PUBLIC)/$(KB_USER)/index.html.sig"
	bash -c "keybase sign -i			keybase.txt -o keybase.txt.sig"
	bash -c "install -v					keybase.txt     $(BUILDDIR)/$(KB_USER).keybase.pub/keybase.txt"
	bash -c "install -v					keybase.txt.sig $(BUILDDIR)/$(KB_USER).keybase.pub/keybase.txt.sig"
	bash -c "keybase sign -i			$(BUILDDIR)/$(KB_USER).keybase.pub/index.html -o  $(BUILDDIR)/$(KB_USER).keybase.pub/index.html.sig"
	bash -c "keybase sign -i			/keybase/$(KB_PUBLIC)/$(KB_USER)/index.html   -o /keybase/$(KB_PUBLIC)/$(KB_USER)/index.html.sig"
	bash -c "git add -f _build _static *&& git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
	@echo "Build finished. The HTML page is in $(BUILDDIR)/$(KB_USER).keybase.pub"

.PHONY: gh-pages
.ONESHELL:
gh-pages: singlehtml
	@echo
	bash -c "install -v keybase.txt ~/$(GH_USER).github.io/keybase.txt"
	bash -c "keybase sign -i ~/$(GH_USER).github.io/keybase.txt -o ~/$(GH_USER).github.io/keybase.txt.sig"
	bash -c "keybase sign -i ~/$(GH_USER).github.io/index.html -o ~/$(GH_USER).github.io/index.html.sig"
	bash -c "keybase sign -i $(BUILDDIR)/$(GH_USER).github.io/index.html -o  $(BUILDDIR)/$(GH_USER).github.io/index.html.sig"
	bash -c "cd ~/$(GH_USER).github.io && \
		touch $(TIME)
		git add -f * && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"
	@echo "Build finished. The HTML page is in ~/$(GH_USER).github.io"

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

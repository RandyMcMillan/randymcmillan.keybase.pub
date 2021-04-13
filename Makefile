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
	@echo "Keybase usage:"
	@echo ""
	@echo "  make depends"
	@echo "  make all"
	@echo "  make push-all"
	@echo "  make reload"
	@echo "  make rebuild"
	@echo "  make serve"
	@echo ""
	@echo "  make singlehtml"
	@echo ""
	@echo "Example:"
	@echo ""
	@echo "make push-all public=true"
	@echo ""
	@echo ""

.PHONY: depends
depends:
																	#????
	pip3 install sphinx sphinx_rtd_theme glpi sphinx-reload --user blockcypher
	#make depends public=true
	git remote remove keybase
	git remote add keybase keybase://$(KB_PUBLIC)/$(KB_USER)/$(KB_USER).keybase.pub
	bash -c "[ -d '~/$(GH_USER).github.io' ] && echo  || rm -rf ~/$(GH_USER).github.io"
	#git remote add github git@github.com:$(GH_USER)/$(GH_USER).github.io.git
	git clone git@github.com:$(GH_USER)/$(GH_USER).github.io.git ~/$(GH_USER).github.io

.PHONY: all
.ONESHELL:
all: make-kb-gh

.PHONY: make-kb-gh
.ONESHELL:
make-kb-gh: singlehtml keybase gh-pages
	curl https://api.travis-ci.org/bitcoin-core/gui.svg?branch=master --output _static/gui.svg
	curl https://api.travis-ci.org/bitcoin/bitcoin.svg?branch=master  --output _static/bitcoin.svg

.PHONY: push-all
.ONESHELL:
push-all: make-kb-gh
	bash -c "git add _build _static * && \
		git commit -m 'update from $(BASENAME) on $(TIME)'"
	git push -f origin	+master:master
	git push -f keybase	+master:master
	#bash -c "pushd ~/$(GH_USER).github.io && git add * && git pull -f https://github.com/randymcmillan/randymcmillan.keybase.io && git push -f origin +master:master"
	bash -c "pushd ~/$(GH_USER).github.io && git add * && git commit -m 'update from $(BASENAME) on $(TIME)' && git push -f origin +master:master"

.PHONY: reload
.ONESHELL:
reload:
	sphinx-reload .

.PHONY: rebuild
.ONESHELL:
rebuild: clean keybase gh-pages
	make make-kb-gh

.PHONY: clean
.ONESHELL:
clean:
	bash -c "rm -rf $(BUILDDIR)"

.PHONY: serve
.ONESHELL:
serve: keybase gh-pages
	bash -c "python3 -m http.server 8000 -d _build/$(KB_USER).keybase.pub &"

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
keybase:
	@echo keybase
	@echo if error ensure these files exist...
	bash -c "keybase sign -i			/keybase/$(KB_PUBLIC)/$(KB_USER)/keybase.txt -o /keybase/$(KB_PUBLIC)/$(KB_USER)/keybase.txt.sig"
	bash -c "keybase sign -i			/keybase/$(KB_PUBLIC)/$(KB_USER)/index.html  -o /keybase/$(KB_PUBLIC)/$(KB_USER)/index.html.sig"
	bash -c "git add -f _build/randymcmillan.github.io/index.html.sig"
	bash -c "keybase sign -i			keybase.txt -o keybase.txt.sig"
	
	bash -c "install -v					keybase.txt     $(BUILDDIR)/$(KB_USER).keybase.pub/keybase.txt"
	bash -c "install -v					keybase.txt.sig $(BUILDDIR)/$(KB_USER).keybase.pub/keybase.txt.sig"
	bash -c "keybase sign -i			$(BUILDDIR)/$(KB_USER).keybase.pub/index.html -o  $(BUILDDIR)/$(KB_USER).keybase.pub/index.html.sig"
	bash -c "keybase sign -i			/keybase/$(KB_PUBLIC)/$(KB_USER)/index.html   -o /keybase/$(KB_PUBLIC)/$(KB_USER)/index.html.sig"
	bash -c "touch $(TIME)"
	bash -c "git status"
	bash -c "git add -f _build _static * && \
		git commit -m 'update from $(BASENAME) on $(TIME)' && \
		git push -f origin +master:master"
	@echo "Build finished. The HTML page is in $(BUILDDIR)/$(KB_USER).keybase.pub"

.PHONY: gh-pages
.ONESHELL:
gh-pages:
	@echo gh-pages
	bash -c "install -v keybase.txt ~/$(GH_USER).github.io/keybase.txt"
	bash -c "keybase sign -i ~/$(GH_USER).github.io/keybase.txt -o ~/$(GH_USER).github.io/keybase.txt.sig"
	bash -c "keybase sign -i ~/$(GH_USER).github.io/index.html -o ~/$(GH_USER).github.io/index.html.sig"
	bash -c "keybase sign -i $(BUILDDIR)/$(GH_USER).github.io/index.html -o  $(BUILDDIR)/$(GH_USER).github.io/index.html.sig"
	bash -c "git add -f _build/randymcmillan.github.io/index.html.sig"
	bash -c "cd ~/$(GH_USER).github.io && \
		touch $(TIME) && \
		git status && \
		git add -f * && git commit -m 'update from $(BASENAME) on $(TIME)' && \
		git push -f origin +master:master"
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

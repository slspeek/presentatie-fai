MAINNAME=automatiseer-installatie-en-configuratie
HANDOUT_NAME=$(MAINNAME)-handout
BEAMER_NAME=$(MAINNAME)-beamer
HANDOUT_PDF=$(HANDOUT_NAME).pdf
BEAMER_PDF=$(BEAMER_NAME).pdf
LATEX_IMAGE=leplusorg/latex:sha-4a17317
PDFLATEX_FLAGS=--interaction batchmode
PDFLATEX=docker run --rm -t --workdir=/tmp --user="$(shell id -u):$(shell id -g)" --net=none  -v "$(shell pwd):/tmp"  $(LATEX_IMAGE) pdflatex $(PDFLATEX_FLAGS)
BEAMER_CMD=$(PDFLATEX) -jobname=$(BEAMER_NAME) $(MAINNAME).tex
HANDOUT_CMD=$(PDFLATEX) -jobname=$(HANDOUT_NAME) "\PassOptionsToClass{handout}{beamer}\input{$(MAINNAME)}"
SPELLCHECK_CMD=aspell check -t -p $(PWD)/aspell.ignore.list -l nl $(MAINNAME).tex
LINKCHECK_CMD=$(HOME)/.local/bin/pdfx -c $(BEAMER_PDF)

.PHONY: all clean viewbeamer viewhandout spellcheck

default: viewbeamer

install_deps:
		sudo apt update
		sudo apt install -y aspell aspell-nl pipx
		pipx install pdfx

spellcheck:
		$(SPELLCHECK_CMD)

linkcheck: $(BEAMER_PDF)
		$(LINKCHECK_CMD)

all: $(BEAMER_PDF) $(HANDOUT_PDF)

$(BEAMER_PDF): $(MAINNAME).tex
		$(BEAMER_CMD)
		$(BEAMER_CMD)

$(HANDOUT_PDF): $(MAINNAME).tex
		$(HANDOUT_CMD)
		$(HANDOUT_CMD)

viewhandout: 
		$(HANDOUT_CMD)
		open $(HANDOUT_PDF)
	
viewbeamer: 
		$(BEAMER_CMD)
		open $(BEAMER_PDF)

clean:
		rm {tex/,}*.aux *.aux *.nav *.snm *.lg *.4* *.image.* *.htoc *.html *.css *.dvi *.haux *.pdf *.log *.out *.idv *.tmp *.xref *.toc; exit 0

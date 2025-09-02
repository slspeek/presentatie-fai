MAINNAME=presentatie-fai
HANDOUT_NAME=$(MAINNAME)-handout
BEAMER_NAME=$(MAINNAME)-beamer
LATEX_IMAGE=leplusorg/latex:sha-4a17317
PDFLATEX=docker run --rm -t --workdir=/tmp --user="$(shell id -u):$(shell id -g)" --net=none  -v "$(shell pwd):/tmp"  $(LATEX_IMAGE) pdflatex --interaction batchmode
BEAMER=$(PDFLATEX) -jobname=$(BEAMER_NAME) $(MAINNAME).tex
HANDOUT=$(PDFLATEX) -jobname=$(HANDOUT_NAME) "\PassOptionsToClass{handout}{beamer}\input{$(MAINNAME)}"

default: clean viewbeamer

beamer:
		$(BEAMER); $(BEAMER)

handout:
		$(HANDOUT); $(HANDOUT)

viewhandout: handout
		open $(HANDOUT_NAME).pdf
	
viewbeamer: beamer
		open $(BEAMER_NAME).pdf

clean:
		rm {tex/,}*.aux *.aux *.nav *.snm *.lg *.4* *.image.* *.htoc *.html *.css *.dvi *.haux *.pdf *.log *.out *.idv *.tmp *.xref *.toc; exit 0

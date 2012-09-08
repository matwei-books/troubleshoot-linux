# Makefile for buch-troubleshooting-linux
#

DOCBASENAME=troubleshoot-linux
PDFLATEX=pdflatex
BIBTEX=-bibtex

OBJFILES = tl-vorwort tl-lokal-werkzeuge

ifdef VERSION
  TEXPREFILE:=$(TEXPREFILE)\newcommand{\selectversion}{\version$(VERSION)}
endif
TEXPREFILE:=$(TEXPREFILE)\input 

TEXFILES = $(addsuffix .tex, $(OBJFILES))

INTERMEDIATE = *.dvi *.cb *.aux *.toc *.lof *.log *.out *.bbl *.blg *.lot *.idx *.ilg *.brf *.ind *.url *~ *.mpx *.flc *.tmp *.cb *.4ct *.4tc *.idv *.lg *.xref *.pnd *.pdx *.ilg

pdf: $(DOCBASENAME).pdf

$(DOCBASENAME).pdf: $(TEXFILES)

## Implicit Document Rules

%.pdf : %.tex
	$(PDFLATEX) -jobname=$* '$(TEXPREFILE)$<'
	$(BIBTEX) $*
	$(PDFLATEX) -jobname=$* '$(TEXPREFILE)$<'
	$(PDFLATEX) -jobname=$* '$(TEXPREFILE)$<'
	$(PDFLATEX) -jobname=$* '$(TEXPREFILE)$<'


clean:
	rm -f $(INTERMEDIATE)

distclean: clean
	rm -f *.pdf *.ps

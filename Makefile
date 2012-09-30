# Makefile for big documents
# (c) 2005-2007 by Joachim Schlosser
# no warranty of any kind.
#
# short usage:
# > make
# creates PDF document with default settings (including comments and notes)

LATEX=latex
PDFLATEX=pdflatex
BIBTEX=-bibtex8 --wolfgang
MAKEINDEX=makeindex -c -g -l -s myindex.ist
LATEXDIFF=latexdiff-so --encoding=latin1 --subtype=DVIPSCOL --append-safecmd="svnInfo" --exclude-textcmd="chapter,section,subsection,subsubsection"
#--type=CULINECHBAR 
PDFCOMPRESS=java -cp Multivalent.jar tool.pdf.Compress  
GRAPHICPATH=graphic
DOCBASENAME=troubleshoot-linux
comma:= ,
empty:=
space:= $(empty) $(empty)

#OBJFILES=\
#  tl-vorwort \
#  tl-methoden \
#  tl-heuristiken \
#  tl-herangehen \
#  tl-lokal-werkzeuge \
#  tl-lokal-bootprobleme \
#  tl-lokal-programmfehler \
#  tl-lokal-performance \
#  tl-netz-werkzeuge \
#  tl-netz-totalausfall \
#  tl-netz-teilausfall \
#  tl-netz-performance \
#  tl-ausblick \
#

# Alle TeX-Quelldateien definieren (Beispiel für zweistufige Hierarchien)
FRONTMATTER = tl-vorwort
TLGRUNDLAGEN = tl-methoden tl-heuristiken tl-herangehen
TLLOKAL = tl-lokal-werkzeuge tl-lokal-bootprobleme tl-lokal-programmfehler \
  tl-lokal-performance
TLNETZ = tl-netz-werkzeuge tl-netz-totalausfall tl-netz-teilausfall \
  tl-netz-performance
TLAUSBLICK = tl-ausblick
BACKMATTER = anhang

OBJFILES = $(DOCBASENAME) $(FRONTMATTER) $(TLGRUNDLAGEN) $(TLLOKAL) $(TLNETZ) $(TLAUSBLICK) $(BACKMATTER)

# Kapitel zusammen erzeugen
ifdef ONLY
override ONLY := $(subst frontmatter-kap,$(FRONTMATTER),$(ONLY))
override ONLY := $(subst einfuehrung-kap,$(TLGRUNDLAGEN),$(ONLY))
override ONLY := $(subst elemente-kap,$(TLLOKAL),$(ONLY))
override ONLY := $(subst fertigstellen-kap,$(TLNETZ),$(ONLY))
endif

# Vorbereiten für diff: suffix für Dateinamen, auch bei ONLY
ifeq (${MAKECMDGOALS},diff)
override FILESUFFIX:=-diff
TEXPREFILE :=\newcommand{\includesuffix}{$(FILESUFFIX)}$(TEXPREFILE)
ifdef ONLY
override ONLY := $(addsuffix $(FILESUFFIX), $(subst $(comma),$(space),$(ONLY)))
endif
endif
# Mechanismus für Erzeugen verschiedener Inhaltsversionen
ifdef VERSION
TEXPREFILE:=$(TEXPREFILE)\newcommand{\selectversion}{\version$(VERSION)}
endif
TEXPREFILE:=$(TEXPREFILE)\input 
# Mechanismus für Erzeugen einzelner Dokumentteile
ifdef ONLY
# erster Lauf: nur gewählte + Anhang (Literatur) erzeugen, für BibTeX-Aufruf
TEXPREFILE1:=\includeonly{$(subst $(space),$(comma),$(ONLY) $(BACKMATTER))}$(TEXPREFILE)
# zweiter Lauf: alles erzeugen, damit Verweise auf Seitenzahlen und Seitenzahlen stimmen
TEXPREFILE2:=$(TEXPREFILE)
# dritter Lauf: nur gewählte erzeugen. Seitenzahlen sind korrekt.
TEXPREFILE3:=\includeonly{$(subst $(space),$(comma),$(ONLY))}$(TEXPREFILE)
else
# bei Gesamtdokument sind alle teilstufen gleich
TEXPREFILE1:=$(TEXPREFILE)
TEXPREFILE2:=$(TEXPREFILE)
TEXPREFILE3:=$(TEXPREFILE)
endif

#ifdef RTAG
#ifeq (,$(findstring D,$(RTAG)))
#override RTAG := r$(RTAG)
#endif
#endif
#RTAG=Dnow
ifndef RTAG
RTAG:=COMMITTED
endif

TEXFILES = $(addsuffix .tex, $(OBJFILES))

DIFFFILES = $(addsuffix -diff.tex, $(OBJFILES))

INTERMEDIATE = *.dvi *.cb *.aux *.toc *.lof *.log *.out *.bbl *.blg *.lot *.idx *.ilg *.brf *.ind *.url *~ *.mpx *.flc *.tmp *.cb *.4ct *.4tc *.idv *.lg *.xref *.pnd *.pdx *.ilg

MPFILES = $(wildcard $(GRAPHICPATH)/*.mp)

MPXFILES = $(addsuffix .log, $(basename $(MPFILES)))

EPSFILES=$(wildcard $(GRAPHICPATH)/*.eps)


ifndef QUICK
# folgende Zeile nur nehmen, wenn PSTricks oder psfrag zum Einsatz kommt.
# pdf: graphic-pdf graphic $(DOCBASENAME)-pics.pdf $(DOCBASENAME).pdf
pdf: graphic-pdf graphic $(DOCBASENAME).pdf
else
pdf: $(DOCBASENAME).pdf
endif

## Main Targets
all: graphic pdf 

ps: graphic-ps graphic $(DOCBASENAME).ps

graphic: mpx eps 

mpx: $(MPXFILES)

eps: $(addsuffix .pdf, $(basename $(EPSFILES)))

html: $(DOCBASENAME).html

htmlbib: globalbib.html

dvi: graphic-dvi mpx $(DOCBASENAME).dvi

diff: $(DOCBASENAME)-diff.pdf

## Clean Targets
allclean: clean beispielclean

clean:
	rm -f $(DIFFFILES)
	rm -f $(INTERMEDIATE) 
	rm -fR _*

graphicclean:
	rm -f $(addprefix $(GRAPHICPATH)/, $(INTERMEDIATE))
	rm -f $(GRAPHICPATH)/*.pdf $(GRAPHICPATH)/*.ps

distclean: clean
	rm -f *.pdf *.ps 

htmlclean: clean
	rm -f *.html *.css *.png *.gif


## Explicit Rules
$(DOCBASENAME).html $(DOCBASENAME).pdf $(DOCBASENAME).dvi: $(TEXFILES) graphics

$(DOCBASENAME)-diff.pdf: $(DIFFFILES) $(DOCBASENAME)-diff.ps
	ps2pdf $(DOCBASENAME)-diff.ps

$(DOCBASENAME)-pics.pdf: $(DOCBASENAME).tex
	$(LATEX) -job-name=$(DOCBASENAME) '\def\pstpdfinactive{}$(TEXPREFILE3)$(DOCBASENAME).tex'
	dvips -Ppdf -o $(DOCBASENAME)-pics.ps $(DOCBASENAME).dvi
	ps2pdf $(DOCBASENAME)-pics.ps

## Diff Rules
$(DOCBASENAME)-diff.tex: $(DOCBASENAME).tex
	$(LATEXDIFF) --show-preamble | tail --lines=+3 > $@
	cat $< >> $@

ifdef ONLY
%-diff.tex: %.tex %-old.aux
	echo $(addsuffix .tex, $(ONLY)) | grep $@ && ( \
	grep -v svnInfo $< > $*-new.aux; \
	$(LATEXDIFF) $*-old.aux $*-new.aux > $@; \
	) || ( \
	cp $< $@; \
	)

%-old.aux:
	echo $(addsuffix .tex, $(ONLY)) | grep $@ && ( \
	svn cat -r $(RTAG) $< | grep -v svnInfo > $*-old.aux; \
	) || ( \
	touch $@; \
	)	
else
%-old.aux:
	svn cat -r $(RTAG) $< | grep -v svnInfo > $*-old.aux;

%-diff.tex: %.tex %-old.aux
	grep -v svnInfo $< > $*-new.aux
	$(LATEXDIFF) $*-old.aux $*-new.aux > $@
endif

## Implicit Graphics Rules
%.pdf: %.eps
	epstopdf $<

%.log: %.mp
	cd $(dir $<) && mpost $(notdir $<)
	cd $(dir $<) && mpost $(notdir $<)

## Implicit Document Rules

%.pdf : %.tex
	$(PDFLATEX) -job-name=$* '\def\pstpdfinactive{}$(TEXPREFILE1)$<'; 
ifndef QUICK
	if test -f $*.idx; then $(MAKEINDEX) $*; fi; 
	if test -f $*.pdx; then $(MAKEINDEX) -o $*.pnd $*.pdx; fi; 
	$(BIBTEX) $*
	$(PDFLATEX) -job-name=$* '\def\pstpdfinactive{}$(TEXPREFILE2)$<'; 
	$(PDFLATEX) -job-name=$* '\def\pstpdfinactive{}$(TEXPREFILE2)$<'; 
	$(PDFLATEX) -job-name=$* '\def\pstpdfinactive{}$(TEXPREFILE3)$<'; 
endif

%.ps : %.dvi
	dvips -o $@ -Ppdf $<

%.dvi : %.tex
	-$(LATEX) -job-name=$* '$(TEXPREFILE1)$<'
ifndef QUICK
	if test -f $*.idx; then $(MAKEINDEX) $*; fi
	$(BIBTEX) $*
	-$(LATEX) -job-name=$* '$(TEXPREFILE2)$<'
	-$(LATEX) -job-name=$* '$(TEXPREFILE2)$<'
	$(LATEX) -job-name=$* '$(TEXPREFILE3)$<'
endif

%.pdf: %.ps
	ps2pdf.bat $<

%.html: %.tex
	echo '$(TEXPREFILE3)$<' > $*-ht.tex
	htlatex.bat $*-ht.tex "xhtml,0,fn-in,NoFonts,fonts,graphics-,sections+,css-in,info"

%.html: %.bib
	bib2html -s geralpha $<

graphic-dvi: $(addsuffix .dvi, $(BEISPIEL))

graphic-ps: $(addsuffix .ps, $(BEISPIEL))

graphic-pdf: $(addsuffix .pdf, $(BEISPIEL)) 

$(GRAPHICPATH)/%.pdf: $(GRAPHICPATH)/%.dvi 
	dvips -o $(@D)/$*.eps -E $<
	epstopdf $(@D)/$*.eps

.PRECIOUS: %.aux %.bbl %.toc %.dvi %.ps

.PHONY: clean distclean htmlclean graphics all pdf dvi



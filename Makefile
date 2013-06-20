# Makefile for leanpub / dropbox

BOOK = Book.txt
PREVIEW = Preview.txt
SAMPLE = Sample.txt

DROPBOXDIR = manuscript

DROPBOXFILES = $(DROPBOXDIR)/$(BOOK) \
               $(DROPBOXDIR)/$(PREVIEW) \
               $(DROPBOXDIR)/$(SAMPLE) \
               $(DROPBOXDIR)/preface.mdwn \
               $(DROPBOXDIR)/chapter01.mdwn \
               $(DROPBOXDIR)/chapter02.mdwn \
               $(DROPBOXDIR)/chapter03.mdwn \
               $(DROPBOXDIR)/chapter04.mdwn \
               $(DROPBOXDIR)/chapter05.mdwn \
               $(DROPBOXDIR)/chapter06.mdwn \
               $(DROPBOXDIR)/chapter07.mdwn \
               $(DROPBOXDIR)/chapter08.mdwn \
               $(DROPBOXDIR)/chapter09.mdwn \
               $(DROPBOXDIR)/chapter10.mdwn \
               $(DROPBOXDIR)/chapter11.mdwn \
               $(DROPBOXDIR)/chapter12.mdwn \
               $(DROPBOXDIR)/images/eb-allgemein.png \
#
CHAPTERS = \
    preface.mdwn \
    chapter01.mdwn \
    chapter02.mdwn \
    chapter03.mdwn \
    chapter04.mdwn \
    chapter05.mdwn \
    chapter06.mdwn \
    chapter07.mdwn \
    chapter08.mdwn \
    chapter09.mdwn \
    chapter10.mdwn \
    chapter11.mdwn \
    chapter12.mdwn \
#
IMAGES = \
    images/eb-allgmein.png \
#
$(DROPBOXDIR)/%.mdwn: %.mdwn
	cp $< $@

$(DROPBOXDIR)/%.txt: %.txt
	cp $< $@

$(DROPBOXDIR)/code/%: code/%
	cp $< $@

$(DROPBOXDIR)/images/%.jpg: images/%.jpg
	cp $< $@

$(DROPBOXDIR)/images/%.png: images/%.png
	cp $< $@

all:

dropbox: $(DROPBOXFILES)

# end of Makefile

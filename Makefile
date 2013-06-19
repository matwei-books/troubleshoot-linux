# Makefile for leanpub / dropbox

BOOK = Book.txt
PREVIEW = Preview.txt
SAMPLE = Sample.txt

DROPBOXDIR = manuscript

DROPBOXFILES = $(DROPBOXDIR)/$(BOOK) \
               $(DROPBOXDIR)/$(PREVIEW) \
               $(DROPBOXDIR)/$(SAMPLE) \
#
CHAPTERS = \
#
IMAGES = \
#
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

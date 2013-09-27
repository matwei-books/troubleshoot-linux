# Makefile for leanpub / dropbox

BOOK = Book.txt
PREVIEW = Preview.txt
SAMPLE = Sample.txt

DROPBOXDIR = manuscript

DROPBOXFILES = $(DROPBOXDIR)/$(BOOK) \
               $(DROPBOXDIR)/$(PREVIEW) \
               $(DROPBOXDIR)/$(SAMPLE) \
               $(DROPBOXDIR)/preface.mdwn \
               $(DROPBOXDIR)/ch-1-methoden-empty.mdwn \
               $(DROPBOXDIR)/chapter03-empty.mdwn \
               $(DROPBOXDIR)/chapter04-empty.mdwn \
               $(DROPBOXDIR)/chapter05-empty.mdwn \
               $(DROPBOXDIR)/chapter06-empty.mdwn \
               $(DROPBOXDIR)/chapter07-empty.mdwn \
               $(DROPBOXDIR)/chapter08-empty.mdwn \
               $(DROPBOXDIR)/chapter09-empty.mdwn \
               $(DROPBOXDIR)/chapter10-empty.mdwn \
               $(DROPBOXDIR)/chapter11-empty.mdwn \
               $(DROPBOXDIR)/chapter12-empty.mdwn \
               $(DROPBOXDIR)/ch-1-methoden.mdwn \
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
               $(DROPBOXDIR)/literatur.mdwn \
               $(DROPBOXDIR)/part1.mdwn \
               $(DROPBOXDIR)/part2.mdwn \
               $(DROPBOXDIR)/part3.mdwn \
	       $(DROPBOXDIR)/code/http-injector.pl \
	       $(DROPBOXDIR)/code/read-syslog.pl \
	       $(DROPBOXDIR)/code/strace-invocator.sh \
               $(DROPBOXDIR)/images/eb-allgemein.png \
               $(DROPBOXDIR)/images/eb-netz-totalausfall-rechner.png \
#
CHAPTERS = \
    preface.mdwn \
    ch-1-methoden.mdwn \
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
    literatur.mdwn \
#
IMAGES = \
    images/eb-allgmein.png \
#
$(DROPBOXDIR)/%.mdwn: %.mdwn
	cp $< $@

$(DROPBOXDIR)/%-empty.mdwn: %.mdwn
	grep '^#' $< | grep -v '## Tip' | sed -e 's/^/\n/' > $@

$(DROPBOXDIR)/%.txt: %.txt
	cp $< $@

$(DROPBOXDIR)/code/%: code/% $(DROPBOXDIR)/code
	cp $< $@

$(DROPBOXDIR)/code: $(DROPBOXDIR)
	mkdir -p $(DROPBOXDIR)/code

$(DROPBOXDIR)/images/%.jpg: images/%.jpg
	cp $< $@

$(DROPBOXDIR)/images/%.png: images/%.png
	cp $< $@

all:

dropbox: $(DROPBOXFILES)

preview: dropbox
	leanpub preview

status:
	leanpub job_status

# end of Makefile

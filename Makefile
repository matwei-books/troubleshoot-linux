# Makefile for leanpub / dropbox

BOOK = Book.txt
PREVIEW = Preview.txt
SAMPLE = Sample.txt

DROPBOXDIR = manuscript

DROPBOXFILES = $(DROPBOXDIR)/$(BOOK) \
               $(DROPBOXDIR)/$(PREVIEW) \
               $(DROPBOXDIR)/$(SAMPLE) \
               $(DROPBOXDIR)/preface.mdwn \
               $(DROPBOXDIR)/cha-methoden-empty.mdwn \
               $(DROPBOXDIR)/cha-herangehen-empty.mdwn \
               $(DROPBOXDIR)/cha-nachbearbeitung-empty.mdwn \
               $(DROPBOXDIR)/cha-lokal-total-empty.mdwn \
               $(DROPBOXDIR)/cha-lokal-teil-empty.mdwn \
               $(DROPBOXDIR)/cha-lokal-perform-empty.mdwn \
               $(DROPBOXDIR)/cha-lokal-werkzeuge-empty.mdwn \
               $(DROPBOXDIR)/cha-netz-total-empty.mdwn \
               $(DROPBOXDIR)/cha-netz-teil-empty.mdwn \
               $(DROPBOXDIR)/cha-netz-perform-empty.mdwn \
               $(DROPBOXDIR)/cha-netz-werkzeuge-empty.mdwn \
               $(DROPBOXDIR)/cha-methoden.mdwn \
               $(DROPBOXDIR)/cha-herangehen.mdwn \
               $(DROPBOXDIR)/cha-nachbearbeitung.mdwn \
               $(DROPBOXDIR)/cha-lokal-total.mdwn \
               $(DROPBOXDIR)/cha-lokal-teil.mdwn \
               $(DROPBOXDIR)/cha-lokal-perform.mdwn \
               $(DROPBOXDIR)/cha-lokal-werkzeuge.mdwn \
               $(DROPBOXDIR)/cha-netz-total.mdwn \
               $(DROPBOXDIR)/cha-netz-teil.mdwn \
               $(DROPBOXDIR)/cha-netz-perform.mdwn \
               $(DROPBOXDIR)/cha-netz-werkzeuge.mdwn \
               $(DROPBOXDIR)/literatur.mdwn \
               $(DROPBOXDIR)/part1.mdwn \
               $(DROPBOXDIR)/part2.mdwn \
               $(DROPBOXDIR)/part3.mdwn \
	       $(DROPBOXDIR)/code/http-injector.pl \
	       $(DROPBOXDIR)/code/read-syslog.pl \
	       $(DROPBOXDIR)/code/strace-invocator.sh \
               $(DROPBOXDIR)/images/eb-allgemein-drakon.png \
               $(DROPBOXDIR)/images/eb-allgemein.png \
               $(DROPBOXDIR)/images/eb-allgemein-yed.png \
               $(DROPBOXDIR)/images/eb-netz-totalausfall-rechner.png \
               $(DROPBOXDIR)/images/tcp-handshake-fail.png \
               $(DROPBOXDIR)/images/tcp-handshake.png \
               $(DROPBOXDIR)/images/tcp-shutdown.png \
#

SOURCES = $(BOOK) \
          $(PREVIEW) \
          $(SAMPLE) \
          preface.mdwn \
          cha-methoden.mdwn \
          cha-herangehen.mdwn \
          cha-nachbearbeitung.mdwn \
          cha-lokal-total.mdwn \
          cha-lokal-teil.mdwn \
          cha-lokal-perform.mdwn \
          cha-lokal-werkzeuge.mdwn \
          cha-netz-total.mdwn \
          cha-netz-teil.mdwn \
          cha-netz-perform.mdwn \
          cha-netz-werkzeuge.mdwn \
          literatur.mdwn \
          part1.mdwn \
          part2.mdwn \
          part3.mdwn \
	  code/http-injector.pl \
	  code/read-syslog.pl \
	  code/strace-invocator.sh \
          images/eb-allgemein-drakon.png \
          images/eb-allgemein.png \
          images/eb-allgemein-yed.png \
          images/eb-netz-totalausfall-rechner.png \
          images/tcp-handshake-fail.png \
          images/tcp-handshake.png \
          images/tcp-shutdown.png \
#
CHAPTERS = \
    preface.mdwn \
    cha-methoden.mdwn \
    cha-herangehen.mdwn \
    cha-nachbearbeitung.mdwn \
    cha-lokal-total.mdwn \
    cha-lokal-teil.mdwn \
    cha-lokal-perform.mdwn \
    cha-lokal-werkzeuge.mdwn \
    cha-netz-total.mdwn \
    cha-netz-teil.mdwn \
    cha-netz-perform.mdwn \
    cha-netz-werkzeuge.mdwn \
    literatur.mdwn \
#
IMAGES = \
    images/eb-allgemein.png \
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

revision.mdwn: $(SOURCES) $(IMAGES) Makefile lua/revision.lua
	mtn --rcfile lua/revision.lua revision > .revision.mdwn
	mv .revision.mdwn revision.mdwn
all:

dropbox: $(DROPBOXFILES)

partial: dropbox
	sleep 10 && leanpub partial_preview

preview: dropbox
	sleep 10 && leanpub preview

status:
	leanpub job_status

# end of Makefile

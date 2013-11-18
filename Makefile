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
               $(DROPBOXDIR)/cha-methoden.mdwn \
               $(DROPBOXDIR)/cha-02.mdwn \
               $(DROPBOXDIR)/cha-03.mdwn \
               $(DROPBOXDIR)/cha-03-kontrolle.mdwn \
               $(DROPBOXDIR)/cha-03-vertiefung.mdwn \
               $(DROPBOXDIR)/cha-03-verallgemeinern.mdwn \
               $(DROPBOXDIR)/cha-03-verhindern.mdwn \
               $(DROPBOXDIR)/cha-03-schulung.mdwn \
               $(DROPBOXDIR)/cha-03-detail-gesamt.mdwn \
               $(DROPBOXDIR)/cha-04.mdwn \
               $(DROPBOXDIR)/cha-04-bootprobleme.mdwn \
               $(DROPBOXDIR)/cha-04-vm.mdwn \
               $(DROPBOXDIR)/cha-04-initramfs.mdwn \
               $(DROPBOXDIR)/cha-04-magic-sysrequest.mdwn \
               $(DROPBOXDIR)/cha-05.mdwn \
               $(DROPBOXDIR)/cha-05-erste-minute.mdwn \
               $(DROPBOXDIR)/cha-05-mount-probleme.mdwn \
               $(DROPBOXDIR)/cha-06.mdwn \
               $(DROPBOXDIR)/cha-07.mdwn \
               $(DROPBOXDIR)/cha-07-busybox.mdwn \
               $(DROPBOXDIR)/cha-07-vmstat.mdwn \
               $(DROPBOXDIR)/cha-08.mdwn \
               $(DROPBOXDIR)/cha-09.mdwn \
               $(DROPBOXDIR)/cha-10.mdwn \
               $(DROPBOXDIR)/cha-11.mdwn \
               $(DROPBOXDIR)/literatur.mdwn \
               $(DROPBOXDIR)/part1.mdwn \
               $(DROPBOXDIR)/part2.mdwn \
               $(DROPBOXDIR)/part3.mdwn \
               $(DROPBOXDIR)/kolophon.mdwn \
               $(DROPBOXDIR)/revision.mdwn \
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
          cha-02.mdwn \
          cha-03.mdwn \
          cha-03-kontrolle.mdwn \
          cha-03-vertiefung.mdwn \
          cha-03-verallgemeinern.mdwn \
          cha-03-verhindern.mdwn \
          cha-03-schulung.mdwn \
          cha-03-detail-gesamt.mdwn \
          cha-04.mdwn \
          cha-04-bootprobleme.mdwn \
          cha-04-vm.mdwn \
          cha-04-initramfs.mdwn \
          cha-04-magic-sysrequest.mdwn \
          cha-05.mdwn \
          cha-05-erste-minute.mdwn \
          cha-05-mount-probleme.mdwn \
          cha-06.mdwn \
          cha-lokal-perform.mdwn \
          cha-07.mdwn \
          cha-07-busybox.mdwn \
          cha-07-vmstat.mdwn \
          cha-lokal-werkzeuge.mdwn \
          cha-08.mdwn \
          cha-netz-total.mdwn \
          cha-09.mdwn \
          cha-netz-teil.mdwn \
          cha-10.mdwn \
          cha-netz-perform.mdwn \
          cha-11.mdwn \
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
    cha-02.mdwn \
    cha-03.mdwn \
    cha-03-kontrolle.mdwn \
    cha-03-vertiefung.mdwn \
    cha-03-verhindern.mdwn \
    cha-03-verallgemeinern.mdwn \
    cha-03-schulung.mdwn \
    cha-03-detail-gesamt.mdwn \
    cha-04.mdwn \
    cha-04-bootprobleme.mdwn \
    cha-04-vm.mdwn \
    cha-04-initramfs.mdwn \
    cha-04-magic-sysrequest.mdwn \
    cha-05.mdwn \
    cha-05-erste-minute.mdwn \
    cha-05-mount-probleme.mdwn \
    cha-06.mdwn \
    cha-07.mdwn \
    cha-07-busybox.mdwn \
    cha-07-vmstat.mdwn \
    cha-08.mdwn \
    cha-09.mdwn \
    cha-10.mdwn \
    cha-11.mdwn \
    literatur.mdwn \
    kolophon.mdwn \
#
IMAGES = \
    images/eb-allgemein.png \
#
.PHONY: proofreading revision.mdwn

$(DROPBOXDIR)/%.mdwn: %.mdwn
	cp $< $@

$(DROPBOXDIR)/%-empty.mdwn: %.mdwn
	grep '^#' $< | grep -v '^###' | sed -e 's/^/\n/' > $@

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
	cmp --quiet .revision.mdwn $@ || mv .revision.mdwn $@
all:

dropbox: $(DROPBOXFILES)

partial: dropbox
	sleep 10 && leanpub partial_preview

preview: dropbox revision.mdwn
	sleep 10 && leanpub preview

proofreading:
	bin/make_proofreading_file

status:
	leanpub job_status

clean:
	rm -f revision.mdwn
# end of Makefile

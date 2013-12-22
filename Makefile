# Makefile for leanpub / dropbox

BOOK = Book.txt
PREVIEW = Preview.txt
SAMPLE = Sample.txt

DROPBOXDIR = manuscript

DROPBOXFILES = $(DROPBOXDIR)/$(BOOK) \
               $(DROPBOXDIR)/$(PREVIEW) \
               $(DROPBOXDIR)/$(SAMPLE) \
               $(DROPBOXDIR)/preface.mdwn \
               $(DROPBOXDIR)/cha-01.mdwn \
               $(DROPBOXDIR)/cha-01-entscheidungsbaum.mdwn \
               $(DROPBOXDIR)/cha-01-bisektion.mdwn \
               $(DROPBOXDIR)/cha-01-korrelation.mdwn \
               $(DROPBOXDIR)/cha-01-abkuerzungen.mdwn \
               $(DROPBOXDIR)/cha-02.mdwn \
               $(DROPBOXDIR)/cha-02-problemaufnahme.mdwn \
               $(DROPBOXDIR)/cha-02-selber-denken.mdwn \
               $(DROPBOXDIR)/cha-02-logs.mdwn \
               $(DROPBOXDIR)/cha-02-fragen.mdwn \
               $(DROPBOXDIR)/cha-02-laborbuch.mdwn \
               $(DROPBOXDIR)/cha-02-feststecken.mdwn \
               $(DROPBOXDIR)/cha-03.mdwn \
               $(DROPBOXDIR)/cha-03-kontrolle.mdwn \
               $(DROPBOXDIR)/cha-03-vertiefung.mdwn \
               $(DROPBOXDIR)/cha-03-verallgemeinern.mdwn \
               $(DROPBOXDIR)/cha-03-verhindern.mdwn \
               $(DROPBOXDIR)/cha-03-schulung.mdwn \
               $(DROPBOXDIR)/cha-03-detail-gesamt.mdwn \
               $(DROPBOXDIR)/cha-04.mdwn \
               $(DROPBOXDIR)/cha-04-dateien.mdwn \
               $(DROPBOXDIR)/cha-04-prozessmodell.mdwn \
               $(DROPBOXDIR)/cha-04-schnittstellen.mdwn \
               $(DROPBOXDIR)/cha-05.mdwn \
               $(DROPBOXDIR)/cha-05-bootprobleme.mdwn \
               $(DROPBOXDIR)/cha-05-vm.mdwn \
               $(DROPBOXDIR)/cha-05-initramfs.mdwn \
               $(DROPBOXDIR)/cha-05-magic-sysrequest.mdwn \
               $(DROPBOXDIR)/cha-06.mdwn \
               $(DROPBOXDIR)/cha-06-erste-minute.mdwn \
               $(DROPBOXDIR)/cha-06-dienste.mdwn \
               $(DROPBOXDIR)/cha-06-init-programme.mdwn \
               $(DROPBOXDIR)/cha-06-zugriffsrechte.mdwn \
               $(DROPBOXDIR)/cha-06-mount-probleme.mdwn \
               $(DROPBOXDIR)/cha-07.mdwn \
               $(DROPBOXDIR)/cha-07-cpu.mdwn \
               $(DROPBOXDIR)/cha-07-ram.mdwn \
               $(DROPBOXDIR)/cha-07-io.mdwn \
               $(DROPBOXDIR)/cha-08.mdwn \
               $(DROPBOXDIR)/cha-08-busybox.mdwn \
               $(DROPBOXDIR)/cha-08-fuser.mdwn \
               $(DROPBOXDIR)/cha-08-ltrace.mdwn \
               $(DROPBOXDIR)/cha-08-perl.mdwn \
               $(DROPBOXDIR)/cha-08-shell.mdwn \
               $(DROPBOXDIR)/cha-08-strace.mdwn \
               $(DROPBOXDIR)/cha-08-vmstat.mdwn \
               $(DROPBOXDIR)/cha-09.mdwn \
               $(DROPBOXDIR)/cha-09-osi-modell.mdwn \
               $(DROPBOXDIR)/cha-09-zustaende-tcp.mdwn \
               $(DROPBOXDIR)/cha-10.mdwn \
               $(DROPBOXDIR)/cha-11.mdwn \
               $(DROPBOXDIR)/cha-12.mdwn \
               $(DROPBOXDIR)/cha-13.mdwn \
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
               $(DROPBOXDIR)/images/top-sorted-by-mem.png \
#

SOURCES = $(BOOK) \
          $(PREVIEW) \
          $(SAMPLE) \
          preface.mdwn \
          cha-01.mdwn \
          cha-01-entscheidungsbaum.mdwn \
          cha-01-bisektion.mdwn \
          cha-01-korrelation.mdwn \
          cha-01-abkuerzungen.mdwn \
          cha-02.mdwn \
          cha-02-problemaufnahme.mdwn \
          cha-02-selber-denken.mdwn \
          cha-02-logs.mdwn \
          cha-02-fragen.mdwn \
          cha-02-laborbuch.mdwn \
          cha-02-feststecken.mdwn \
          cha-03.mdwn \
          cha-03-kontrolle.mdwn \
          cha-03-vertiefung.mdwn \
          cha-03-verallgemeinern.mdwn \
          cha-03-verhindern.mdwn \
          cha-03-schulung.mdwn \
          cha-03-detail-gesamt.mdwn \
          cha-04.mdwn \
          cha-04-dateien.mdwn \
          cha-04-prozessmodell.mdwn \
          cha-04-schnittstellen.mdwn \
          cha-05.mdwn \
          cha-05-bootprobleme.mdwn \
          cha-05-vm.mdwn \
          cha-05-initramfs.mdwn \
          cha-05-magic-sysrequest.mdwn \
          cha-06.mdwn \
          cha-06-erste-minute.mdwn \
          cha-06-dienste.mdwn \
          cha-06-init-programme.mdwn \
          cha-06-zugriffsrechte.mdwn \
          cha-06-mount-probleme.mdwn \
          cha-07.mdwn \
          cha-07-cpu.mdwn \
          cha-07-ram.mdwn \
          cha-07-io.mdwn \
          cha-08.mdwn \
          cha-08-busybox.mdwn \
          cha-08-fuser.mdwn \
          cha-08-ltrace.mdwn \
          cha-08-perl.mdwn \
          cha-08-shell.mdwn \
          cha-08-strace.mdwn \
          cha-08-vmstat.mdwn \
          cha-lokal-werkzeuge.mdwn \
          cha-09.mdwn \
          cha-09-osi-modell.mdwn \
          cha-09-zustaende-tcp.mdwn \
          cha-10.mdwn \
          cha-netz-total.mdwn \
          cha-11.mdwn \
          cha-netz-teil.mdwn \
          cha-12.mdwn \
          cha-netz-perform.mdwn \
          cha-13.mdwn \
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
    cha-01.mdwn \
    cha-01-entscheidungsbaum.mdwn \
    cha-01-bisektion.mdwn \
    cha-01-korrelation.mdwn \
    cha-01-abkuerzungen.mdwn \
    cha-02.mdwn \
    cha-02-problemaufnahme.mdwn \
    cha-02-selber-denken.mdwn \
    cha-02-logs.mdwn \
    cha-02-fragen.mdwn \
    cha-02-laborbuch.mdwn \
    cha-02-feststecken.mdwn \
    cha-03.mdwn \
    cha-03-kontrolle.mdwn \
    cha-03-vertiefung.mdwn \
    cha-03-verhindern.mdwn \
    cha-03-verallgemeinern.mdwn \
    cha-03-schulung.mdwn \
    cha-03-detail-gesamt.mdwn \
    cha-04.mdwn \
    cha-04-dateien.mdwn \
    cha-04-prozessmodell.mdwn \
    cha-04-schnittstellen.mdwn \
    cha-05.mdwn \
    cha-05-bootprobleme.mdwn \
    cha-05-vm.mdwn \
    cha-05-initramfs.mdwn \
    cha-05-magic-sysrequest.mdwn \
    cha-06.mdwn \
    cha-06-erste-minute.mdwn \
    cha-06-dienste.mdwn \
    cha-06-init-programme.mdwn \
    cha-06-zugriffsrechte.mdwn \
    cha-06-mount-probleme.mdwn \
    cha-07.mdwn \
    cha-07-cpu.mdwn \
    cha-07-ram.mdwn \
    cha-07-io.mdwn \
    cha-08.mdwn \
    cha-08-busybox.mdwn \
    cha-08-fuser.mdwn \
    cha-08-ltrace.mdwn \
    cha-08-perl.mdwn \
    cha-08-shell.mdwn \
    cha-08-strace.mdwn \
    cha-08-vmstat.mdwn \
    cha-09.mdwn \
    cha-09-osi-modell.mdwn \
    cha-09-zustaende-tcp.mdwn \
    cha-10.mdwn \
    cha-11.mdwn \
    cha-12.mdwn \
    cha-13.mdwn \
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

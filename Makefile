# Makefile for leanpub / dropbox

BOOK = Book.txt
PREVIEW = Subset.txt
SAMPLE = Sample.txt

DROPBOXDIR = manuscript

DROPBOXFILES = $(DROPBOXDIR)/$(BOOK) \
               $(DROPBOXDIR)/$(PREVIEW) \
               $(DROPBOXDIR)/$(SAMPLE) \
               $(DROPBOXDIR)/preface.md \
               $(DROPBOXDIR)/ch01.md \
               $(DROPBOXDIR)/ch01-entscheidungsbaum.md \
               $(DROPBOXDIR)/ch01-bisektion.md \
               $(DROPBOXDIR)/ch01-korrelation.md \
               $(DROPBOXDIR)/ch01-abkuerzungen.md \
               $(DROPBOXDIR)/ch02.md \
               $(DROPBOXDIR)/ch02-problemaufnahme.md \
               $(DROPBOXDIR)/ch02-selber-denken.md \
               $(DROPBOXDIR)/ch02-logs.md \
               $(DROPBOXDIR)/ch02-fragen.md \
               $(DROPBOXDIR)/ch02-laborbuch.md \
               $(DROPBOXDIR)/ch02-hilfsaufgabe.md \
               $(DROPBOXDIR)/ch02-feststecken.md \
               $(DROPBOXDIR)/ch03.md \
               $(DROPBOXDIR)/ch03-kontrolle.md \
               $(DROPBOXDIR)/ch03-vertiefung.md \
               $(DROPBOXDIR)/cha-03-verallgemeinern.md \
               $(DROPBOXDIR)/cha-03-verhindern.md \
               $(DROPBOXDIR)/cha-03-schulung.md \
               $(DROPBOXDIR)/cha-03-detail-gesamt.md \
               $(DROPBOXDIR)/cha-04.md \
               $(DROPBOXDIR)/cha-04-dateien.md \
               $(DROPBOXDIR)/cha-04-prozessmodell.md \
               $(DROPBOXDIR)/cha-04-schnittstellen.md \
               $(DROPBOXDIR)/cha-05.md \
               $(DROPBOXDIR)/cha-05-bootprobleme.md \
               $(DROPBOXDIR)/cha-05-vm.md \
               $(DROPBOXDIR)/cha-05-initramfs.md \
               $(DROPBOXDIR)/cha-05-magic-sysrequest.md \
               $(DROPBOXDIR)/cha-05-kernel-panic.md \
               $(DROPBOXDIR)/ch06.md \
               $(DROPBOXDIR)/cha-06-erste-minute.md \
               $(DROPBOXDIR)/cha-06-dienste.md \
               $(DROPBOXDIR)/cha-06-init-programme.md \
               $(DROPBOXDIR)/ch06-zugriffsrechte.md \
               $(DROPBOXDIR)/cha-06-mount-probleme.md \
               $(DROPBOXDIR)/cha-07.md \
               $(DROPBOXDIR)/cha-07-cpu.md \
               $(DROPBOXDIR)/cha-07-ram.md \
               $(DROPBOXDIR)/cha-07-io.md \
               $(DROPBOXDIR)/cha-08.md \
               $(DROPBOXDIR)/cha-08-acct.md \
               $(DROPBOXDIR)/cha-08-bonnie.md \
               $(DROPBOXDIR)/cha-08-busybox.md \
               $(DROPBOXDIR)/cha-08-c.md \
               $(DROPBOXDIR)/cha-08-dd.md \
               $(DROPBOXDIR)/cha-08-fio.md \
               $(DROPBOXDIR)/cha-08-fuser.md \
               $(DROPBOXDIR)/cha-08-gdb.md \
               $(DROPBOXDIR)/cha-08-hdparm.md \
               $(DROPBOXDIR)/cha-08-lsof.md \
               $(DROPBOXDIR)/cha-08-ltrace.md \
               $(DROPBOXDIR)/cha-08-netstat.md \
               $(DROPBOXDIR)/cha-08-perf.md \
               $(DROPBOXDIR)/cha-08-perl.md \
               $(DROPBOXDIR)/cha-08-shell.md \
               $(DROPBOXDIR)/cha-08-sysstat.md \
               $(DROPBOXDIR)/cha-08-strace.md \
               $(DROPBOXDIR)/cha-08-vmstat.md \
               $(DROPBOXDIR)/cha-09.md \
               $(DROPBOXDIR)/cha-09-osi-modell.md \
               $(DROPBOXDIR)/cha-09-arp.md \
               $(DROPBOXDIR)/cha-09-ipv4-netzmasken.md \
               $(DROPBOXDIR)/cha-09-zustaende-tcp.md \
               $(DROPBOXDIR)/cha-09-routing-algorithm.md \
               $(DROPBOXDIR)/cha-10.md \
               $(DROPBOXDIR)/cha-10-netzausfall-rechner.md \
               $(DROPBOXDIR)/cha-10-netzausfall-segment.md \
               $(DROPBOXDIR)/cha-10-routing.md \
               $(DROPBOXDIR)/cha-11.md \
               $(DROPBOXDIR)/cha-11-ausfall-essentiell.md \
               $(DROPBOXDIR)/cha-11-ausfall-dienst.md \
               $(DROPBOXDIR)/cha-12.md \
               $(DROPBOXDIR)/cha-12-ursachen.md \
               $(DROPBOXDIR)/cha-12-messen.md \
               $(DROPBOXDIR)/cha-12-massnahmen.md \
               $(DROPBOXDIR)/cha-13.md \
               $(DROPBOXDIR)/cha-13-arp.md \
               $(DROPBOXDIR)/cha-13-bridge-utils.md \
               $(DROPBOXDIR)/cha-13-ethtool.md \
               $(DROPBOXDIR)/cha-13-ifconfig.md \
               $(DROPBOXDIR)/cha-13-iperf.md \
               $(DROPBOXDIR)/cha-13-iproute.md \
               $(DROPBOXDIR)/cha-13-libtrace.md \
               $(DROPBOXDIR)/cha-13-netcat.md \
               $(DROPBOXDIR)/cha-13-netstat.md \
               $(DROPBOXDIR)/cha-13-openssl.md \
               $(DROPBOXDIR)/cha-13-perl.md \
               $(DROPBOXDIR)/cha-13-ping.md \
               $(DROPBOXDIR)/cha-13-quagga.md \
               $(DROPBOXDIR)/cha-13-route.md \
               $(DROPBOXDIR)/cha-13-samba.md \
               $(DROPBOXDIR)/cha-13-tcpdump.md \
               $(DROPBOXDIR)/cha-13-telnet.md \
               $(DROPBOXDIR)/cha-13-traceroute.md \
               $(DROPBOXDIR)/cha-13-wireshark.md \
               $(DROPBOXDIR)/glossar.md \
               $(DROPBOXDIR)/literatur.md \
               $(DROPBOXDIR)/part1.md \
               $(DROPBOXDIR)/part2.md \
               $(DROPBOXDIR)/part3.md \
               $(DROPBOXDIR)/anhang.md \
               $(DROPBOXDIR)/kolophon.md \
               $(DROPBOXDIR)/revision.md \
	       $(DROPBOXDIR)/code/fnotify.c \
	       $(DROPBOXDIR)/code/http-injector.pl \
	       $(DROPBOXDIR)/code/read-syslog.pl \
	       $(DROPBOXDIR)/code/strace-invocator.sh \
               $(DROPBOXDIR)/images/eb-allgemein-drakon.png \
               $(DROPBOXDIR)/images/eb-allgemein.png \
               $(DROPBOXDIR)/images/eb-allgemein-3-yed.png \
               $(DROPBOXDIR)/images/eb-netz-totalausfall-rechner.png \
               $(DROPBOXDIR)/images/router-graph.png \
               $(DROPBOXDIR)/images/ss13-libtrace-1.png \
               $(DROPBOXDIR)/images/ss13-netcat-1.png \
               $(DROPBOXDIR)/images/ss13-openssl-1.png \
               $(DROPBOXDIR)/images/tcp-handshake-fail.png \
               $(DROPBOXDIR)/images/tcp-handshake.png \
               $(DROPBOXDIR)/images/tcp-shutdown.png \
               $(DROPBOXDIR)/images/title_page.png \
               $(DROPBOXDIR)/images/top-sorted-by-mem.png \
#

SOURCES = $(BOOK) \
          $(PREVIEW) \
          $(SAMPLE) \
          preface.md \
          ch01.md \
          ch01-entscheidungsbaum.md \
          ch01-bisektion.md \
          ch01-korrelation.md \
          ch01-abkuerzungen.md \
          ch02.md \
          ch02-problemaufnahme.md \
          ch02-selber-denken.md \
          ch02-logs.md \
          ch02-fragen.md \
          ch02-laborbuch.md \
          ch02-hilfsaufgabe.md \
          ch02-feststecken.md \
          ch03.md \
          ch03-kontrolle.md \
          ch03-vertiefung.md \
          cha-03-verallgemeinern.md \
          cha-03-verhindern.md \
          cha-03-schulung.md \
          cha-03-detail-gesamt.md \
          cha-04.md \
          cha-04-dateien.md \
          cha-04-prozessmodell.md \
          cha-04-schnittstellen.md \
          cha-05.md \
          cha-05-bootprobleme.md \
          cha-05-vm.md \
          cha-05-initramfs.md \
          cha-05-magic-sysrequest.md \
          cha-05-kernel-panic.md \
          ch06.md \
          cha-06-erste-minute.md \
          cha-06-dienste.md \
          cha-06-init-programme.md \
          ch06-zugriffsrechte.md \
          cha-06-mount-probleme.md \
          cha-07.md \
          cha-07-cpu.md \
          cha-07-ram.md \
          cha-07-io.md \
          cha-08.md \
          cha-08-acct.md \
          cha-08-bonnie.md \
          cha-08-busybox.md \
          cha-08-c.md \
          cha-08-dd.md \
          cha-08-fio.md \
          cha-08-fuser.md \
          cha-08-gdb.md \
          cha-08-hdparm.md \
          cha-08-lsof.md \
          cha-08-ltrace.md \
          cha-08-netstat.md \
          cha-08-perf.md \
          cha-08-perl.md \
          cha-08-shell.md \
          cha-08-sysstat.md \
          cha-08-strace.md \
          cha-08-vmstat.md \
          cha-09.md \
          cha-09-osi-modell.md \
          cha-09-arp.md \
          cha-09-ipv4-netzmasken.md \
          cha-09-zustaende-tcp.md \
          cha-09-routing-algorithm.md \
          cha-10.md \
          cha-10-netzausfall-rechner.md \
          cha-10-netzausfall-segment.md \
          cha-10-routing.md \
          cha-11.md \
          cha-11-ausfall-essentiell.md \
          cha-11-ausfall-dienst.md \
          cha-12.md \
          cha-12-ursachen.md \
          cha-12-messen.md \
          cha-12-massnahmen.md \
          cha-13.md \
          cha-13-arp.md \
          cha-13-bridge-utils.md \
          cha-13-ethtool.md \
          cha-13-ifconfig.md \
          cha-13-iperf.md \
          cha-13-iproute.md \
          cha-13-libtrace.md \
          cha-13-netcat.md \
          cha-13-netstat.md \
          cha-13-openssl.md \
          cha-13-perl.md \
          cha-13-ping.md \
          cha-13-quagga.md \
          cha-13-route.md \
          cha-13-samba.md \
          cha-13-tcpdump.md \
          cha-13-telnet.md \
          cha-13-traceroute.md \
          cha-13-wireshark.md \
          glossar.md \
          literatur.md \
          part1.md \
          part2.md \
          part3.md \
          anhang.md \
	  code/fnotify.c \
	  code/http-injector.pl \
	  code/read-syslog.pl \
	  code/strace-invocator.sh \
          images/eb-allgemein-drakon.png \
          images/eb-allgemein.png \
          images/eb-allgemein-3-yed.png \
          images/eb-netz-totalausfall-rechner.png \
          images/router-graph.png \
          images/ss13-libtrace-1.png \
          images/ss13-netcat-1.png \
          images/ss13-openssl-1.png \
          images/tcp-handshake-fail.png \
          images/tcp-handshake.png \
          images/tcp-shutdown.png \
#
CHAPTERS = \
    preface.md \
    ch01.md \
    ch01-entscheidungsbaum.md \
    ch01-bisektion.md \
    ch01-korrelation.md \
    ch01-abkuerzungen.md \
    ch02.md \
    ch02-problemaufnahme.md \
    ch02-selber-denken.md \
    ch02-logs.md \
    ch02-fragen.md \
    ch02-laborbuch.md \
    ch02-hilfsaufgabe.md \
    ch02-feststecken.md \
    ch03.md \
    ch03-kontrolle.md \
    ch03-vertiefung.md \
    cha-03-verhindern.md \
    cha-03-verallgemeinern.md \
    cha-03-schulung.md \
    cha-03-detail-gesamt.md \
    cha-04.md \
    cha-04-dateien.md \
    cha-04-prozessmodell.md \
    cha-04-schnittstellen.md \
    cha-05.md \
    cha-05-bootprobleme.md \
    cha-05-vm.md \
    cha-05-initramfs.md \
    cha-05-magic-sysrequest.md \
    cha-05-kernel-panic.md \
    ch06.md \
    cha-06-erste-minute.md \
    cha-06-dienste.md \
    cha-06-init-programme.md \
    ch06-zugriffsrechte.md \
    cha-06-mount-probleme.md \
    cha-07.md \
    cha-07-cpu.md \
    cha-07-ram.md \
    cha-07-io.md \
    cha-08.md \
    cha-08-acct.md \
    cha-08-bonnie.md \
    cha-08-busybox.md \
    cha-08-c.md \
    cha-08-dd.md \
    cha-08-fio.md \
    cha-08-fuser.md \
    cha-08-gdb.md \
    cha-08-hdparm.md \
    cha-08-lsof.md \
    cha-08-ltrace.md \
    cha-08-netstat.md \
    cha-08-perf.md \
    cha-08-perl.md \
    cha-08-shell.md \
    cha-08-sysstat.md \
    cha-08-strace.md \
    cha-08-vmstat.md \
    cha-09.md \
    cha-09-osi-modell.md \
    cha-09-arp.md \
    cha-09-ipv4-netzmasken.md \
    cha-09-zustaende-tcp.md \
    cha-09-routing-algorithm.md \
    cha-10.md \
    cha-10-netzausfall-rechner.md \
    cha-10-netzausfall-segment.md \
    cha-10-routing.md \
    cha-11.md \
    cha-11-ausfall-essentiell.md \
    cha-11-ausfall-dienst.md \
    cha-12.md \
    cha-12-ursachen.md \
    cha-12-messen.md \
    cha-12-massnahmen.md \
    cha-13.md \
    cha-13-arp.md \
    cha-13-bridge-utils.md \
    cha-13-ethtool.md \
    cha-13-ifconfig.md \
    cha-13-iperf.md \
    cha-13-iproute.md \
    cha-13-libtrace.md \
    cha-13-netcat.md \
    cha-13-netstat.md \
    cha-13-openssl.md \
    cha-13-perl.md \
    cha-13-ping.md \
    cha-13-quagga.md \
    cha-13-route.md \
    cha-13-samba.md \
    cha-13-tcpdump.md \
    cha-13-telnet.md \
    cha-13-traceroute.md \
    cha-13-wireshark.md \
    glossar.md \
    literatur.md \
    kolophon.md \
#
IMAGES = \
    images/eb-allgemein.png \
#
.PHONY: proofreading revision.md

$(DROPBOXDIR)/%.md: %.md
	cp $< $@

$(DROPBOXDIR)/%-empty.md: %.md
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

revision.md: $(SOURCES) $(IMAGES) Makefile lua/revision.lua
	mtn --rcfile lua/revision.lua revision > .revision.md
	cmp --quiet .revision.md $@ || mv .revision.md $@
all:

dropbox: $(DROPBOXFILES)

partial: dropbox revision.md
	sleep 15 && leanpub partial_preview

preview: dropbox revision.md
	sleep 15 && leanpub preview

proofreading:
	bin/make_proofreading_file

status:
	leanpub job_status

clean:
	rm -f revision.md
# end of Makefile

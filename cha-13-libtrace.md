
## libtrace und libtrace-tools {#sec-netz-werkzeuge-librace}

Neben Tcpdump und Wireshark gibt es noch ein drittes Werkzeug, das ich gern
einsetze, wenn ich auf Paketmitschnitte zurückgreifen muss: libtrace und die
dazugehörigen Tools.

Mit libtrace kann man ähnlich wie mit libpcap eigene Analysewerkzeuge
programmieren. Aber hier will ich mehr auf die mitgelieferten libtrace-tools
eingehen, mit denen Mitschnitte angefertigt und weiter bearbeitet werden
können.

Ein großer Vorteil von libtrace ist, dass diese Bibliothek und die damit
geschriebenen Werkzeuge mit Paketmitschnitten aus unterschiedlichen Quellen
umgehen können und die verschiedenen Formate ineinander umwandlen können.
Dazu verwendet libtrace sogenannte URI um das Format und die Quelle
beziehungsweise das Ziel anzugeben.

{title="Unterstützte Formate für Paketmitschnitte"}
| Format                      | URI                    | Lesen | Schreiben |
|-----------------------------|------------------------|-------|-----------|
| Live PCAP Schnittstelle     | pcapint\:<interface>   | Ja    | Ja        |
|-----------------------------|------------------------|-------|-----------|
| PCAP Trace Datei            | pcapfile:\<filename>   | Ja    | Ja        |
|-----------------------------|------------------------|-------|-----------|
| ERF Trace Datei             | erf:\<filename>        | Ja    | Ja        |
|-----------------------------|------------------------|-------|-----------|
| DAG Gerät                   | dag:\<device location> | Ja    | Ja        |
|-----------------------------|------------------------|-------|-----------|
| Native Linux interface      | int:\<interface>       | Ja    | Ja        |
|-----------------------------|------------------------|-------|-----------|
| Native Linux interface      | ring:\<interface>      | Ja    | Ja        |
| (ring buffers)              |                        |       |           |
|-----------------------------|------------------------|-------|-----------|
| Native BSD interface        | bpf:\<interface>       | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| TSH trace file              | tsh:\<filename>        | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| FR+ trace file              | fr+:\<filename>        | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| Legacy DAG ATM Trace Datei  | legacyatm:\<filename>  | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| Legacy DAG POS Trace Date   | legacypos:\<filename>  | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| Legacy DAG Ethernet Trace   | legacyeth:\<filename>  | Ja    | Nein      |
| Datei                       |                        |       |           |
|-----------------------------|------------------------|-------|-----------|
| Legacy DAG NZIX Trace Datei | legacynzix:\<filename> | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| ATM Cell Header Trace Datei | atmhdr:\<filename>     | Ja    | Nein      |
|-----------------------------|------------------------|-------|-----------|
| RT Network Protocol         | rt:\<host>:\<port>     | Ja    | Nein      |


Damit genug der Vorrede, kommen wir nun zu den Werkzeugen.

### traceanon

Mit traceanon kann man die IP-Adressen von Paketmitschnitten anonymisieren.
Das ist immer dann wichtig, wenn ein Paketmitschnitt zu einem Problem
weitergereicht werden, aber möglichst wenig Informationen zur
Netzwerkstruktur preisgegeben werden soll.

Traceanon ändert die IP-Header der Datenpakete sowie die in ICMP
eingebetteten IP-Header und repariert die Prüfsummen innerhalb von TCP- und
UDP-Headern.

Es gibt zwei Schemata, zum Einen wird ein kompletter Adressblock durch einen
anderen ersetzt und zum Anderen werden die Adressen mit dem
Cryptopan-Verfahren ersetzt.

Wichtig beim Einsatz von traceanon ist, immer im Hinterkopf zu behalten,
dass IP-Adressen auch auf anderem Weg offenbar werden können. So werden zum
Beispiel IP-Adressen innerhalp von ARP-Paketen nicht anonymisiert und einige
Anwendungsprotokolle wie zum Beispiel HTTP, SMTP, OSPF und andere
Routingprotokolle können in den Anwendungsdaten Informationen über die
beteiligten Netze preisgeben.

Der Aufruf sieht so aus:

    $ traceanon [options] sourceuri desturi

Die möglichen Optionen sind der Handbuchseite zu entnehmen.

### tracediff

Dieses Werkzeug findet Differenzen zwischen zwei Mitschnitten und gibt diese
aus. Dabei wird der Inhalt aus den Framingheadern (PCAP oder ERF) nicht
ausgewertet.

Mit der Option `-m max` kann ich die Ausgabe nach `max`
Unterschieden abbrechen lassen.

Der Aufruf sieht so aus:

    $ tracediff [ -m maxdiff ] firsturi seconduri


Tracediff ist zum Beispiel nützlich, wenn ich mehrere Mitschnitte einer
Verbindungssitzung an verschiedenen Stellen aufgenommen habe und diese
vergleichen will.

### tracemerge

Mit diesem Werkzeug kann ich zwei oder mehrere Paketmitschnitte zu einer
kombinieren, wobei die Reihenfolge der Pakete beibehalten wird.

Der Aufruf sieht so aus:

    $ tracemerge [ options ] outputuri inputuri ...

Die möglichen Optionen sind der Handbuchseite zu entnehmen.

### tracepktdump

Mit diesem Programm kann ich Datenpakete in lesbarer Form ausgeben.
Dabei kann ich mit der Option `-f filter` die Ausgabe auf bestimmte
Pakete einschränken und mit `-c count` die Anzahl der angezeigten
Pakete begrenzen.

Die Ausgabe ist abhängig davon, inwieweit die mitgeschnittenen Protokolle in
libtrace bekannt sind und ändert sich folglich von Version zu Version.

Folgender Beispielaufruf mit tracepktdump aus den libtrace-tools Version
3.0.10 soll das verdeutlichen:

    $ tracepktdump pcap/ospf-1.pcap
    Wed Sep 26 13:54:58 2012
     Capture: Packet Length: 138/142 Direction Value: -1
     Ethernet: Dest: 01:00:5e:00:00:05 Source: 12:6a:17:1a:52:6e Ethertype: 0x0800
     IP: Header Len 20 Ver 4 DSCP 30 ECN 0 Total Length 124
     IP: Id 10064 Fragoff 0
     IP: TTL 1 Proto 89 (ospf) Checksum 11126
     IP: Source 132.147.1.11 Destination 224.0.0.5
    unknown protocol ip/89
     Unknown Protocol: 89
      02 01 00 68 84 93 01 0b 00 00 00 00 e2 48 00 00    ...h.........H..
      00 00 00 00 00 00 00 00 ff ff 00 00 00 0a 02 01    ................
      00 00 00 28 84 93 01 0d 84 93 01 12 84 93 01 03    ...(............
      c0 a8 fe 09 c0 a8 fe 05 c0 a8 ef 0a c0 a8 ef 0b    ................
      c0 a8 ef 14 c0 a8 ef 15 0a 09 01 01 84 93 04 01    ................
      84 93 04 0f 84 93 04 11 84 93 04 13 84 93 05 02    ................
      84 93 05 03 84 93 01 0e                            ........                        

In dieser Version ist das OSPF-Protokoll in der Bibliothek noch nicht
bekannt und wird daher als Hexdump präsentiert.
Die IP- und Ethernetheader hingegen werden dekodiert und erscheinen nicht
im Hexdump.

### tracereplay

Dieses Werkzeug spielt einen Paketmitschnitt mit den gleichen Zeitabständen
aus einer URI zu einer anderen. Insbesondere wenn die zweite URI ein
Netzwerkinterface bestimmt, kann ich damit einen Mitschnitt wieder auf das
Netz schicken.
Prüfsummen werden dabei während des Abspielens neu berechnet.

Mit der Option `-f filter` kann ich die zurückgespielten Datenpakete
einschränken und `-b` kann ich als Zielethernetadresse die
Broadcast-Adresse verwenden.

Beim Zurückspielen werden ansonsten die Ethernetadresssen aus dem Mitschnitt
verwendet, so dass ich das vorwiegend im selben Netzsegment einspielen will.

Abhängig vom Switch und dem Verkehr im Netz können die Reaktionen anderer
Rechner auf die wiedereingespielten Datenpakete auch an andere Rechner
gehen, wenn deren Ethernetadresse als Absender im Mitschnitt steht.

Der Aufruf sieht so aus:

    $ tracereplay [ options ] inputuri outputuri

Die möglichen Optionen sind der Handbuchseite zu entnehmen.

### tracereport

Dieses Programm kann eine Reihe von Berichten über die Eigenschaften von
Paketmitschnitten produzieren. Die Berichte landen in Dateien deren Name
gleich der Langoption gefolgt vom Suffix `.rpt` ist.

Unter anderem folgende Optionen und Reports stehen zur Verfügung:

-e | --error
: erzeugt einen Bericht über Paketfehler (zum Beispiel
  Prüfsummenfehler, Empfangsfehler).

-F | --flow
: erzeugt einen Bericht über die Anzahl von Datenflüssen.

-m | --misc
: liefert einen allgemeinen Bericht (Zeitpunkt des ersten
  und letzten Paketes, Gesamtzahl der Pakete, ...)

-P | --protocol
: erzeugt einen Bericht über die im Mitschnitt
  vorkommenden Protokolle der Transportschicht

-p | --ports
: liefert einen Bericht über die vorkommenden Ports

-t | --ttl
: berichtet über die TTL der Datenpakete im Mitschnitt

-n | --nlp
: berichtet über die im Mitschnitt vorkommenden Protokolle
  der Netzwerkschicht

-d | --direction
: berichtet, wieviel Traffic in jede Richtung geht

Mehr Optionen und Berichte beschreibt die Handbuchseite.

### tracertstats

Mit diesem Programm bekomme ich eine einfache filter- und zeitbasierte
Analyse eines Paketmitschnitts.
Dabei wird der Mitschnitt in Intervalle aufgeteilt und für jedes Intervall
angegeben, wie viele Datenpakete passen zu den angegebenen Filtern im
Intervall vorkommen.

Die möglichen Optionen sind unter anderen:

-f filter
: legt die Filter für die Analyse fest, kann auch mehrfach angegeben werden

-i interval
: bestimmt das zugrunde liegende Zeitraster in Sekunden

-m
: wenn mehrere Paketmitschnitte angegeben werden, sollen diese
  zusammengefasst werden (merge)

-o format
: legt das Ausgabeformat fest (`txt`, `csv`, `html`)

Weitere Optionen stehen in der Handbuchseite.
  
### tracestats

Dieses Programm gibt ähnliche Analysen wie tracertstats aus, aber jeweils
für den gesamten Paketmitschnitt und nicht für einzelne Zeitintervalle
daraus. Mit der Option `-f filter` kann ich auch hier die Pakete
angeben, an denen ich interessiert bin.

Das Programm tracesummary ist ein Shellwrapper um tracestats und gibt eine
einfache Zusammenfassung für einen Paketmitschnitt an.

### tracesplit

Dieses Programm teilt einen Paketmitschnitt in mehrere Dateien auf.

Das kann ich unter anderen mit diesen Optionen beeinflussen:

-f filter
: gibt nur die Pakete aus, die zu dem angegebenen Filter passen

-c count
: schreibt maximal `count` Pakete pro Ausgabedatei. Die
  Ausgabedateien werden benannt nach dem in outputuri angegeben Basisnamen
  mit der angehängten Nummer des ersten Paketes in der Datei.

-b bytes
: schreibt maximal `bytes` Bytes in eine Datei

-i seconds
: startet eine neue Datei aller `seconds` Sekunden

-s unixtime
: beginnt die Ausgabe bei `unixtime`

-e unixtime
: endet die Ausgabe bei `unixtime`

-m max
: erzeugt nicht mehr als `max` Ausgabedateien

-S snaplen
: schneidet die Datenpakete bei `snaplen` ab. Ohne
  diese Angabe wird das komplette Datenpaket geschrieben.

-z level
: setzt den Kompressionsgrad (0..9)

-Z method
: wählt die Kompressionsmethode (`gzip`, `bzip2`, `lzo` oder `none`)

Weitere Optionen stehen in der Handbuchseite.

Zwei weitere Werkzeuge sind lediglich Shellwrapper um das Programm
tracesplit:

traceconvert
: transformiert einen Mitschnitt aus einem Format in ein anderes

tracefilter
: extrahiert Datenpakete anhand von BPF-Filtern aus einem Mitschnitt

### tracesplit_dir

Dieses Programm teilt einen Mitschnitt in zwei Richtungen auf. Die
Richtungen müssen aus der Inputuri erkennbar sein.

Der Aufruf sieht so aus:

    $ tracesplit_dir inputuri outputuri_incoming outputuri_outgoing

### tracetop

Das Programm zeigt die obersten n Datenflüsse in jeder Sekunde an, ähnlich
wie top für Prozesse oder mytop für MySQL-Verbindungen.

Mit den folgenden Optionen kann ich die Ausgabe beeinflussen:

-f filter
: zählt nur die Pakete, die zu dem Filter passen

-i interval
: gibt das Intervall in Sekunden zwischen den
  Bildschirmaktualisierungen vor (Voreinstellung 2 Sekunden)

--percent
: zeigt die Bytes und Pakete der Datenflüsse als Anteil vom Gesamtdatenverkehr

--bits-per-second
: zeigt die Bandbreite als Bits pro Sekunde an



## iproute {#sec-netz-werkzeuge-iproute}

Die Programme der iproute-Suite sind moderne Werkzeuge zur Anzeige und
Konfiguration von Netzwerkschnittstellen, -routen und der Verkehrskontrolle.
Sie bieten gegenüber den Programmen der net-tools-Suite erweiterte
Möglichkeiten.
Mit dem Kernel kommunizieren sie über die (rt)netlink-Schnittstelle.

Die iproute-Suite umfasst unter anderem die folgenden Programme:

ip
: zum Anzeigen und Konfigurieren von Netzwerkschnittstellen,
  -adressen, -routen, Policy-Regeln, ARP- und NDISC-Einträgen, IP-Tunneln
  und Multicast

ss
: zur Anzeige von Socketstatistiken

tc
: zur Konfiguration der Netzwerkverkehrskontrolle

arpd
: ein Userspace-ARP-Daemon

\*stat, rtacct
: verschiedene Statistikwerkzeuge

Weitere und genauere Informationen stehen in den betreffenden Handbuchseiten
und der zugehörigen Dokumentation.

### ip

Das Program ip dient zum Anzeigen und Manipulieren von Routen, Schnittstellen,
Policy-Routing und Tunneln. Es ist das Programm aus der Suite, das ich am
häufigsten interaktiv aufrufe.

Allgemein sieht der Aufruf des Programms wie folgt aus:

{line-numbers=off,lang="text"}
    ip [ Optionen ] Objekt [ Befehl [ Argumente ] ]

Die Optionen sind allgemeine Modifikatoren, die das Verhalten des Programms
ändern, wie zum Beispiel `-4` oder `-6`, die die Adressfamilie auf
IPv4 oder IPv6 einschränken.

Das Objekt gibt an, worüber ich Informationen wünsche, beziehungsweise, was
ich manipulieren will. Mögliche Objekte sind unter anderem:

link
: Netzwerkschnittstellen

address
: Protokoll-Adressen an einer Schnittstelle

neighbour
: ARP- oder NDISC-Einträge

route
: Einträge in der Kernel-Routingtabelle

rule
: Regeln in der Policydatenbank

maddress
: Multicast-Adressen

mroute
: Multicast-Routingeinträge

tunnel
: IP-Tunnel

monitor
: Nachrichten auf der netlink-Schnittstelle des Kernels

Der darauf folgende Befehl gibt die Aktion an, die wir ausführen wollen und
wird gegebenenfalls von passenden Argumenten gefolgt.
Befehl und Argumente sind spezifisch für die entsprechenden Objekte.

### ss

Das Programm ss (socket statistics) liefert Informationen und Statistiken zu
Sockets. Ähnliche Informationen kann ich zum Beispiel auch mit netstat
bekommen, jedoch habe ich bei ss mehr Möglichkeiten zur Filterung, was mir
bei Servern mit vielen Verbindungen zugute kommt.

Der Aufruf ist wie folgt:

{line-numbers=off,lang="text"}
    ss [ Optionen ] [ Filter ]

Dabei zeigt ss ohne Optionen die verbundenen TCP-Sockets an.

Die wichtigsten Optionen sind unter anderen:

-a
: um alle Sockets anzuzeigen

-l
: um nur die Listening Sockets anzuzeigen (diese werden sonst ausgelassen)

-p
: um die zugehörigen Prozesse anzuzeigen (dafür benötige ich Rootrechte)

-t | -u | -w | -x
: um TCP-, UDP-, Raw- oder Unix-Sockets auszuwählen

Der Filter beim Aufruf von ss hat die allgemeine Form:

{line-numbers=off,lang="text"}
    [ TCP-Status ] [ Ausdruck ]


Um nach TCP-Status zu filtern, gebe ich das Schlüsselwort `state` oder
`exclude` gefolgt von einem der Standard-TCP-Zustandsnamen oder einem
der folgenden an:

all
: für alle Zustände

bucket
: für TCP-Minisockets (TIME-WAIT|SYN-RECV)

big
: für alle außer den Minisockets

connected
: für verbundenen Sockets

synchronized
: für alle verbundenen Sockets, die nicht im Zustand SYN-SENT sind

Falls weder ein `state` noch ein `exclude` Statement vorhanden
ist, ist die Voreinstellung `all` bei Option `-a` und ansonsten
alle außer `listening`, `syn-recv`, `time-wait` und `closed`.

Mit dem booleschen Ausdruck kann ich nach Adressen und Ports filtern.

Weitere Optionen und ausführlichere Informationen zur Filterung gibt es in
der Handbuchseite und im Artikel ``SS Utility: Quick Intro'', den ich bei
der Dokumentation des iproute-Pakets finde.

### tc

Mit dem Programm tc (traffic control) kann ich die Einstellungen zur
Verkehrssteuerung des Kernels ansehen und manipulieren.

Dabei gilt es drei Arten von Objekten zu unterscheiden:

QDISC
: (queueing discipline) beschreiben das
  Warteschlangenverhalten, das heißt, wie und in welcher Reihenfolge
  Datenpakete, die in eine QDISC eingereiht wurden, an den Treiber der
  Netzwerkkarte zum Senden übergeben werden. Wenn ein Datenpaket gesendet
  werden soll, wird es in die für das Interface konfigurierte QDISC
  eingereiht. Unmittelbar danach versucht der Kernel, so viele Pakete wie
  möglich an den Netzwerkadapter zu übergeben.

CLASS
: (Klassen) können in QDISC enthalten sein und wiederum weitere
  QDISC enthalten.
  Datenpakete werden in den inneren QDISC eingereiht.
  Datenpakete, die an den Netzwerkadapter übergeben werden, können
  von jeder inneren QDISC kommen.
  Dadurch, dass bestimmte Klassen vor anderen an die Reihe kommen, wird der
  Datenverkehr priorisiert.

FILTER
: entscheiden, welcher Klasse ein Datenpaket bei einem
  klassenbasierten QDISC zugeordnet wird. Alle Filter einer Klasse werden
  aufgerufen, bis einer eine Entscheidung trifft.

#### Klassenlose QDISC

Die folgenden Klassenlosen QDISC stehen zur Verfügung:

fifo
: ist die einfachste Form (First In, First Out). Die QDISC
  kann auf Paketebene (pfifo) oder Byteebene (bfifo) begrenzt werden.

pfifo_fast
: ist die Standard-QDISC für Advanced Router Kernel. Diese
  enthält eine dreireihige Warteschlange, die das TOS-Feld und die
  Priorität des Datenpakets beachten.

red
: (Random Early Detection) simuliert eine überlastete Leitung,
  indem zufällig Datenpakete verworfen werden, wenn sich der Durchsatz der
  konfigurierten Datenübertragungsrate nähert.

sfq
: (Stochastic Fairness Queueing) sortiert die wartenden
  Datenpakete um, so dass jede Sitzung reihum dran ist.

tbf
: (Token Bucket Filter) ist geeignet, um den Traffic zu einer
  präzise konfigurierten Datenübertragungsrate zu verlangsamen.

Klassenlose QDISC müssen an der Wurzel installiert werden:

{line-numbers=off,lang="text"}
    # tc qdisc add dev $device root $disc $params

#### Klassenbasierte QDISC

Die folgenden klassenbasierten QDISC stehen zur Verfügung:

cbq
: (Class Based Queueing) bildet eine Hierarchie von Klassen, die
  sich einen Link teilen und kann sowohl priorisieren als auch den
  Durchsatz begrenzen.

htb
: (Hierarchy Token Buffer) ermöglicht garantierte Datenübertragungsraten für
  Klassen und erlaubt die Ausgabe von oberen Grenzen für das Teilen von
  Datenübertragungsrate zwischen Klassen.
  Es enthält begrenzende Elemente auf Basis von TBF und kann Klassen
  priorisieren.

prio
: wird für Priorisierung ohne Begrenzung der Datenübertragungsrate verwendet.

#### Theorie

Die Klassen formen einen Baum, bei dem jede Klasse genau einen Vorfahren hat
und mehrere Kinder haben kann.

Manche QDISC erlauben zur Laufzeit Klassen hinzuzufügen (CBQ, HTB), andere
nicht (PRIO). Erstere können beliebig viele (auch keine) Subklassen haben,
in denen die Datenpakete einsortiert werden.

Jede Klasse enthält genau ein Blatt-QDISC (per Default pfifo), welcher durch
ein anderes ersetzt werden kann. Diese QDISC kann wiederum andere Klassen
enthalten, die zunächst auch nur ein QDISC haben.

Wenn ein Datenpaket in einer klassenbasierten QDISC ankommt, wird es genau
einer der enthaltenen Klassen zugeordnet. Sind Filter für eine Klasse
definiert, werden diese zuerst für die Klassifizierung herangezogen. Einige
QDISC werten auch das TOS-Feld des IP-Headers aus.

Jeder Knoten im Klassenbaum kann seine eigenen Filter haben. Filter in
höheren Ebenen können direkt auf niedrigere Klassen verweisen.

Wenn ein Paket nicht klassifiziert werden konnte, geht es in die
Blatt-QDISC der Klasse.

#### Namen

Alle QDISC, Klassen und Filter haben Ids, die automatisch bestimmt oder
explizit spezifiziert werden. Diese Ids bestehen aus einer Haupt- und einer
Nebennummer, getrennt durch Doppelpunkt.

Eine QDISC, welche Kinder haben kann, bekommt eine Hauptnummer,
die 'Handle' genannt wird und lässt die Nebennummer als Namensraum für die
Klassen. Üblicherweise benennt man QDISC, die Kinder haben, explizit.

Alle Klassen, die zur selben QDISC gehören, teilen sich die gleiche
Hauptnummer.
Jede hat eine separate Nebennummer, die Class-Id genannt wird und sich auf
die QDISC (nicht die Elternklasse bezieht).

Filter haben eine dreiteilige Filter-Id, die nur bei einer Filter-Hierarchie
benötigt wird.

#### tc Befehle

add
: Fügt eine QDISC, Klasse oder einen Filter an. Der Vorfahre
  (root oder Class-Id) muss angegeben werden. QDISC oder Filter können mit
  dem `handle` Parameter benannt werden, Klassen mit `classid`.

remove
: entfernt eine QDISK

change
: modifiziert eine Einheit am Ort

replace
: gleichzeitiges `remove` / `add`, der neue Knoten
  wird gegebenenfalls neu erzeugt

link
: gleichzeitiges `remove` / `add`, der neue Knoten muss bereits existieren.

Weitere Informationen finden sich in der Handbuchseite von `tc`.

### lnstat / nstat / rtacct

Diese Programme liefern Netzwerkstatistiken.
Für nähere Informationen siehe
Handbuchseiten.

### rtmon

Mit dem Programm rtmon kann ich Änderungen an der Routingtabelle des Kernels
über den `netlink` Socket beobachten. Das Programm kann vor der ersten
Netzwerkkonfiguration, zum Beispiel in einem Init-Script, gestartet werden.

Rtmon schreibt in eine Datei und stellt der Historie der Routingtabelle
einen Schnappschuss des Zustandes beim Start des Programms voran. Die Datei
kann ich mit dem bereits besprochenen Programm ip auswerten.

Der typische Aufruf sieht in etwa so aus:

{line-numbers=off,lang="text"}
    # rtmon file /var/log/rtmon.log

Anschließend kann ich die protokollierten Änderungen wie folgt ausgeben
lassen:

{line-numbers=off,lang="text"}
    # ip monitor file /var/log/rtmon.log

Sowohl beim Aufruf von rtmon, als auch bei dem von ip kann ich angeben, an
welchen Objekten ich interessiert bin:

link
: den Netzwerkgeräten

address
: den Protokolladressen (IPv4, IPv6) an einem Gerät

route
: den Einträgen der Routingtabelle

all
: an allem

Weitere Informationen finden sich auch hier in der Handbuchseite.


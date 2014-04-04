
## Routingprobleme

> "Die Kunden beschweren sich über Verbindungsabbrüche, kannst Du bitte mal
> die Leitung prüfen."
>
> So doer so ähnlich höre ich es ab und zu von den Kollegen, ich sehe mir die
> Leitung an und kann nichts auffälliges entdecken.

Da wir ein relativ komplexes Netz betreiben, mit mehreren Dutzend einzelnen
Segmenten, verwenden wir Routingprotokolle, um den einzelnen Gateways die
Routen bekannt zu machen.

Und diese Routingprotokolle, so sehr sie die Arbeit auch erleichtern, bringen
zusätzliche Angriffsflächen in das System, über die sich Fehler einschleichen
können.

Nun kann man sich auf den Standpunkt stellen: ich eliminiere diese
Fehlerquelle, indem ich in meinem Netz nur statische Routen verwende.
Bis zu einer gewissen Anzahl von Netzsegmenten ist das eine vernünftige
Entscheidung.
Irgendwann kommt aber der Punkt, ab dem ich die nötige Sorgfalt beim Eintragen
der statischen Routen einfach nicht mehr aufbringen kann.
Wo die Grenze ist, muss jeder für sich entscheiden.
Insbesondere, wenn Netze nur temporär betrieben werden und nach wenigen Tagen
bereits wieder ausgetragen werden müssen, verschiebt sich diese Grenze sehr
schnell nach unten.

A> Es gibt auch die Ansicht, das mit Hilfe von Routingprotokollen das Netz
A> automatisch zu einem neuen stabilen Zustand konvergiert, wenn einzelne Pfade
A> ausfallen, das Netz aber trotzdem genügend redundante Wege hat.
A> In diesem Fall würde ich meine Erwartungen aber nicht zu hoch schrauben, da
A> es sich um ein verteiltes dezentrales System handelt, dessen Verhalten im
A> Fehlerfall nicht am grünen Tisch vorhergesagt werden kann.

Was aber kann ich tun, wenn ich auf Grund der Komplexität des Netzes ein oder
mehrere Routingprotokolle einsetze und bei festgestellten Verbindungsabbrüchen
sicher gehen will, dass diese nicht doch vom Routing stammen?

An dieser Stelle setze ich einmal mehr auf Monitoring, also lückenlose
Beobachtung der Routen im Netz.
Gerade ein Rechnernetz ist ein Paradebeispiel für ein verteiltes System,
dessen Funktionieren vom Funktionieren seiner einzelnen Komponenten abhängt.
Und da bin ich schon daran interessiert, so früh, wie möglich festzustellen,
wenn eine Komponente nicht mehr funktioniert.

### Wie kann ich die Netzwerkrouten überwachen?

Sicher gibt es für dieses Problem kommerzielle Systeme, mit denen das Netzwerk
und mit diesem auch Routingprobleme bequem und einfach diagnostiziert werden
können.

In diesem Buch geht es aber um frei Software und darum, ein Verständnis für
das untersuchte Problem zu entwickeln.

Ich kann mit der - zumindest von mir - unter Linux am häufigsten eingesetzten
Routingsoftware *Quagga* nicht nur meinen Rechner selbst am Routingprotokoll
teilnehmen lassen, sondern auch über die Debugfunktionen den Zustand der
Protokolle analysieren und über die Protokollfunktion das Routing überwachen.

Will ich  nur allgemein mitbekommen, wann welche Route im Netz hinzukam oder
verschand, wende ich mich direkt an den Dämon `zebra`.
Ich schalte das Logging ein und teile ihm mit, welche Informationen ich haben
will.

    $ telnet localhost zebra
    zebra> enable
    zebra# conf t
    zebra(config)# log syslog
    zebra(config)# debug zebra rib
    zebra(config)# end
    zebra# write file

Dadurch, das ich `zebra` via Syslog protokollieren lasse, kann ich die
Auswertung auf einem anderen Rechner vornehmen, wenn `syslogd` entsprechend
konfiguriert ist.
Mit `debug zebra rib` habe ich ihm mitgeteilt, dass ich Informationen zur
Routing Information Base haben will.
Daraufhin finde ich Einträge wie diese für entfernte Routen:

    Aug 26 10:16:43 netinfo1 zebra[1651]: rib_delnode: 10.10.0.0/16: rn 0xb7831b50, rib 0xb7833ec8, removing
    Aug 26 10:16:43 netinfo1 zebra[1651]: rib_process: 10.10.0.0/16: Deleting fib 0xb7833ec8, rn 0xb7831b50
    Aug 26 10:16:43 netinfo1 zebra[1651]: rib_process: 10.10.0.0/16: Removing existing route, fib 0xb7833ec8

Die Einträge für hinzugekommene Routen sehen so aus:

    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_add_ipv4_multipath: called rib_addnode (0xb785db48, 0xb785e4d8) on new RIB entry
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_add_ipv4_multipath: dump complete
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_add_ipv4_multipath: dumping RIB entry 0xb785e4d8 for 10.147.0.0/16
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_add_ipv4_multipath: metric == 10, distance == 110, flags == 0, status == 0
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_add_ipv4_multipath: nexthop_num == 1, nexthop_active_num == 0, nexthop_fib_num == 0
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_add_ipv4_multipath: NH 0.0.0.0 (0.0.0.0) with flags 
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_link: 10.147.0.0/16: new head, rn_status copied over
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_link: 10.147.0.0/16: rn 0xb785db48, rib 0xb785e4d8
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_process: 0.0.0.0/0: Adding route, select 0xb785e200
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_process: 10.0.0.1/32: Adding route, select 0xb785d778
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_process: 10.147.0.0/16: Adding route, select 0xb785db88
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_process: 10.147.0.0/16: Updating existing route, select 0xb785db88, fib 0xb785db88
    Aug 26 10:16:47 netinfo1 zebra[17035]: rib_process: 10.147.0.0/16: Updating existing route, select 0xb785db88, fib 0xb785db88

Diese Logzeilen sind schon sehr informativ, für eine schnelle Auswertung auf
einen Blick aber zu unübersichtlich.

Ich nehme daher mein Standardgerüst für Perl-Skripts zur Syslog-Auswertung und
ergänze dieses um die folgenden Zeilen:

    my $wanted = 'zebra';
    my $re_ip4prefix = qr|(\d{1,3}(?:\.\d{1,3}){3}/\d{1,2})|;
    my $re_ip6prefix = qr|([0-9a-f:]+/\d+)|;

    sub process_line {
        my ($time,$host,$name,$pid,$text) = @_;

	if ($text =~ /^rib_process: $re_ip4prefix: Removing existing route/) {
	    print "$time $host $name: remove $1\n";
        }
	elsif ($text =~ /^rib_process: $re_ip6prefix: Removing existing route/) {
	    print "$time $host $name: remove $1\n";
        }
        elsif ($text =~ /^rib_process: $re_ip4prefix: Adding route, (.+)$/) {
            print "$time $host $name: add $1\n";
        }
        elsif ($text =~ /^rib_process: $re_ip6prefix: Adding route, (.+)$/) {
            print "$time $host $name: add $1\n";
        }
    }

Damit sieht die Ausgabe dann so aus:

    Aug 26 10:16:43 netinfo1 zebra: remove 10.10.0.0/16
    Aug 26 10:16:47 netinfo1 zebra: add 0.0.0.0/0
    Aug 26 10:16:47 netinfo1 zebra: add 10.0.0.1/32
    Aug 26 10:16:47 netinfo1 zebra: add 10.147.0.0/16

Alternativ hätte ich die Änderungen auch in eine Datenbank schreiben können,
die ich dann interaktiv abfragen könnte.

Sagt mir mein Routing-Monitor, dass ein festgestellter Verbindungsabbruch mit
einer Routingänderung einhergeht, muss ich mich näher mit den eingesetzten
Routingprotokollen beschäftigen.

Ein sehr guter Einstieg in das Thema ist [[Malhotra2002](#bib-malhotra2002)].
Zum einen, weil er auf die bei uns eingesetzten Protokolle detailliert eingeht
und zum anderen, weil ich die für Cisco IOS geschriebenen
Konfigurationsbeispiele mit Quagga sehr gut nachvollziehen kann.

Da wir mit unseren Netzen kein AS betreiben, kommen wir mit den Protokollen
RIP-2 und OSPF sowie einigen statischen Routen aus.

### RIP-2

Das ist ein sehr einfaches und robustes Protokoll, das gegenüber seinem
Vorgänger RIP vor allem mit der Fähigkeit zu CIDR überlegen ist.
RIP und RIP-2 nutzen den Distance-Vektor-Algorithmus zur Berechnung der
Routen.
Außerdem kann es die Next-Hop-Address zu einer Route angeben, wodurch ich mit
RIP-2 einen Übergang zu anderen Routing-Protokollen schaffen kann.
Weiterhin ist es möglich, Authentisierungsdaten zu senden, um die Quelle eines
RIP-2-Datagramms zu verifizieren.

Die Authentisierungsdaten schützen meine Router davor, fehlerhafte Routen von
zufällig im Netz eingesteckten fremden Routern zu übernehmen.
Gleichzeitig verhindern sie den Austausch der Routen zwischen meinen Routern,
falls ich die Authentisierungsinformationen falsch eingetragen habe.

Bei Problemen melde ich mich via `telnet` am RIP-Dämon an:

{line-numbers=off,lang="text"}
    $ telnet localhost ripd

Dann kann ich den Zustand des RIP-Protokolls analysieren.
Zum Monitoring kann ich, wie beim `zebra` Dämon, verschiedene Debugbefehle
nutzen.
Insbesondere schaue ich nach, welche Nachbarn der Router kennt, wann er die
letzten Informationen von diesen bekommen hat und welcher Nachbar welche Route
anbietet.

### OSPF

OSPF ist ein hierarchisches Protokoll.
Ich teile das Netz in einzelne Areas (Gebiete) auf, die über eine Zentrale
(Area 0) miteinander verbunden sind.
Die Router in den Areas müssen lediglich die Routen innerhalb der Area und die
Grenzrouter zu anderen Areas oder externen Netzen kennen.
Das Protokoll verwendet den Link-State-Algorithmus für die Berechnung der
Router, das heißt, jeder Router kennt den Zustand aller Interfaces aller
anderen Router seiner Area und berechnet selbst für sich den kürzesten Pfad
für eine gegebene Route.
OSPF konvergiert meist schneller bei Routingänderungen zum neuen Zustand des
Netzes.
Dafür ist die Berechnung der neuen Route CPU-intensiv.

#### Fehlersuche bei OSPF

Um das OSPF-Protokoll, genaugenommen seinen Zustand zu analysieren, melde ich
mich am *ospfd* von *quagga* an und arbeite überwiegend mit den über `show ip
ospf` erreichbaren Befehlen.

Mit `show ip ospf interface` sehe ich, welche Interfaces aktiv sind, am
OSPF-Protokoll teilnehmen und welche Nachbarn sie kennen.

Um mehr über die Nachbarn zu erfahren, verwende ich die über `show ip ospf
neighbor` erreichbaren Befehle.

Da OSPF sehr prozessorlastig ist, muss ich eventuell nachsehen, ob ein Router
vielleicht überlastet ist.
Dabei helfen mir die folgenden Faustregeln, um die zu erwartende Last grob
einzuschätzen:

*   ABR machen mehr als interne Router
*   DR/BDR machen mehr als andere Router
*   Router in Stub Areas und NSSA machen am wenigsten.

Gegebenenfalls setze ich an den entsprechenden Stellen leistungsstärkere
Router ein oder sorge dafür, dass ein schwächerer Router nicht DR/BDR wird.

Mit dem Befehl `show ip ospf` bekomme ich auch heraus, wie oft der
OSPF-Algorithmus ausgeführt wurde:

{line-numbers=off,lang="text"}
    ospfd> sh ip ospf
     ...
     SPF algorithm last executed 12h37m18s ago
     ...
     Area ID: 0.0.0.0 (Backbone)
       ...
       SPF algorithm executed 4039 times

Wenn die letzte Zahl sehr hoch ist, und vielleicht noch wächst, während ich
angemeldet bin, deutet das auf ein flatterndes Interface hin.

In diesem Fall kann ich mit den über `debug ospf` erreichbaren Befehlen nach
dem betreffenden Router fahnden und dann das Problem dort untersuchen.
Einfacher ist die Ursache vielleicht zu finden, wenn ich sowieso alle
Routingänderungen protokolliere und anhand dieser Protokolle auf die Ursache
schließe.

Suche ich hingegen nach einer relativ stabilen aber falschen Route, dann kann
ich die LS-Datenbank mit den über `show ip ospf database` erreichbaren
Befehlen untersuchen.

### Gemischter Einsatz von statischen und dynamischen Routen

Wenn man in einem Netz sowohl statische als auch dynamische Routen einsetzt,
ist besondere Vorsicht geboten.
Zunächst einmal muss die Einspeisung der statischen Route in das dynamische
Protokoll sorgfältig geprüft werden.
Genauso wichtig ist die korrekte und vor allem wiederauffindbare Dokumentation
dieser Besonderheit.

In einem konkreten Fall hatte ich eine statische Route an einem Border Router
in das OSPF eingespeist.
Später wurde der Next-Hop, über den die Route ging ebenfalls in die OSPF-Area
aufgenommen.
Der alte Router speiste weiterhin seine (für ihn korrekte) statische Route in
die OSPF-Area.
Der neu aufgenommene Router erhielt nun die korrekte Route via RIP-2, das
niedriger priorisiert war und die (für ihn falsche) Route aus dem OSPF vom
alten Border-Router.
Im Ergebnis sandte er die Datenpakete in die falsche Richtung und ich
benötigte einige Zeit und Muße, bis ich durch Vergleich der
OSPF-Routing-Databases der verschiedenen Router darauf kam und die statische
Router als Verursacher ausmachte.

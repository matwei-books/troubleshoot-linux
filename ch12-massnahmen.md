
## Maßnahmen

Je nachdem, was ich als Ursache für das Performanceproblem ermittelt habe,
greife ich zur entsprechenden Abhilfe.

Bei überlasteter Hardware, wie Gateways, Switches und ähnlichem, schaue
ich mich um, ob ich etwas leistungsfähigeres finde und einsetzen kann.

Liegt der Flaschenhals in einer Leitung zu einem anderen Standort, muss ich
vielleicht eine bessere Leitung anmieten, kaufen oder verlegen lassen.

Kurzfristig kann ich das Problem vielleicht mit QoS verlagern.
Will ich QoS langfristig im Netz einsetzen, muss ich dafür sorgen, dass das
immer gut dokumentiert wird und dass die Administratoren ausreichend
geschult werden.
Dabei ist QoS nicht nur auf Traffic-Shaping beschränkt.
Einige Dienste, wie zum Beispiel Squid-Proxy-Server enthalten Möglichkeiten
zur gezielten Beschränkung der Datenübertragungsraten.

Dabei muss ich auf Nebeneffekte achten.
In einem Fall blieb für den E-Mail-Verkehr so wenig Datenübertragungsrate,
dass einzelne, sehr große E-Mail mehrere Stunden für die Übertragung benötigten.
Dementsprechend musste ich die Timer an den Mailservern anpassen.

Eine gute Idee ist in vielen Fällen, den Traffic zu reduzieren.
Kurzfristig könnte ich einige Dienste abschalten oder deren Traffic niedriger
priorisieren.
Langfristig kann ich durch geschickte Platzierung von Servern und den Einsatz
von Proxy-Servern den Traffic reduzieren.

Sollte das Netzwerkperformanceproblem sich als Performanceproblem des Servers
oder Client-Rechners erweisen, kann ich es wie in Kapitel 7 beschrieben,
angehen.

Manche Software erlaubt es, mit bestimmten Einstellungen besser mit hoher
Latenz zu arbeiten.
In der Konfiguration gibt es dann vielleicht die Möglichkeit, die Verbindung zum
Server als WAN-Verbindung zu deklarieren.
Das bringt bei hoher Latenz manchmal schon eine Erleichterung für den
Anwender.

### Traffic-Shaping

Manchmal bleibt mir auf Grund von Beschränkungen, die ich im Moment nicht
beeinflussen kann, nur, den Datenverkehr einzuschränken und zu priorisieren.
Dabei muss ich einige Dinge beachten:

*   Wenn ich den Datenverkehr beschränken will, muss ich sicherstellen, dass
    ich den Flaschenhals kontrolliere.
    Das ist meist der Übergang von einer schnellen auf eine langsame Leitung
    oder ein Gateway, an dem mehrere ankommende Leitungen auf eine abgehende
    Leitung treffen.
*   Ich kann nur den abgehenden Verkehr direkt beeinflussen.
    Das heißt, wenn ich mich um ein langsames Datensegment kümmere, begrenze
    ich von beiden Seiten den jeweils abgehenden Verkehr.
*   Wenn ich gezielt nur einen Teil des Datenverkehrs begrenzen will, mache
    ich das so nah wie möglich an der Quelle.

Nachdem das geklärt ist, kann nun zum praktischen Teil übergehen.
Das [Linux Advanced Routing & Traffic Control](http://lartc.org/) HowTo
(LARTC) liefert, insbesondere in Kapitel 9, *Queueing Disciplines for
Bandwidth Management*, das nötige Hintergrundwissen.

An dieser Stelle zeige ich nur kurz an einem Beispiel, wie die verschiedenen
Elemente zusammenspielen.
In diesem Beispiel will ich an einer 100 MBit/s Leitung den Datenverkehr zu
bestimmten Geräten auf 10 MBit/s beschränken, um diese Geräte zu entlasten.
Dazu verwende ich die Queueing Discipline (Qdisc) *Hierarchical Token Bucket*
(HTB), weil diese einfach zu konfigurieren ist und zuverlässig funktioniert.

Zunächst ändere ich die Qdisc des Interface auf HTB:

    DEV=eth1
    tc qdisc add dev $DEV root handle 1:0 htb default 11 r2q 65

Mit `default 11` habe ich festgelegt, dass nicht anders klassifizierter
Datenverkehr bei Klasse 11 einsortiert wird.

Die Angabe `r2q 65` wird zur Berechnung des Quantums benötigt, welches
wiederum herangezogen wird, um zu bestimmen, wie der Datenverkehr aufzuteilen
ist, der zwischen dem konfigurierten Minimum und der Obergrenze liegt.
Weitergehende Erläuterungen dazu finden sich in den FAQ des LARTC.

Zu dieser HTB Qdisc füge ich nun eine Klasse für den gesamten Traffic am
Interface:

    tc class add dev $DEV parent 1:0 classid 1:1 htb rate 99mbit ceil 99mbit \
       burst 1200kb cburst 1200kb

An dieser Stelle habe ich die Möglichkeit, die Datenrate des gesamten Verkehrs
beschränken, wenn ich zum Beispiel ein langsames Modem über Ethernet
angeschlossen habe.
In diesem Fall wähle ich einen Wert für `rate` und `ceil`, der etwas niedriger
als die Übertragungsgeschwindigkeit ist und stelle damit sicher, dass sich die
Datenpakete in diesem Rechner stauen und nicht am Modem.

Mit `burst` und `cburst` stelle ich ein, wieviel Traffic maximal mit voller
Geschwindigkeit gesendet werden kann, wenn längere Zeit kein oder weniger
Traffic ankam, als konfiguriert ist.

Nun benötige ich noch eine Klasse für den "eingeschränkten" und eine für den
"normalen" Datenverkehr:

    tc class add dev $DEV parent 1:1 classid 1:10 htb rate 5mbit ceil 10mbit
    tc class add dev $DEV parent 1:1 classid 1:11 htb rate 20mbit ceil 99mbit \
       burst 1200kb cburst 1200kb

Die Klasse für den "normalen" Datenverkehr benötige ich unbedingt, da sonst
sämtlicher Datenverkehr in der beschränkten Klasse landet und begrenzt wird.

A> Bei dem Problem, von dem dieses Beispiel abgeleitet ist, hatte ich zunächst
A> nur mit einer "beschränkten" Klasse gearbeitet und nur getestet, dass die
A> Beschränkung auch wirkt.
A> 
A> Außer der Klasse für den "normalen" Datenverkehr vergaß ich auch zu testen,
A> wie schnell die Leitung danach für den anderen Datenverkehr war.
A> Da die Kunden sich nicht sofort meldeten, dauerte es geraume Zeit, bis ich
A> meinen Fehler erkannte und die Konfiguration entsprechend korrigierte.
A> 
A> Ein Grund mehr, zu jedem Test auch eine Gegenprobe zu machen.

Nun muss ich den Datenverkehr nur noch richtig einsortieren, damit die
Beschränkung wirksam wird.
Dazu füge ich einen Filter ein:

    tc filter add dev $DEV parent 1:0 prio 0 protocol ip handle 10 \
       fw flowid 1:10

Dieser Filter verwendet Markierungen an den Datagrammen, die ich mit
`iptables` anbringe.

    iptables -A FORWARD -d 192.168.7.16/32 -p tcp \
             -j MARK --set-xmark 0xa/0xffffffff 
    iptables -A FORWARD -d 192.168.7.22/32 -p tcp \
             -j MARK --set-xmark 0xa/0xffffffff

Damit ist die Auswahl, welcher Datenverkehr beschränkt wird, von der
eigentlichen Beschränkung entkoppelt.

### Bufferbloat

Bei Bufferbloat an einem Übergang zu einer Leitung mit niedriger Datenübertragungsrate
habe ich nicht viele Möglichkeiten.

Eine wirksame Abhilfe bei Bufferbloat verspricht das Queue-Management mit dem
CoDel-Verfahren.
Dabei bekommen ankommende Datenpakete einen Zeitstempel.
Sobald ein Paket zu lange in einer Queue verbleibt, werden nachfolgende Pakete
verworfen, noch bevor die Queue überfüllt ist.
Die TCP-Flusskontrolle der betroffenen Verbindungen kann schneller
reagieren und drosselt die Transfer-Rate eher, wodurch die Leitung entlastet
wird.

Diese Lösung funktioniert recht gut und hat den Vorteil, dass außer dem
Queue-Management am Router nichts geändert werden muss.
Ein weiterer wesentlicher Vorteil ist, dass der Administrator keine Parameter
bestimmen oder einstellen muss, wodurch eine mögliche Fehlerquelle entfällt.

In [[ctTZ2013a](#bib-ct-tz2013a)] erläutern die Autoren Queue-Management mit
CoDel für den Laien verständlich und in
[[ctTZ2013b](#bib-ct-tz2013b)] zeigen sie, wie man mit der Firewall-Appliance
IPFire erste eigene Erfahrungen damit sammeln kann.

CoDel ist im Linux-Kernel ab Version 3.5 enthalten.
Bei einem älteren Kernel, der CoDel nicht unterstützt, bleibt mir nur, mit QoS
und Priorisierung genügend Datenübertragungsrate für wichtige Anwendungen zu reservieren.
Dazu muss ich die Datenströme genau analysieren.


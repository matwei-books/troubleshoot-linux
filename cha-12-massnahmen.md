
## Maßnahmen

Je nachdem, was ich als Ursache für das Performanceproblem ermittelt habe,
greife ich zur entsprechenden Abhilfe.

Bei überlasteter Hardware, wie Gateways, Switches und ähnlichem, schaue
ich mich um, ob ich etwas leistungsfähigeres finde und einsetzen kann.

Liegt der Flaschenhals in einer Leitung zu einem anderen Standort, muss ich
vielleicht eine bessere Leitung anmieten, kaufen oder verlegen lassen.

Kurzfristig kann ich das Problem vielleicht mit QoS verlagern.
Will ich QoS langfristig im Netz einsetzen, muss ich dafür sorgen, dass das
immer gut dokumentiert wird und dass die Administratoren entsprechend
geschult werden.
Dabei ist QoS nicht nur auf Traffic-Shaping beschränkt.
Einige Dienste, wie zum Beispiel Squid-Proxy-Server enthalten Möglichkeiten
zur gezielten Beschränkung der Bandbreiten.

Eine gute Idee ist in vielen Fällen, den Traffic zu reduzieren.
Kurzfristig könnte ich einige Dienste abschalten oder deren Traffic niedriger
priorisieren.
Langfristig kann ich durch geschickte Platzierung von Servern und den Einsatz
von Proxy-Servern den Traffic reduzieren.

Sollte das Netzwerkperformanceproblem sich als Performanceproblem des Servers
oder Client-Rechners erweisen, kann ich es wie in Kapitel 7 beschrieben
angehen.

Manche Software erlaubt es, mit bestimmten Einstellungen besser mit hoher
Latenz zu arbeiten.
In der Konfiguration gibt es dann mitunter die Möglichkeit, die Verbindung zum
Server als WAN-Verbindung zu deklarieren.
Das bringt bei hoher Latenz mitunter schon eine Erleichterung für den
Anwender.

### Bufferbloat

Bei Bufferbloat an einem Übergang zu einer Leitung mit niedriger Bandbreite
habe ich nicht viele Möglichkeiten.

Das zur Zeit beste Verfahren beim Umgang mit Bufferbloat ist ein
Queue-Management mit dem CoDel-Verfahren.
Bei diesem Verfahren werden ankommende Datenpakete mit einem Zeitstempel
versehen.
Sobald ein Paket zu lange in einer Queue verbleibt, werden nachfolgende Pakete
verworfen, noch bevor die Queue überfüllt ist.
Die TCP-Flusskontrolle der betroffenen Verbindungen kann damit schneller
reagieren und drosselt die Transfer-Rate.

Diese Lösung funktioniert recht gut und hat den Vorteil, dass außer dem
Queue-Management am Router nichts geändert werden muss.
Ein weiterer wesentlicher Vorteil ist, dass der Administrator keine Parameter
bestimmen oder einstellen muss, wodurch eine weitere mögliche Fehlerquelle
entfällt.
In [[ctTZ2013a](#bib-ct-tz2013a)] erläutern die Autoren das
CoDel-Queue-Management verständlich und in [[ctTZ2013b](#bib-ct-tz2013b)]
zeigen sie, wie man mit der Firewall-Appliance IPFire erste eigene Erfahrungen
sammeln kann.

CoDel ist im Linux-Kernel ab Version 3.5 enthalten.
Bei einem älteren Kernel, der kein CoDel unterstützt, bleibt mir nur, mit QoS
und Priorisierung genügend Bandbreite für wichtige Anwendungen zu reservieren.
Dazu muss ich die Datenströme genau analysieren und mir klar sein über die
Anforderungen.
Hier ist viel Fingerspitzengefühl gefragt.
In einem konkreten Fall blieb für den E-Mail-Verkehr so wenig Bandbreite, dass
einzelne sehr große E-Mail mehrere Stunden für die Übertragung benötigten.
Dazu musste ich dann auch die Timer an den Mailservern entsprechend anpassen.


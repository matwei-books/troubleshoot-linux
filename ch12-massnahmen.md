
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


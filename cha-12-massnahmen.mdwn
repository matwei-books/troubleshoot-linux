
## Maßnahmen

Je nachdem, was ich als Ursache für das Performanceproblem ermittelt habe,
greife ich zur entsprechenden Abhilfe.

Bei überlasteter Hardware, wie Gateways, Switches und ähnlichem, schaue
ich mich um, ob ich etwas leistungsfähigeres finde und einsetzen kann.

Liegt der Flaschenhals in einer Leitung zu einem anderen Standort, muss ich
vielleicht eine bessere Leitung anmieten, kaufen oder verlegen lassen.

Kurzfristig kann ich das Problem vielleicht mit QoS verlagern.
Will ich QoS langfristig im Netz einsetzen, muss ich dafür sorgen, dass das
immer gut dokumentiert wird und dass die Administratioren entsprechend
geschult werden.
Dabei ist QoS nicht nur auf Traffic-Shaping beschränkt.
Einige Dienste, wie zum Beispiel Squid-Proxy-Server enthalten Möglichkeiten
zur gezielten Bandbreitenbeschränkung.

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


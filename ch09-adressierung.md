
## Kommunikationsbeziehungen

In Rechnernetzen gibt es neben der paarweisen Kommunikation einzelner Rechner
verschiedene Kombinationen, die unter den Begriffen Unicast, Broadcast,
Multicast und Anycast zusammengefasst werden.

Wenn ich ein Netzwerkproblem analysiere, muss ich wissen, mit was für Verkehr
ich es zu tun habe und was das bedeuten kann.

### Unicast

Kommuniziert genau ein Rechner mit genau einem definierten anderen, spricht
man von einer Unicast-Verbindung.

Diese Verbindung kann über das gesamte Netzwerk gehen, also mehrere
Segmente überspannen.

Beispiele dafür sind HTTP und SMTP.

### Broadcast

Will ein Rechner alle anderen Rechner in einem Netzsegment erreichen,
verwendet er bei IPv4 Broadcast-Nachrichten.
Diese sind immer auf ein Subnetz beschränkt und werden an Broadcast-Adressen
versendet, von denen es
zwei Arten gibt: globale und subnetzspezifische Broadcast-Adressen.

Die globale Broadcast-Adresse (255.255.255.255) hat alle Bits gesetzt.
Mit dieser Adresse kann ich alle Rechner im direkt angeschlossenen Subnetz
erreichen, unabhängig vom Netzwerkpräfix.
Router leiten Datagramme an diese Adresse nicht weiter.
Früher konnte ich mit einem PING an die globale Broadcast-Adresse auf einfache
Weise herausfinden, ob ich mindestens einen im gleichen Segment
angeschlossenen Rechner erreichen kann.
Heutzutage beantwortet kaum ein Rechner noch einen PING an die
Broadcast-Adresse, wenn er nicht explizit dafür konfiguriert wurde.

Bei der subnetzspezifischen Broadcast-Adresse sind nur die Hostbits der Adresse
gesetzt, zum Beispiel ist 192.168.1.255 die Broadcast-Adresse für das Netz
192.168.1.0/24.
Diese Adresse richtet sich an alle Rechner in einem Subnetz.
Datagramme an subnetzspezifische Adressen wurden früher auch über Router
transportiert.
Da das jedoch für die Verstärkung von DoS-Angriffen ausgenutzt wurde,
unterbinden heute viele Router diesen Verkehr.

Die Protokolle ARP und RIP in Version 1 sind zwei Protokolle, die
Broadcast-Adressierung verwenden.

In IPv6 wurden Broadcast-Funktionen durch Multicast ersetzt.

### Multicast

Bei Multicast kommuniziert ein Sender oder eine relativ geringe
Anzahl von Sendern mit mehreren Empfängern.
Diese Kommunikation kann über mehrere Router gehen, wenn diese entsprechend
konfiguriert sind.
Die Reichweite ist genau bestimmt, da die Empfänger sich für
Multicast-Adressen beim Gateway registrieren müssen und die Gateways
ihrerseits das Routing von Multicast untereinander aushandeln.

Bei IPv4 ist für Multicast der Netzbereich 224.0.0.0/4 vorgesehen.
Davon ist der Bereich 224.0.0.0/24 reserviert für Routingprotokolle und
ähnliche Dienste für die Topologieerkennung und -wartung.

Bei IPv6 erkennt man eine Multicast-Adresse an den acht höchstwertigen Bits
der Adresse. Sind alle gesetzt, handelt es sich um eine Multicast-Adresse,
ansonsten ist es eine Unicast-Adresse. RFC 4291 spezifiziert die
Adressarchitektur von IPv6 und geht in Abschnitt 2.7 auf Multicast-Adressen
ein. 

Service Location Protocol und RIP in Version 2 verwenden Multicast.

### Anycast

Bei der Adressierung mit Anycast verwenden mehrere Rechner dieselbe Adresse.
Das führt im selben Netzsegment natürlich zu Kollisionen, darum werden die
Rechner mit der gleichen Adresse in verschiedenen Netzsegmenten platziert und
die Anycast-Adresse über Routingprotokolle im Netz bekannt gemacht.

Anycast-Adressierung wird eingesetzt, um Traffic einzusparen, indem
verschiedene Instanzen desselben Dienstes unter derselben Adresse an
verschiedenen Stellen im Netz möglichst nahe bei den Clients des Dienstes
platziert werden.

Neben dem eingesparten Datenverkehr ist ein weiterer Vorteil, das bei
Ausfall eines Servers automatisch der nächstgelegene übernimmt,
sobald das Routingprotokoll wieder konvergiert ist und den Verkehr auf diesen
umleitet.

Ein Problem bei Anycast ist die Synchronisation der Daten, die
anycast-adressierte Server anbieten.
Auch können Sitzungsdaten nicht einfach auf den neuen Server übernommen
werden. Daher eignet sich Anycast nicht für alle Dienste.

Für den Server ist eine anycast-addressierte Verbindung eine normale
Unicast-Verbindung.
Für den Client ist es, ohne Kenntnis der Routen im Netz, nicht möglich,
anzugeben, an welchen Server die Datagramme gesendet werden.

Eine länger laufende Anycast-Verbindung kann durch Änderungen beim
Routing irreversibel gestört werden.
Bei Protokollen mit kurzen Transaktionen, wie DNS, ist dieses Problem jedoch
unerheblich.

Problematisch kann die Zeit für die Konvergenz des Routingprotokolls sein,
wenn der Server sich nicht abmeldet, weil er plötzlich vom Netz getrennt wurde.

Daher ist neben der direkten Überwachung der Server eine Überwachung des
Routings angezeigt.

Anycast wird zum Beispiel bei den DNS-Rootservern verwendet.



## tcpdump {#sec-netz-werkzeuge-tcpdump}

Bei besonders schwierigen Netzwerkproblemen verwende ich - quasi als große
Kanone - tcpdump zum Mitschreiben des Datenverkehrs im Netz. Dabei setze ich
tcpdump vorzugsweise auf Servern, die keine grafische Benutzeroberfläche
haben, oder auf Routern/Bridges mit Linux oder BSD als Betriebssystem.

Ich verwende tcpdump dann

*   um das Verhalten andere Werkzeuge zu kontrollieren und zu
    verifizieren. Erhalte ich zum Beispiel via Ping keine Antwort von einer
    bestimmten IP-Adresse, sehe ich mit tcpdump nach, ob mein Rechner die
    ICMP-Anfragen überhaupt absendet. Sehe ich dann mit tcpdump die Antwort
    ebenfalls ankommen, kann ich auf die Firewallregeln auf meinem Rechner
    als Verursacher schließen.

*   um das Vorkommen bestimmter Datenpakete zu verifizieren. Zum einen
    überhaupt, wie im Beispiel mit Ping und zum anderen an verschiedenen
    Stellen im Netz, um durch Bisektion die Stelle im Netz zu finden, an der
    der Datenfluß unterbrochen wird.

*   um Protokollverhalten zu verifizieren und/oder Protokollfehler
    nachzuweisen. Das erfordert seinerseits widerum umfangreiche Kenntnisse
    der untersuchten Protokolle, die sich in vielen Fällen durch Studium der
    relevanten RFCs erlangen lassen.

*   um Datenmitschnitte für die Auswertung mit Wireshark zu sammeln.
    Zwar habe ich in Wireshark auch nur die selben Daten zur Verfügung wie
    in tcpdump, aber bereits die Statistikfunktionen können mir Hinweise auf
    Netzprobleme geben, die ich mit tcpdump gar nicht wahrgenommen hätte.
    Abgesehen davon ist die Darstellung der einzelnen Protokollschichten bei
    Wireshark einfach anschaulicher.

Nach dem ich nun geklärt habe, wofür ich tcpdump im Allgemeinen einsetze,
komme ich nun dazu, was ich damit konkret machen kann und wie ich das mache.

Die häufigste Anwendung ist das Mitschneiden von Datenverkehr. Dazu benötige
ich Superuserrechte. Je nachdem, wie viele Schnittstellen mein Rechner hat,
muss ich diese noch angeben. Prinzipiell schalte ich die Namensauflösung ab,
wenn ich mir die Datenpakete anzeigen lasse, um Verzögerungen durch
DNS-Anfragen zu vermeiden.

Will ich die mitgeschnittenen Daten nicht sofort auswerten, kann ich diese
auch in eine Datei schreiben lassen, die ich dann später mit tcpdump oder
wireshark auswerte. Für die Auswertung der Datei benötige ich keine
Superuserrechte sondern nur Leserechte auf die Datei.

Will ich über einen längeren Zeitraum Datenpakete mitschneiden und in
Dateien archivieren, kann ich tcpdump anweisen, bei Erreichen einer
bestimmten Dateigröße oder alternativ periodisch nach einer bestimmten Zeit
mit einer neuen Datei zu beginnen.

Manche IPSEC-Verbindungen kann tcpdump dekodieren, wenn ich den Schlüssel
angebe.

Bin ich nur an den Kopfdaten und nicht an den Anwendungsdaten interessiert,
kann ich die maximale pro Datenpaket mitgeschnittene Länge vorgeben. Damit
erhöht sich gleichzeitig die Verarbeitungsgeschwindigkeit, wenn ich die
Datei in eine Datei schreibe.

### Kommandozeilenoptionen

Die Optionen, die ich am häufigsten verwende, sind:

-n
: um die Namensauflösung abzuschalten. Diese Option benötige ich
  nicht, wenn ich den Mitschnitt lediglich in eine Datei schreibe.

-l
: um die Daten gleich während des Mitschnitts zu sehen.
  Andernfalls puffert tcpdump die Standardausgabe und zeigt die
  Datenpakete nicht sofort an, wenn sie eingetroffen sind.

-U
: um den Schreibpuffer beim Schreiben in eine Datei nach jedem
  angekommenen Datenpaket zu leeren. Das ist nützlich, wenn ich die
  geschriebene Datei in einem anderen Fenster zur gleichzeitigen
  Auswertung geöffnet habe. Dort verwende ich dann die Option `-l`.

-w filename
: um in eine Datei zu schreiben.

-r filename
: um aus einer Datei zu lesen.

-i device
: um das Interface anzugeben, an dem ich mitschreiben will.
  Ab einem Kernel der Version 2.2 ist es möglich an allen Interfaces
  gleichzeitig mitzuschreiben. Dafür gebe ich als Device `any` an.

-C filesize
: weist tcpdump an, beim Schreiben in eine Datei
  automatisch eine neue Datei zu öffnen, wenn die alte größer als
  `filesize` ist. An den Dateinamen wird eine fortlaufende Nummer angehängt.

-G seconds
: um die mit `-w` angegebene Datei nach der
  angegebenen Zeit zu rotieren. Der Name der Datei sollte eine
  Zeitformatangabe für strftime(3) haben, damit sie nicht überschrieben wird.

-F filename
: um den Filterausdruck, der sonst am Ende der
  Kommandozeile folgt, aus der angegebenen Datei zu lesen.

-q
: um die ausgegebenen Informationen zu reduzieren, so dass die
  Ausgabezeilen kürzer werden.

-v
: um mehr Informationen pro Datenpaket angezeigt zu bekommen.
  Ich kann mehrere `-v` verwenden, um noch mehr Informationen zu bekommen.

-s snaplen
: um die Zahl der Bytes pro Datenpaket, die mitgeschrieben
  werden, zu begrenzen. 0 bedeutet hier keine Begrenzung.

-W filecount
: um die Anzahl der Dateien, die mit `-C` oder `-G` automatisch erzeugt
  werden, zu begrenzen.

-x | -X
: um die Header und Daten als Hexadezimal- und ASCII-Werte ausgeben zu lassen.

### Filter

Ein wesentlicher Punkt beim Einsatz von tcpdump ist die Möglichkeit, durch
Filter zu bestimmen, welche Datenpakete mitgeschrieben werden und welche
nicht. Das macht man mit Filterausdrücken, die einfach am Ende der
Kommandozeile angefügt werden oder in einer Datei gesammelt und mit der
Option `-F dateiname` übergeben werden. Detaillierte Informationen zu
den Filtermöglichkeiten von tcpdump oder libpcap im Allgemeinen finden sich
in der Handbuchseite `pcap-filter`.
  
In den meisten Fällen hänge ich
den Filterausdruck an das Ende der Kommandozeile, weil das schneller geht.
Nur bei komplizierten Filtern schreibe ich den Filter vor Benutzung in eine
Datei.

Ein Filterausdruck besteht aus einem oder mehreren Primitiven, die über die
Begriffe `and`, `or` oder `not` miteinander kombiniert werden
können. Ein Primitiv besteht aus einer ID, das ist ein Name oder eine Zahl,
der ein oder mehrere Qualifizierer vorangestellt werden. Die Qualifizierer
bestimmen, welche Bedeutung die ID hat. So kann zum Beispiel die ID smtp
zusammen mit dem Qualifizierer zum einen auf eine Ethernetadresse verweisen
(`ether host smtp`), auf eine IP-Adresse (`host smtp`), auf den
TCP-Port 25 (`port smtp`) oder auf etwas anderes.

Es gibt drei Arten von Qualifizierern, die miteinander kombiniert werden
können:

Typqualifizierer
: geben an, worum es sich bei der ID handelt.
  Mögliche Typen sind `host` (ein einzelner Rechner), `net` (ein
  ganzes Netz, Netznamen können zum Beispiel in /etc/networks definiert
  werden), `port` (ein TCP- oder UDP-Port, Portnamen werden in
  /etc/services definiert) oder `portrange` (ein Portbereich, zwei
  Ports verbunden mit Bindestrich).

Richtungsqualifizierer
: geben die Datenübertragungsrichtung zu oder
  von der ID an. Mögliche Richtungen sind unter anderem `src`,
  `dst`, `src or dst`, `src and dst`, `inbound`,
  `outbound`. Fehlt der Richtungsqualifizierer, wird
  `src or dst` angenommen.

Protokollqualifizierer
: beschränken das Primitiv auf ein bestimmtes
  Protokoll. Das können unter anderem `ether` für Ethernet, `ip`
  für IPv4, `ip6` für IPv6, `arp`, `tcp`, `udp` sein.
  Protokollqualifizierer können noch weiter unterteilt sein, die Details
  entnimmt man im Zweifel der Handbuchseite.

Daneben gibt es noch einige spezielle Primitive, wie `gateway`,
`broadcast`, `less`, `greater` und arithmetische Ausdrücke,
die man in Filterausdrücken verwenden kann.

Nachfolgend erläutere ich noch einige Primitive, die ich relativ häufig
einsetze:

src host h | dst host h | host h
: Entweder die Quelladresse oder die Zieladresse oder
  mindestens eine von beiden gehört zu Host `h`.

ether src e | ether dst e | ether host e
: Entweder die Ethernet-Quelladresse oder die
  -Zieladresse oder mindestens eine von beiden ist `e`. Dabei kann
  `e` als sechs durch Doppelpunkt getrennte Hexbytes oder als Name,
  welcher in /etc/ethers definiert ist, angegeben werden.

gateway host
: Die Ethernet-Adresse gehört zu `host`, aber die
  IP-Adresse nicht. So kann man Datenpakete filtern, die über ein
  bestimmtes Gateway ankommen oder abgehen. Das funktioniert nur, wenn
  `host` sowohl als IP-Adresse als auch als Ethernet-Adresse
  aufgelöst werden kann.

src net n/l | dst net n/l | net n/l
: Entweder die Quelladresse oder die Zieladresse oder
  mindestens eine von beiden liegt im Netz `n` mit einer
  Bitmaskenlänge von `l`. Es gibt noch andere Primitive, um das
  auszudrücken, aber diese Notation funktioniert für IPv4 und IPv6.

src port p | dst port p | port p
: Entweder der Quellport oder der Zielport oder mindestens
  einer von beiden ist gleich `p`. Das ist nur gültig für TCP oder
  UDP. Falls `p` als Name angegeben wird, muss er in /etc/services
  definiert sein.

greater l | less l
: Die Paketlänge ist größer/gleich `l` oder kleiner/gleich `l`.
  Achtung, `l` ist nicht die Größe des angezeigten IP-Pakets sondern
  inklusive weiterer Protokollheader. Gegebenenfalls testet man das
  erstmal an einem einfacheren Filterausdruck.

ip proto p | ip6 proto p
: Das Potokoll `p` ist eines der in /etc/protocols definierten
  Protokolle oder die betreffende Nummer, zum Beispiel 1 für `icmp`,
  6 für `tcp`, 17 für `udp` oder 89 für `ospf`. Da
  `icmp`, `tcp` und `udp` Schlüsselwörter sind, müssen sie
  hier mit Backslash (`\`) geschützt werden: `\icmp`,
  `\tcp`, `\udp`.

ether broadcast | ip broadcast | ether multicast | ip multicast
: Diese Primitive sind wahr, wenn das betreffende Paket ein Ethernet- oder
  IP-Broadcast oder -Multicastpaket ist.

icmp | tcp | udp
: Sind Abkürzungen für `ip proto \p or ip6 proto \p`, wobei `p`
  für eines der drei Protokolle steht. Das heisst, ich bekomme die
  entsprechenden Protokolle, unabhängig davon, ob sie via IPv4 oder IPv6
  transportiert werden.

expr relop expr
: Damit ist es möglich, gezielt nach einzelnen Protokolloptionen zu
  filtern, vorausgesetzt man kennt die entsprechenden Positionen.

  So filtert zum Beispiel `ip[0] & 0xf != 5` alle IPv4 Pakete mit
  gesetzten Optionen.

  Damit lassen sich sehr spezielle Filter erzeugen. Es setzt allerdings
  auch sehr genaue Kenntnis der untersuchten Protokolle voraus.

Weitere Informationen zu Optionen, Filterausdrücken und deren Bedeutungen
gibt es in der Handbuchseite.



## OSI-Modell {#sec-osi-modell}

Ein wichtiges Modell für die Betrachtung von Netzwerkverbindungen ist das
*Open Systems Interconnection Model*.
Dieses dient als Referenzmodell für Netzwerkprotokolle und ist als
Schichtenmodell ausgeführt.
Es gibt keine Implementierung des OSI-Modells, dieses dient lediglich der
Einordnung realer Protokolle und der Kommunikation darüber.
In diesem Modell gibt es sieben aufeinanderfolgende Schichten mit jeweils
begrenzten Aufgaben.
Jede Instanz einer Schicht nutzt die Dienste der Instanzen der nächsttieferen
Schicht und stellt ihre Dienste den Instanzen der nächsthöheren Schicht zur
Verfügung.
Die folgenden Schichten sind im OSI-Modell definiert:

|   | deutsche Bezeichnung   | englische Bezeichnung |
|---|------------------------|-----------------------|
| 7 | Anwendungsschicht      | application layer     |
| 6 | Darstellungsschicht    | presentation layer    |
| 5 | Sitzungsschicht        | session layer         |
| 4 | Transportschicht       | transport layer       |
| 3 | Vermittlungsschicht    | network layer         |
| 2 | Sicherungsschicht      | data link layer       |
| 1 | Bitübertragungsschicht | physical layer        |

Die Instanzen auf Sender und Empfängerseite müssen nach festgelegten Regeln
(dem Protokoll) arbeiten und bilden dann eine logische horizontale Verbindung
über diese Schicht. Die in der gleichen Schicht definierten Netzwerkprotokolle
mit klar definierten Schnittstellen sind untereinander, abhängig von ihren
spezifischen Eigenschaften, austauschbar.

Reale Protokolle bilden mitunter mehrere Schichten des OSI-Modells ab. Zum
Beispiel:

*   Ethernet die Schichten 1 und 2

*   IP, ICMP, IGMP die Schicht 3

*   TCP, UDP die Schicht 4

*   HTTP, SMTP, LDAP die Schichten 5, 6, und 7

Betrachte ich die Kopplungselemente in einem Computernetzwerk, so decken die
heute kaum noch gebräuchlichen Hubs und Repeater die Schicht 1 ab, Bridges und
Switche die Schichten 1 und 2, Router die Schichten 1 bis 3 und schließlich
Protokoll-Gateways die Schichten 1 bis 7.


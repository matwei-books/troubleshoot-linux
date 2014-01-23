
## IPv4-Netzmasken

An dieser Stelle will ich ein paar Worte zu IPv4-Netzmasken verlieren.
Zu einer Zeit, in der IPv6 langsam an Fahrt gewinnt, mutet das vielleicht etwas
anachronistisch an.
Leider wird IPv4 noch fast überall eingesetzt und die Kenntnis der Netzgrenzen
ist bei der Fehlersuche in IPv4-Netzen Grundvoraussetzung.
Es lohnt sich daher für den Netzwerk Troubleshooter nach wie vor, diese zu
memorieren, falls er nicht in der Lage ist, sie in annehmbarer Zeit im Kopf
auszurechnen.

Prinzipiell gibt es zwei Schreibweisen:

*   in Bitnotation: /0 .. /32

*   in Vierer-Notation: 0.0.0.0 .. 255.255.255.255  
    mit Hexadezimalzahlen: 0.0.0.0 ..  FF.FF.FF.FF.

Beide Schreibweisen lassen sich in einander umrechnen. Beide müssen
beherrscht werden, da einige Programme nur entweder die eine oder die andere
verwenden können.

Bei der Umrechnung helfen die ehemaligen Netzwerkklassen mit ihrer
Größenunterteilung in 8-Bit-Grenzen.
In der folgenden Tabelle habe ich die drei Klassen A, B, C um die Notation
für den gesamten IPv4-Adressbereich auf der einen Seite und für einen
einzelnen Host auf der anderen Seite ergänzt:

{width="wide"}
|               | Bits | Vierergruppen   | Anzahl Hosts   |
|---------------|------|-----------------|----------------|
| alle Adressen | /0   | 0.0.0.0         | > 4 Milliarden |
| Class A Size  | /8   | 255.0.0.0       | > 16 Millionen |
| Class B Size  | /16  | 255.255.0.0     | > 65 Tausend   |
| Class C Size  | /24  | 255.255.255.0   | 254            |
| Host          | /32  | 255.255.255.255 | 1              |

Interessanter sind die Subnetz- oder CIDR-Masken. Für diese gehe ich von der
Netzmaske der nächstgrößeren Klasse aus und füge die entsprechende Anzahl
Bits (1..7) hinzu. In Viererschreibweise (VS) ändert sich die Position, die
bei der klassenbasierten Adresse die erste 0 hat.

{width="wide"}
| Bits | VS  | Hex | Netzadressen            |
|------|-----|-----|-------------------------|
| /+1  | 128 | 80  | 0, 128                  |
| /+2  | 192 | C0  | 0, 64, 128, 192         |
| /+3  | 224 | E0  | 0, 32, 64, 96, 128, ... |
| /+4  | 240 | F0  | 0, 16, 32, 48, 64, ...  |
| /+5  | 248 | F8  | 0, 8, 16, 24, 32, ...   |
| /+6  | 252 | FC  | 0, 4, 8, 12, 16, ...    |
| /+7  | 254 | FE  | 0, 2, 4, 6, 8, ...      |

Die Netzadresse gibt an, an welcher Adresse das betreffende Netz beginnt.
Diese Adresse kann nicht für Hosts vergeben werden. In der Tabelle habe ich
nur maximal die ersten fünf aufgeführt. Die weiteren ergeben sich, indem man
die erste oder zweite zu allen Netzadressen der nächsthöheren Zeile addiert.
Die zugehörige Broadcast-Adresse ist die Adresse des nächsten Netzwerkes mit
gleicher Bitmaske, vermindert um 1.

Nehmen wir als Beispiel einen Host mit der IPv4-Adresse  
`10.21.32.43/21`.
Die Netzmaske ist `/16+5`, in Vierernotation `255.255.248.0`.
Die Netzadresse ist `10.21.32.00`, die Broadcastadresse ist `10.21.39.255`.
In diesem Segment stehen 2046 Adressen für Hosts zur Verfügung.

Wer die IPv4-Netzmasken nicht selbst ausrechnen möchte, kann sich
zum Beispiel das Programm *ipcalc* ansehen, das bei einigen Distributionen
mitgeliefert wird.
Dieses kommt mit einem CGI-Wrapper, so dass es auch als
Netzdienst im lokalen Netz eingerichtet werden kann.

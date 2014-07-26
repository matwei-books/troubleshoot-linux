
## Path-MTU {#sec-path-mtu}

Die *Maximum Transmission Unit* (MTU) beschreibt die maximale Größe eines
Datenpakets, die auf einem Netzsegment ohne Fragmentierung gesendet werden
kann.
Dementsprechend ist die Path-MTU die maximale Größe eines Datenpakets, das
durch alle Segmente vom Empfänger zum Sender ohne Fragmentierung übertragen
werden kann.

Um ein Datenpaket, das größer ist als die MTU eines Netzsegmentes, zu
übertragen, muss dieses in kleinere Datenpakete zerlegt (Fragmentierung) und
nach der Übertragung wieder zusammen gefügt werden.
Das hat mehrere Nachteile:

*   Das Zerlegen und Zusammensetzen kostet zusätzlichen Speicherplatz und
    Rechenzeit.
*   Die nutzbare Bandbreite reduziert sich, weil zusätzliche
    Protokollinformationen mit den Fragmenten gesendet werden müssen, um sie am
    Ende zusammensetzen zu können.
*   Firewalls können bei fragmentierten Datenpaketen nicht immer korrekte
    Entscheidungen treffen, müssen die Datenpakete also ebenfalls
    zusammensetzen, was zusätzliche Leistung kostet.
*   Es gibt Angriffe gegen Rechner, die fragmentierte Datenpakete verwenden.

Das sind für mich genug Gründe, warum ich in meinen Netzen möglichst keine
fragmentierten Datenpakete haben will.

RFC 1191 beschreibt die Mechanismen für die automatische Bestimmung der
Path-MTU.

Im Grunde läuft es darauf hinaus, dass der Sender in den IP-Optionen der
gesendeten Datagramme das *Don't fragment* Bit setzt.
Kommt ein Datagramm mit dieser Option an einen Router mit einer kleineren MTU
auf dem weiteren Weg, dann verwirft dieser das Datagramm und sendet an den
Absender eine ICMP-Unreachable-Nachricht mit dem Code `fragmentation needed
and DF set` und der MTU des nächsten Segments.
Der Absender kann die Path-MTU für die betroffene Verbindung anpassen und die
Daten in kleineren Datenpaketen versenden.

Für TCP gibt es außerdem die Möglichkeit, beim Aushandeln der Verbindung die
*Maximum Segment Size* in den Optionen anzugeben.
Diese sollte nicht größer sein als das größte fragmentierte Datagramm, dass
der Empfänger noch zusammensetzen kann.
Fehlt diese Option soll der Sender maximal 576 Byte große Datagramme senden,
was einer MSS von 536 entspricht.
RFC 1191 empfiehlt stattdessen, die MTU des Netzsegmentes zu verwenden und
immer beim Verbindungsaufbau auszuhandeln.
In diesem Fall stört die MSS nicht die automatische Bestimmung der Path-MTU,
so dass der Datenpfad optimal ausgenutzt werden kann.


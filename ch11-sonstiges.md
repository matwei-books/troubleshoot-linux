
## Sonstige Probleme

### Path-MTU

Ein Problem, dass relativ selten auftritt, dann aber bei der Fehlersuche
sehr leicht zunächst in die Irre führen kann, wird durch eine reduzierte
Path-MTU in Verbindung mit einer Störung der automatischen Ermittlung
derselben verursacht.

Dazu muss ich etwas ausholen.

Die *Maximum Transmission Unit* (MTU) beschreibt die maximale Größe eines
Datenpakets, die auf einem Netzsegment ohne Fragmentierung gesendet werden
kann.
Dementsprechend ist die Path-MTU die maximale Größe eines Datenpakets, das
durch alle Segmente vom Empfänger zum Sender ohne Fragmentierung übertragen
werden kann.

Um ein Datenpaket, welches größer als die MTU eines Netzsegmentes ist, zu
übertragen, muss dieses in kleinere Datenpakete zerlegt und wieder zusammen
gefügt werden (Fragmentierung).
Das hat mehrere Nachteile:

*   Das Zerlegen und Zusammensetzen kostet zusätzlichen Speicherplatz und
    Rechenzeit.
*   Durch die zusätzlichen Daten, die mit den Fragmenten gesendet werden
    müssen, um sie wieder zusammensetzen zu können, erhöht sich der Overhead
    für die Übertragung der Nutzdaten. Das heißt, bei gegebener Bandbreite
    des Leitungsweges reduziert sich die nutzbare Bandbreite.
*   Firewalls können bei fragmentierten Datenpaketen mitunter keine korrekte
    Entscheidung treffen, müssen die Datenpakete also ebenfalls
    zusammensetzen, was zusätzliche Leistung kostet.
*   Es gibt verschiedene Angriffe gegen Rechner, die fragmentierte Datenpakete
    verwenden.

Das sind für mich genug Gründe, warum ich in meinen Netzen möglichst keine
fragmentierten Datenpakete haben will.

RFC 1191 beschreibt die Mechanismen für die Bestimmung der Path-MTU.

Im Grunde läuft es darauf hinaus, dass der Sender in den IP-Optionen der
gesendeten Datagrammen das *Don't fragment* Bit setzt.
Kommt ein Datagramm mit dieser Option an einen Router mit einer kleineren MTU
auf dem weiteren Weg, dann verwirft dieser das Datagramm und sendet an den
Absender eine ICMP-Unreachable-Nachricht mit dem Code `fragmentation needed
and DF set` und der MTU des nächsten Segments.
Der Absender kann die MTU für die betroffene Verbindung reduzieren und die
Daten in kleineren Datenpaketen versenden.
Sobald das erste Datagramm am Empfänger angekommen ist, ist automatisch die
maximale MTU für diesen Datenpfad bestimmt.

Für TCP gibt es die Möglichkeit, beim Aushandeln der Verbindung eine Maximum
Segment Size in den Optionen anzugeben.
Diese sollte nicht größer sein als das größte fragmentierte Datagramm, dass
der Empfänger noch zusammensetzen kann.
Fehlt diese Option soll der Sender maximal 576 Byte große Datagramme senden,
was einer MSS von 536 entspricht.
RFC 1191 empfiehlt stattdessen, die MTU des Netzsegmentes zu verwenden und
immer beim Verbindungsaufbau auszuhandeln.
In diesem Fall stört die MSS nicht die automatische Bestimmung der Path-MTU,
so dass der Datenpfad optimal ausgenutzt werden kann.

Das Problem, das oft zunächst falsch interpretiert wird, tritt auf, wenn die
automatische Bestimmung der Path-MTU gestört ist.
Das kann durch unglückliche Firewall-Regeln passieren, durch unpassende NAT
oder durch Probleme beim Routing.

Ich kann dann Plaintext-Protokolle, wie im vorigen Abschnitt beschrieben,
testen und zum Beispiel einen SMTP als völlig in Ordnung identifizieren.
Trotzdem kann ein anderer SMTP-Server diesem keine E-Mail senden, obwohl mein
Test vom selben Rechner aus kein Problem anzeigte.

Bim manuellen Testen des Protokolls entsteht üblicherweise kein großes
Datenpaket, das nicht durch alle Netzsegmente unfragmentiert gesendet werden
kann.
Beim Versenden von E-Mail nutzt der Server die Datenverbindung jedoch so
effizient wie möglich aus.
Und wenn die zu versendende Nachricht größer ist als die Path-MTU, versucht er
mindestens ein zu großes Datagramm zu senden.
Da die ICMP-Unreachable-Nachricht nicht bis zu ihm durchdringt, weiß der
Sender nicht, dass das Datagramm nicht ankommt.
Auch das Wiederholen des Datagramms hilft hier nicht.
Der Empfänger hat alle vorherigen Datagramme bestätigt und nun keine
Veranlassung seinerseits etwas zu unternehmen, so dass die Verbindung zum
Stillstand kommt.
Irgendwann beendet vielleicht einer der Beteiligten die TCP-Sitzung auf Grund
eines Timeouts.

Wenn ich nicht von selbst an dieses mögliche Problem denke, suche ich
womöglich sehr lange an der falschen Stelle.
Ich kann mit `ping` testen, ob die Path-MTU geringer ist, als die MTU des
ersten Segments:

{line-numbers=off,lang="text"}
    $ ping -n -c1 -Mdo -s 1472 172.17.1.2
    PING 172.17.1.2 (172.17.1.2) 1472(1500) bytes of data.
    From 192.168.1.3 icmp_seq=1 Frag needed and DF set (mtu = 1492)

    --- 172.17.1.2 ping statistics ---
    0 packets transmitted, 0 received, +1 errors

Das Beispiel zeigt die Ausgabe, wenn ich versuche über eine PPPoE-Verbindung
ein anderes Netz zu erreichen.
Mein PING-Datagramm ist 1500 Byte groß, es gehen aber nur 1492 Byte über den
nächsten Hop.
Wenn ich es nur 8 Byte kleiner mache, funktioniert es:

{line-numbers=off,lang="text"}
    $ ping -n -c1 -Mdo -s 1464 172.17.1.2
    PING 172.17.1.2 (172.17.1.2) 1464(1492) bytes of data.
    1472 bytes from 172.17.1.2: icmp_req=1 ttl=57 time=84.6 ms

    --- brimir ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 84.692/84.692/84.692/0.000 ms

Bei gestörter Path-MTU-Discovery werde ich die Fehlermeldung beim ersten Test
möglicherweise nicht sehen, sondern einfach nur keine Antwort bekommen.
Dann muss ich dem Datenpfad folgen und sehen, wie weit meine Datagramme
kommen.

Habe ich schließlich ein Problem mit der Path-MTU-Discovery festgestellt, ist
die nächste Frage, wie ich das abstelle.

Die schnellste Lösung ist, die MTU des Senders zu reduzieren.
Damit verringere ich die nutzbare Bandbreite, weil auf Grund der kleineren
Datenpakete das Verhältnis von Nutzdaten zu Protokolldaten ungünstiger wird.
Darum ziehe ich das im Allgemeinen nur als temporäre Lösung in Betracht.

Für TCP habe ich auf den Gateways oft die Möglichkeit, die MSS-Option beim
Verbindungsaufbau zu modifizieren, so dass alle TCP-Verbindungen über den
entsprechenden Weg automatisch mit einer geringeren maximalen Größe der
Datagramme arbeiten.
Das Stichwort, wonach ich in der Dokumentation suche, lautet MSS-Clamping.
Das ist insbesondere dadurch vorteilhaft, weil es nur die TCP-Verbindungen
betrifft, die über den problematischen Abschnitt laufen.
Außerdem muss ich nichts an den Endpunkten der Verbindung einstellen.

Die sauberste Lösung ist, die Ursache für die Störung bei der
Path-MTU-Discovery zu beseitigen.
Das ist manchmal jedoch nicht möglich, so dass ich auf eine der beiden
vorgenannten Lösungen zurückgreifen muss.


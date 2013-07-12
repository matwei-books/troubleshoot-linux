# Netzwerkperfomance {#cha-netz-performance}

Manchmal scheint alles in Ordnung zu sein und trotzdem sind die Kunden nicht
zufrieden. Performance ist ein heikles Thema, weil jeder seine eigene
Vorstellung davon hat, was ausreichende Performance ist.

## Netzwerkbandbreite {#sec-netz-performance-bandbreite}

Die Bandbreite einzelner Netzsegmente bestimme ich normalerweise nicht erst
im Fehlerfall, sondern vorher, am Besten gleich nach Inbetriebnahme eines
Abschnitts. Dann habe ich bei Problemen einen Referenzwert, der mir bei der
Eingrenzung des Problems nützlich sein kann.

### Bestimmung der Bandbreite mit ping

Wie man mit Ping die Bandbreite bestimmen kann, ist sehr gut in
[[Sloan2001](#bib-sloan2001)] Kapitel 4. Path Characteristics beschrieben.

Das geht für beliebige Streckenabschnitte einer Verbindung und zwar wie
folgt:

1.  Mit Ping bestimmt man die RTT zum vorderen und hinteren Ende des
    Netzsegments. Die Differenzen zwischen den beiden Zeiten eliminieren die
    Einflüsse der anderen Netzkomponenten.

2.  Jetzt bestimmt man die RTT zu den beiden Enden mit größeren
    Datenpaketen und bestimmt wieder die Differenz.

3.  Die Differenz zwischen den beiden Zeitdifferenzen aus den ersten
    beiden Schritten ist die Zeit, die für die zusätzlichen Daten benötigt
    wird.

4.  Die Bitrate ist 16 mal der Differenz der Paketgrößen geteilt
    durch die Differenzzeit aus Schritt 3 (die magische Zahl 16 kommt daher,
    dass wir mit 8 Bit pro Byte rechnen und die die Messungen die doppelte
    Zeit, nämlich für Hin- und Rückweg, enthalten, aber nur die einfache
    Bitrate bestimmen wollen)

Wenn ich mehrere Pingpakete pro Einzelmessung sende, dann verwende ich
jeweils die geringste gemessene RTT, da diese vermutlich die geringsten
Störeinflüsse enthält.

## Lasttests {#sec-netz-performance-lasttests}

Die reine Kenntnis von Bandbreite und Latenz von Netzwerken reicht nicht
aus, um das Verhalten unter realen Bedingungen zu Beschreiben. Insbesondere
durch Pufferung von Datenpaketen, die nicht gleich gesendet werden können,
ändert sich die Latenz einer Übertragungsstrecke erheblich. Eine
Möglichkeit, derartige Probleme zu diagnostizieren sind Lasttests.

Zusätzlich zu den Latenzzeiten, die durch die Datenübertragung und das
reine Umkopieren in den Routern und Switches entstehen, gibt es
Verzögerungen, die durch die Pufferung von Datenpaketen verursacht werden.
Diese entstehen dadurch, dass ein Netzwerkgerät auf der Sendeseite die Daten
nicht so schnell los wird, wie sie auf der Empfangsseite ankommen. Das
passiert meist beim Übergang von schnellen auf langsamere Medien, aber auch,
wenn Datenpakete aus mehreren Richtungen ankommen und in die selbe Richtung
abgehen. Tritt dieser Effekt nur kurzzeitig auf, dann wirken die Puffer
positiv, da keines der Datenpaket verloren geht, sondern nur etwas später
ankommt. Kommen jedoch ständig mehr Daten an, als gesendet werden können,
dann werden erst die Puffer gefüllt, bevor Daten verworfen werden. Ohne
aktives Puffermangement hat dann jedes ankommende Datenpaket so viele andere
Datenpakete vor sich, wie in den Puffer passen. Die durch den Puffer
verursachte Latenz beträgt dann Puffergröße geteilt durch Sendebandbreite.
Leider verhindert die durch den Puffer erhöhte Latenzzeit, dass sich das
TCP-Protokoll an die gerade mögliche Bandbreite anpassen kann. Die
wirksamste  Abhilfe ist Adaptive Queue Management, ein Notbehelf kann
Trafficshaping sein, wobei dieses den Nachteil hat, dass man als
Netzadministrator die Sendebandbreite kennen muss um den Traffic manuell auf
die entsprechende Rate zu begrenzen.

Die reine Kenntnis von Bandbreite und Latenz von Netzwerken reicht also nicht
aus, um das Verhalten unter realen Bedingungen zu Beschreiben. Insbesondere
durch Pufferung von Datenpaketen, die nicht gleich gesendet werden können,
ändert sich die Latenz einer Übertragungsstrecke erheblich. Eine
Möglichkeit, derartige Probleme zu diagnostizieren sind Lasttests.

Das heisst, ich erzeuge künstlichen einen starken Datenverkehr und
beobachte, wie sich die anderen Netzparameter verhalten. Das betrifft zum
einen die Latenz und zum anderen die verfügbare Bandbreite.

### Lasttest mit Ping

Mit dem Befehl

    # ping -f rechnername

sendet Ping Datenpakete so schnell es geht zum Zielrechner. Dazu benötige
ich Superuserrechte.

Diesen Aufruf verwende ich, um auf einem Segment Netzwerklast zu erzeugen.
Zusätzlich zur normalen Statistik (min/avg/max/mdev) zeigt Ping am Ende zwei
Werte: IPG und EWMA.

IPG (Inter Packet Gap) ist die Zeit zwischen dem Senden zweier Datenpakete.
Für Ethernet ist die Minimalzeit auf die Zeit festgelegt, in der 96 Bit
übertragen werden. Das sind 9,6 µs für 10 MBit/s Ethernet und 9,6 ns für 10
GBit/s. Diese Zeit wird automatisch vom Ethernetadapter an jedes Datenpaket
angehängt. Das angezeigte IPG kann ich als Maß verwenden, um abzuschätzen,
wie effizient die Kombination Betriebssystem, Netzwerkkarte, Netzwerk Daten
senden kann.

EWMA steht für Exponential Weighted Moving Average. Bei diesem Durchschnitt
werden die letzten  RTT-Zeiten höher gewichtet als ältere. Im Normalfall
sollte dieser gleich dem Mittelwert für RTT sein. Weicht er signifikant ab,
deutet das auf einen Trend hin. Dafür benötigt man aber einen länger
laufenden Ping und da EWMA am Ende ausgegeben wird, wird der Trend erst am
Ende dieser Messung offenbar.

## Notizen

*   Baseline, ein Ausgangspunkt, der gemessen werden kann und als Referenz
    dient.

*   Bufferbloat

*   Netalyzr

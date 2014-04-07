
## Performancemessungen im Netz

Nachdem ich im vorigen Abschnitt auf mögliche Ursachen für Performanceprobleme
im Netz eingegangen bin, will ich nun etwas detaillierter auf die
Möglichkeiten eingehen, Netzparameter zu bestimmen.

Ich bestimme diese Parameter, wenn möglich, vor dem produktiven Einsatz von
Netzwerkverbindungen, als Baseline für spätere Vergleichsmessungen wenn ich
Fehler vermute.

### Bandbreite

Auch hier verweise ich wieder auf [[Sloan2001](#bib-sloan2001)].
Dort ist beschrieben, wie ich nur mit `ping` als Werkzeug die Bandbreite jedes
einzelnen Netzsegmentes zwischen Sender und Empfänger bestimmen kann.
Da ich bei Netzen außerhalb meines Einflussbereiches nicht immer damit rechnen
kann, auf PING eine Antwort zu bekommen, muss ich dann zu anderen Mitteln
greifen.
Wenn ich jedoch das Prinzip verstanden habe, kann ich auch andere Werkzeuge,
wie zum Beispiel `traceroute`, einsetzen und die Laufzeit mit `tcpdump` oder
`wireshark` bestimmen.

Das Verfahren funktioniert folgendermaßen:

1.  Ich bestimme die Adressen der Router auf dem Pfad, den ich untersuchen
    will, zum Beispiel mit `traceroute`.

2.  Ich sende direkt an die Router PING-Pakete mit 100 Byte und 1100 Byte
    Paketgröße und notiere mir die RTT der Antworten.

3.  Für jedes Segment betrachte ich die RTT des Routers davor (1) und
    dahinter (2).

    Für jede Paketgröße bestimme ich die Differenz der Antwortzeiten für den
    vorderen und hinteren Router.
    Damit eliminiere ich den Einfluss des Pfades bis zum vorderen Router.

    Es bleiben zwei Zeiten, für das große und das kleine Datenpaket. Die
    Differenz zwischen diesen Zeiten ist die benötigte Zeit, um 1000 Byte über
    dieses Segment zu transportieren.

    Diese Zeit teile ich durch 2, weil mich nur die einfache Zeit für die
    Übertragung interessiert.
    Die Anzahl der Bytes (1000) multipliziere ich mit 8, da die Bandbreite
    üblicherweise in bps (bits per second) angegeben wird.

    Damit komme ich zu folgender Gleichung:

    {$$}
    BW = 16 \times \frac{P_l - P_s}{(t_{2l} - t_{2s} - t_{1l} + t_{1s})} 
    {/$$}

    Dabei sind {$$}P_l \mbox{ und } P_s{/$$} die Größe der großen (*l*) und
    kleinen (*s*) Datenpakete in Byte.

    {$$}t_{1s}, t_{1l}, t_{2s} \mbox{ und } t_{2l}{/$$} sind die RTT in
    Millisekunden.

    Das Ergebnis BW ist in kbps.

Falls ich mehrere Datenpakete mit der gleichen Größe gesendet habe, verwende
ich für die Berechnung nicht den Durchschnitt sondern die kleinste RTT, weil
diese der wahren, nicht mit anderen Übertragungen geteilten Bandbreite am
nächsten kommt.
Es versteht sich auch von selbst, dass ich mir für die Messung einen Zeitpunkt
heraussuche, zu dem möglichst wenig andere Datenverkehr die Messung
beeinflusst.

Bin ich gezwungen, auf andere Datenpakete auszuweichen, verwende ich `tcpdump`
zur Messung.
Dabei muss ich beachten, dass bei gleichbleibenden Antwortpaketen, zum
Beispiel *ICMP-Unreachable* Nachrichten, die gemessene Zeitdifferenz nicht
mehr halbiert werden muss, da in einer Richtung die Paketgröße konstant
bleibt.

### Latenz

Die Latenz kann ich sehr gut mit `ping` abschätzen, sie entspricht der Hälfte
der angegebenen RTT.

Um den Einfluss möglicher Puffer aufzudecken, kann ich zusätzlich auf
Teilstrecken des Pfades eine Last legen und dabei die Veränderungen der RTT
beobachten.

#### Lasttest mit Ping

Mit dem Befehl

    # ping -f rechnername

sendet Ping Datenpakete so schnell es geht zum Zielrechner.
Dazu benötige ich Superuserrechte.

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

### Durchsatz

Um den Durchsatz zu messen, greife ich auf entsprechende Programme wie `iperf`
zurück.
Diese erlauben mir den Durchsatz eines Pfades mit TCP oder UDP zu bestimmen,
wobei ich die Charakteristika der beiden Protokolle ausnutzen kann.

Dabei kann ich den Durchsatz entweder in jeweils einer Richtung oder
gleichzeitig in beiden Richtungen messen.
Dabei muss ich jedoch immer im Hinterkopf behalten, dass manche Ethernetkarten
beziehungsweise die Treiber dafür nicht die volle mögliche Bandbreite liefern
können.

Habe ich signifikante Unterschiede im Durchsatz bei den verschiedenen
Richtungen, kann das ein Hinweis auf fehlangepasste Schnittstellen
(Half-Duplex, Full-Duplex) sein.
Diesem kann ich mit `mii-tool` oder `ethtool` nachgehen.

### Analyse des Datenverkehrs

Nicht zu unterschätzen für die Problemanalyse sind die Daten, die ich vom
Monitoring erhalten kann.
Natürlich muss ich es vorher aufgesetzt haben und sollte möglichst schon
Vergleichsdaten aus der Vergangenheit zur Verfügung haben.

#### MRTG, Cacti und ähnliche

Damit bekomme ich Informationen, wieviele Daten an den einzelnen
Schnittstellen pro Zeiteinheit übertragen wurden, umgerechnet in eine
durchschnittliche Auslastung.
Damit sehe ich zwar nicht jeden einzelnen Burst, aber eine hohe Ausnutzung der
Schnittstelle über fünf Minuten oder länger kann schon signifikant sein für
die Fehlersuche.

Da die Messwerte meist aller fünf Minuten via SNMP abgefragt werden, belasten
diese das Netzwerk nicht übermäßig.

#### Netflow

Noch aussagekräftiger sind die Daten von Netflow.
Damit kann ich nicht nur Lastspitzen erkennen, sondern auch, welcher Verkehr
die meiste Bandbreite benötigte oder die meisten Datenpakete.

Für Netflow benötige ich Sensoren auf den Routern und eine geeignete
Monitoring-Software, wie zum Beispiel NfSen.
Als Sensor für Linux ist zum Beispiel `fprobe` geeignet.

Natürlich  belasten die Sensoren die Router und die verschickten
Zusammenfassungen erzeugen zusätzlichen Datenverkehr.
Darum setze ich Netflow nur auf strategisch wichtigen Routern ein.


## Performancemessungen im Netz

Nachdem ich im vorigen Abschnitt auf mögliche Ursachen für Performanceprobleme
im Netz eingegangen bin, will ich nun etwas detaillierter darauf eingehen,
wie ich Netzparameter bestimmen kann.

Diese Parameter erfasse ich, wenn möglich, vor dem produktiven Einsatz von
Netzwerkverbindungen, als Baseline für spätere Vergleichsmessungen, wenn ich
Fehler vermute.

### Maximale Datenübertragungsrate {#sec-messung-kanalkapazitaet}

Ich verweise hier wieder auf [[Sloan2001](#bib-sloan2001)].
Dort ist beschrieben, wie ich nur mit `ping` als Werkzeug die
maximale Datenübertragungsrate jedes
einzelnen Netzsegmentes zwischen Sender und Empfänger bestimmen kann.
Da ich bei Netzen außerhalb meines Einflussbereiches nicht immer damit rechnen
kann, auf PING eine Antwort zu bekommen, muss ich gegebenenfalls zu anderen
Mitteln greifen.
Wenn ich jedoch das Prinzip verstanden habe, kann ich auch andere Werkzeuge,
wie zum Beispiel `traceroute`, einsetzen und die Laufzeit mit `tcpdump` oder
`wireshark` bestimmen.

Das Verfahren funktioniert folgendermaßen:

1.  Ich bestimme die Adressen der Router auf dem Pfad, den ich untersuchen
    will, mit `traceroute`.

2.  Ich sende direkt an die Router PING-Pakete mit 100 Byte und 1100 Byte
    Paketgröße und notiere mir die RTT der Antworten.

3.  Für jedes Segment betrachte ich die RTT des Routers davor (1) und
    dahinter (2).

    Für jede Paketgröße bestimme ich die Differenz der Antwortzeiten für den
    vorderen und hinteren Router.
    Damit eliminiere ich den Einfluss des Pfades bis zum vorderen Router.

    Es bleiben zwei Zeiten, für das große und das kleine Datenpaket. Die
    Differenz zwischen diesen beiden Zeiten ist die benötigte Zeit, um 1000 Byte
    über dieses Segment zu transportieren.

    Diese Zeit teile ich durch 2, weil mich nur die einfache Zeit für die
    Übertragung interessiert.
    Die Anzahl der Bytes (1000) multipliziere ich mit 8, da die Datenübertragungsrate
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
diese der wahren, nicht mit anderen Übertragungen geteilten Datenübertragungsrate am
nächsten kommt.
Es versteht sich auch von selbst, dass ich mir für die Messung einen Zeitpunkt
heraussuche, zu dem möglichst wenig anderer Datenverkehr die Messung
beeinflusst.

Bin ich gezwungen, auf andere Datenpakete auszuweichen, kann ich auch `tcpdump`
zur Messung der RTT verwenden.
Dabei muss ich beachten, dass ich bei konstanter Größe der Antwortpakete, zum
Beispiel bei  *ICMP-Unreachable* Nachrichten, die gemessene Zeitdifferenz nicht
halbieren darf.

Da `traceroute` ebenfalls die RTT der einzelnen Hops ausgibt und einige
Varianten von Traceroute verschieden große Datagramme senden können, kann ich
mitunter auch dieses direkt für die Messungen einsetzen.
In diesem Fall ist der konstante Faktor in der Gleichung statt 16 nur 8, da
die ICMP-Unreachable-Nachrichten eine konstante Größe haben.

### Latenz

Die Latenz kann ich sehr gut mit `ping` abschätzen, sie entspricht der Hälfte
der angegebenen RTT.

Um den Einfluss möglicher Puffer aufzudecken, kann ich zusätzlich auf
Teilstrecken des Pfades eine Last legen und dabei die Veränderungen der RTT
beobachten.

#### Lasttest mit Ping

Mit dem Befehl

{line-numbers=off,lang="text"}
    # ping -f rechnername

sendet Ping Datenpakete, so schnell es geht, zum Zielrechner.
Dazu benötige ich Superuserrechte.
Diesen Aufruf kann ich mit der Option `-l $preload` kombinieren, so dass Ping
so viele Datenpakete sendet, ohne auf Antwort zu warten.
Damit kann ich auf einem Segment Netzwerklast erzeugen.
Zusätzlich zur normalen Statistik (min/avg/max/mdev) zeigt Ping dann am Ende
zwei Werte: IPG und EWMA.

IPG (Inter Packet Gap) ist die Zeit zwischen dem Senden zweier Datenpakete.
Für Ethernet ist die Minimalzeit auf die Zeit festgelegt, in der 96 Bit
übertragen werden. Das sind 9,6 µs für 10 MBit/s Ethernet und 9,6 ns für 10
GBit/s. Diese Zeit wird automatisch vom Ethernetadapter an jedes Datenpaket
angehängt. Das angezeigte IPG kann ich als Maß verwenden, um abzuschätzen,
wie effizient die Kombination Betriebssystem, Netzwerkkarte, Netzwerk Daten
senden kann.

EWMA steht für Exponential Weighted Moving Average.
Bei diesem Durchschnitt werden die letzten RTT höher gewichtet als ältere.
Im Normalfall sollte dieser gleich dem Mittelwert für RTT sein.
Weicht er signifikant ab, deutet das auf einen Trend hin.
Dafür benötige ich aber einen länger laufenden Ping und da EWMA am Ende
ausgegeben wird, wird der Trend erst am Ende dieser Messung offenbar.

### Durchsatz

Um den Durchsatz zu messen, greife ich auf entsprechende Programme wie `iperf`
zurück.
Diese erlauben mir den Durchsatz eines Pfades mit TCP oder UDP zu bestimmen,
wobei ich die Charakteristika der beiden Protokolle ausnutzen kann.

Dabei kann ich den Durchsatz entweder in jeweils einer Richtung oder
gleichzeitig in beiden Richtungen messen.
Ich muss jedoch immer im Hinterkopf behalten, dass manche Ethernetkarten
beziehungsweise die Treiber dafür nicht die volle mögliche Datenübertragungsrate liefern
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

Habe ich keine Monitoringdaten oder helfen diese mir nicht weiter bei der
Analyse, dann habe ich als letzte Möglichkeit immer noch, den Datenverkehr an
verschiedenen Stellen im Netzwerk mit `tcpdump`, `wireshark` oder ähnlichen
Werkzeugen mitzuschneiden und anschließend die Mitschnitte zu analysieren.

#### MRTG, Cacti und ähnliche

Damit bekomme ich Informationen, wieviele Daten an den einzelnen
Schnittstellen pro Zeiteinheit übertragen wurden, umgerechnet in eine
durchschnittliche Auslastung.
Ich sehe zwar nicht jeden einzelnen Burst, aber eine hohe Ausnutzung der
Schnittstelle über fünf Minuten oder länger kann schon signifikant sein für
die Fehlersuche.

Da die Messwerte meist aller fünf Minuten via SNMP abgefragt werden, belasten
diese das Netzwerk nicht übermäßig.

#### Netflow

Noch aussagekräftiger sind die Daten von Netflow.
Damit kann ich nicht nur Lastspitzen erkennen, sondern auch, welcher Verkehr
die meiste Datenübertragungsrate benötigte oder die meisten Datenpakete.

Für Netflow benötige ich Sensoren auf den Routern und eine geeignete
Monitoring-Software, wie zum Beispiel NfSen.
Als Sensor für Linux eignet sich zum Beispiel `fprobe`.

Natürlich  belasten die Sensoren die Router und die verschickten
Zusammenfassungen erzeugen zusätzlichen Datenverkehr.
Darum setze ich Netflow nur auf strategisch wichtigen Routern ein.

#### Analyse von Paketmitschnitten

Wenn ich zu einem Performanceproblem keine Erklärung finde, greife ich zum
letzten Mittel und schneide die einzelnen Datagramme der betreffenden
Verbindung mit, wenn möglich an verschiedenen Stellen im Netzwerk.
Die anschließende Analyse der Mitschnitte ist ziemlich aufwendig und benötigt
einiges an Zeit.

TCP-Übertragungen werden gesteuert durch die Parameter, die der Empfänger in
den Bestätigungsdatagrammen (Ack-Paketen) macht, durch das Timing der
Ack-Pakete und durch Paketverluste.
Letztendlich ist es aber der TCP-Stack des Senders, der entscheidet, wann er
ein Datenpaket sendet und welches, das heißt, ob er das nächste ungesendete
schickt oder ein bereits gesendetes wiederholt.

Generell interessieren mich bei der Auswertung von TCP-Verbindungsmitschnitten

*   die Sequenznummer,
*   die Acknowledgenummer,
*   das Receive-Window,
*   die Anzahl der gesendeten Oktetts (die Länge des Pakets),
*   die Richtung und
*   der Zeitpunkt, zu dem das Datagramm aufgezeichnet wurde.

Diese sechs Angaben lassen sich gut in einem Sequenz-Zeit-Diagramm
visualisieren, was die Auswertung sehr beschleunigt.
Tim Shepard geht in seiner Master Thesis, [Shepard1991](#bib-shepard1991),
ausführlich darauf ein.

Wichtig bei der Auswertung eines Mitschnitts als Sequenz-Zeit-Diagramm
ist, das ich schnell an interessante Stellen heran zoomen und diese von nahem
betrachten kann.
Das Programm `xplot` eignet sich sehr gut für diese Aufgabe, mit `tcptrace`
kann ich den Paketmitschnitt dafür aufbereiten.

Wenn ich eine TCP-Verbindung anhand eines Mitschnitts analysieren will, muss
ich zwischen verschiedenen Szenarien unterscheiden und die dadurch gesetzten
Rahmenbedingungen berücksichtigen.

1.  Sender und Empfänger sind im gleichen LAN-Segment, die Übertragungszeiten
    liegen unter 1 ms. In diesem Fall ist es fast egal, ob der Mitschnitt beim
    Sender, Empfänger oder einem dritten Rechner im gleichen Segment
    aufgezeichnet wird.

    Hier brauche ich mir im Allgemeinen keine Gedanken über Paketverluste
    machen.
    Falls ich doch den Verdacht hege, kann ich das an den Zählern der
    Interfaces der beteiligten Rechner oder des Switches sehen, falls
    letzterer diese auslesen läßt.

2.  Sender und Empfänger befinden sich in verschiedenen Netzsegmenten, die
    Übertragungszeiten liegen deutlich über 1 ms, oft über 10 ms und manchmal
    über 100 ms.
    Ich muss mit Paketverlusten und variablen Paketlaufzeiten rechnen.

    Hier muss ich bei der Analyse eines Mitschnitts die Position des
    Proberechners berücksichtigen, der den Mitschnitt anfertigt.

    Ist der Proberechner im selben LAN-Segment wie der Sender, dann "sehe"
    ich die Daten genau wie der sendende TCP-Stack, kann dessen Entscheidungen
    nachvollziehen und an Hand der Ack-Pakete und deren Timing auf den Zustand
    des Netzes und des Empfängers schließen.

    Ist der Proberechner im selben LAN-Segment wie der Empfänger, dann "sehe"
    ich die Verbindung genau wie deer Empfänger und kann dessen Entscheidungen
    nachvollziehen.
    Hier schließe ich aus der Reihenfolge und dem Timing der Datenpakete auf
    den Zustand des Netzes und des Senders.

    Ist der Proberechner irgendwo zwischen dem LAN-Segment des Senders und dem
    des Empfängers positioniert, so muss ich bei der Interpretation der Daten-
    und Ack-Pakete berücksichtigen, dass bei beiden variable Laufzeiten und
    Paketverluste auftreten können.
    Dann konzentriere ich mich in erste Linie um fehlende und doppelt
    gesendete Pakete und messe der Reihenfolge und dem Timing geringeres
    Gewicht bei.

    Habe ich nur einen Mitschnitt zur Verfügung, dann konzentriere ich mich
    auf das oben gesagte.
    Stehen mir Mitschnitte ein und derselben Verbindung von verschiedenen
    Stellen des Netzes zur Verfügung, dann kann ich durch Vergleich der
    einzelnen Mitschnitte bessere Aussagen zum Zustand des Übertragungskanals
    machen.

X> #### Mache dich mit der Analyse von Verbindungsmitschnitten vertraut
X> 
X> Nimm dir dafür zwei Rechner in verschiedenen Netzsegmenten.
X> 
X> *   Starte `iperf -s` auf einem der Rechner.
X> *   Protokolliere den Datenverkehr auf beiden Rechnern mit `tcpdump`.
X> *   Starte eine Clientverbindung mit `iperf` zu dem ersten Rechner
X> *   Bereite die Mitschnitte jeweils mit `tcptrace -G` auf.
X> *   Untersuche die erzeugten Diagramme mit `xplot`.


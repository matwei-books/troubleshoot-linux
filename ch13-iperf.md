
## Iperf, nttcp, nuttcp {#sec-netz-werkzeuge-iperf}

In diesem Abschnitt stelle ich drei Werkzeuge vor, mit denen ich auf
einfache Weise den Netzwerkdurchsatz für TCP und UDP messen kann.
Welches der drei ich einsetze, hängt meist von der Verfügbarkeit auf den
beteiligten Rechnern ab.

Bei allen drei Werkzeugen benötige ich Zugang zu den Rechnern zwischen denen
ich messen will, zwei Programme kann ich mittels `inetd` automatisch starten
lassen, so dass ich mich zum Zeitpunkt der Messung nicht anmelden muss.
Rootrechte brauche ich für die Messung nicht.

Für genauere Informationen zu den einzelnen Programmen sind, wie immer, die
Handbuchseiten da.

### iperf

Bei diesem Programm, dass ich als Client und Server einsetzen kann, erzeugt
der Client den Traffic aus dem Hauptspeicher heraus während der Server die
angekommenen Daten verwirft, so dass nur der Durchsatz im Netz und das Handling
der Pakete im Hauptspeicher gemessen wird.

Ich kann einseitige Messungen machen und anschließend die Client- und
Serverrolle tauschen oder zwei Verbindungen in den verschiedenen Richtungen
gleichzeitig messen.
Die verschiedenen Messergebnisse lassen Rückschlüsse auf den Zustand des
Netzes zu.

Normalerweise dauert eine Messung 10 Sekunden, während derer das Programm
versucht, so viele Daten wie möglich zu versenden und an deren Ende es das
Ergebnis ausgibt.
Alternativ kann ich die Datenmenge vorgeben, so dass die Dauer vom Durchsatz
abhängt.
Außerdem ist es möglich, die Zeitdauer zu verändern und periodische Berichte
ausgeben zu lassen anstelle eines Berichts am Ende der Übertragung.

Bei UDP kann ich die Datenrate vorgeben und damit das Verhalten des
Netzes bei unterschiedlich starker Auslastung untersuchen.
Dazu kann ich mir beispielsweise mit Ping die RTT anzeigen lassen und dann
das Netz verschieden stark auslasten.
Mit TCP kann ich die Datenrate nicht vorgeben, da diese durch die
Flusssteuerung automatisch angepasst wird.

### nttcp

Das Programm nttcp, das auf dem älteren Programm ttcp basiert, kann die
Transferrate für TCP, UDP und UDP-Multicast messen.

Da es die Daten ebenfalls aus Puffern im Hauptspeicher über das Netzwerk sendet,
fällt am Rechner nur die Zeit zum Messen und die Zeit im Netzwerkcode des
Kernels in's Gewicht.

Zusätzlich zu den Transferdaten gibt das Programm auch die benötigte
CPU-Zeit aus.

Ich kann das Programm via `inetd` auf einem Rechner starten lassen, so
dass ich mich dort zur Messung nicht anmelden muss.

### nuttcp

Dieses Programm, dass auf `nttcp` basiert, misst ebenfalls den Durchsatz für
TCP, UDP und UDP-Multicast.

Es kann etwa die gleichen Daten wie `nttcp` anzeigen und außerdem die Verluste
bei UDP.

Wie bei `nttcp` gibt es einen Sender- und einen Empfängermodus.
Zusätzlich gibt es einen Servermodus, in dem es sowohl senden als auch
empfangen kann.
Dieser ist insbesondere beim Aufruf via `inetd` nützlich.
Die Ergebnisse werden beim Client angezeigt.

Eine Besonderheit von `nuttcp` ist, dass es außer dem üblichen
memory-to-memory-Transfer auch disk-to-memory, memory-to-disk und
disk-to-disk messen kann.
Damit ist es möglich Szenarien zu messen, die realistischen Einsatzgebieten
näher kommen.


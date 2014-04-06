
## iperf, nttcp, nuttcp {#sec-netz-werkzeuge-iperf}

In diesem Abschnitt stelle ich drei Werkzeuge kurz vor, mit denen auf
einfache Weise der Netzwerkdurchsatz für TCP und UDP gemessen werden kann.

Welches der drei ich zum Einsatz bringe, hängt im Wesentlichen von deer
Verfügbarkeit auf den beteiligten Rechnern ab und, bei mehreren, womit ich
die meisten Erfahrungen habe, da ich dann die Ergebnisse schneller
interpretieren kann.

Bei allen drei Werkzeugen brauche ich Zugang zu zwei Rechnern zwischen denen
ich messen will. Rootrechte sind nicht erforderlich.

Für genauere Informationen zu den einzelnen Programmen sind wie immer die
Handbuchseiten da.

### iperf

Bei diesem Programm, dass ich als Client und Server einsetzen kann, erzeugt
der Client den Traffic aus dem Hauptspeicher heraus und der Server verwirft
die angekommenen Daten, so dass nur der Durchsatz im Netz und das Handling
der Pakete im Hauptspeicher gemessen wird.

Ich kann einseitige Messungen machen und anschließend die Client- und
Serverrolle tauschen odeer zwei Verbindungen in den verschiedenen Richtungen
gleichzeitig messen lassen. Die verschiedenen Messergebnisse lassen
Rückschlüsse auf den Zustand des Netzes zu.

Normalerweise dauert eine Messung 10 Sekunden, während derer das Programm
versucht, so viele Daten wie möglich zu versenden und an deren Ende es das
Ergebnis ausgibt. Alternativ ist es möglich, die Datenmenge vorzugeben, so
dass die Dauer vom Durchsatz abhängt. Außerdem ist es möglich, die Zeitdauer
zu verändern und periodische Berichte ausgeben zu lassen anstelle eines
Berichts am Ende der Übertragung.

Bei UDP ist es möglich die Datenrate vorzugeben und damit das Verhalten des
Netzes bei unterschiedlich starker Auslastung zu untersuchen. Dazu kann man
beispielsweise sich mit Ping die RTT anzeigen lassen und dann das Netz
verschieden stark auslasten.

### nttcp

Das Programm nttcp, das auf dem älteren Programm ttcp basiert, kann die
Transferrate für TCP, UDP und UDP-Multicast messen.

Da es die Daten aus Puffern im Hauptspeicher über das Netzwerk sendet, fällt
am Rechner nur die Zeit zum Messen und die Zeit im Netzwerkcode im Kernel
in's Gewicht.

Zusätzlich zu den Transferdaten gibt das Programm auch die benötigte
CPU-Zeit aus.

Das Programm kann via inetd auf einem Rechner verfügbar gemacht werden, so
dass man sich dort dann nicht anmelden muss.

### nuttcp

Dieses Programm, dass auf nttcp basiert, misst ebenfalls den Durchsatz für
TCP und UDP und UDP-Multicast.

Es kann etwa die gleichen Daten wie nttcp anzeigen und außerdem die Verluste
bei UDP.

Wie bei nttcp gibt es einen Sender- und einen Empfängermodus. Zusätzlich
gibt es einen Servermodus, in dem es sowohl senden als auch empfangen kann.
Dieser ist insbesondere beim Aufruf via inetd nützlich. Die Ergebnisse
werden beim Client angezeigt.

Eine Besonderheit von nuttcp ist, dass es außer dem üblichen
memory-to-memory-Transfer auch disk-to-memory, memory-to-disk und
disk-to-disk messen kann. Damit ist es möglich Szenarien zu messen, die
realistischen Einsatzgebieten näher kommen.


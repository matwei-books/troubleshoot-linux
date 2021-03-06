
## traceroute {#sec-netz-werkzeuge-traceroute}

Mit `traceroute` untersuche ich Netzwerkpfade.
Außerdem kann ich damit die maximale Datenübertragungsrate der Netzsegmente
bestimmen, wie in [Kapitel 12](#sec-messung-kanalkapazitaet) beschrieben.

Bei Problemen mit der Erreichbarkeit eines Rechners oder Netzwerkes kann ich
es dazu verwenden, das letzte erreichbare Netzsegment zu bestimmen um
meine nächsten Schritte auf dieses zu fokussieren.
Manchmal kann es bereits einen Hinweis auf die Art des Problems geben.
Zum Beispiel deuten in der Ausgabe mehrfach auftretende IP-Adressen auf eine
Schleife im Routing hin.

Wenn aufgerufen, sendet `traceroute` Datenpakete zum Zielrechner, deren
IP-time-to-live-Feld (TTL) es zunächst auf 0 setzt und
dann sukzessive erhöht, bis sie den Zielhost erreichen.
Erhält ein Host oder Router ein Datenpaket mit einer TTL von 0,
verwirft er das Datenpaket und schickt an den Absender eine ICMP-Nachricht,
dass die TTL abgelaufen war.
Diese ICMP-Nachricht enthält die ersten Bytes des verworfenen Datenpaketes,
um dem Empfänger die Zuordnung zu erleichtern.

In der ursprünglichen Variante sendet `traceroute` UDP-Pakete ab einer
bestimmten Portnummer und erhöht beim Senden nicht nur die TTL, sondern
gleichzeitig auch die Portnummer.
Das erleichtert, die zurückkehrenden ICMP-Nachrichten über den Port den
richtigen TTL zuzuordnen.
Damit ist es möglich mehrere Datenpakete mit verschiedenen TTL und Ports
quasi-parallel zu versenden und die Messzeit zu verkürzen.

Wenn eine UDP-Nachricht am Zielhost angekommen ist, sendet dieser keine
ICMP-ttl-exceeded-Nachricht, sondern stattdessen ICMP-port-unreachable, wenn
an dem betreffenden Port kein Prozess lauscht.
Darum ist es wichtig, für `traceroute` via UDP einen Bereich zu verwenden,
in dem auf dem Zielhost kein UDP-Port in Verwendung ist.
Zwar kann der Zielhost auch an der IP-Adresse erkannt werden, aber gerade bei
multihomed Hosts oder Routern kann das Datenpaket an einem anderen Interface
ankommen und damit die ICMP-Antwort eine andere Absenderadresse haben.

Da Firewalleinstellungen in Netzwerken immer restriktiver werden, gibt es
einige Varianten von `traceroute`, die auch andere Protokolle verwenden und
mit einem Port auf dem Zielrechner auskommen. So ist es möglich, `traceroute`
mit ICMP-echo-Paketen (Ping), TCP-Paketen (zum Beispiel Port 25 oder 80)
oder mit nur einem UDP-Port (zum Beispiel 53 oder 123) zu verwenden, wenn
die Firewall für eines dieser Protokolle freigegeben ist.

Zusätzlich zur IP-Adresse der Hops auf dem Weg zum Zielrechner zeigt
`traceroute` oft noch die RTT zwischen gesendetem Datenpaket und ICMP-Antwort
an, aus der ich Rückschlüsse auf Art und Zustand des betreffenden
Netzsegmentes ziehen kann.

Auch bei `traceroute`, wie bei allen Werkzeugen, muss ich bei der
Interpretation der Ergebnisse einige Sachen berücksichtigen.

So zeigt zum Beispiel die Reihenfolge der Hops nur, wie die Daten in einer
Richtung zum Zeitpunkt der Messung gelaufen sind. Bei Änderungen im Routing
kann sich der Weg bereits während der Messung ändern. Und der Rückweg kann
ganz anders aussehen, wenn das Routing asymmetrisch ist.

Einige IP-Stacks senden ICMP-unreachable-Nachrichten mit einer TTL, die
gleich der ist, mit der das Datenpaket ankam.
Diese erscheinen dann als Zielhost bei symmetrischem Routing erst bei der
doppelten TTL, also viel weiter weg als sie in Wirklichkeit sind.
Die Hops davor sind dann alle mit `*` markiert.

Wenn auf dem Weg der Daten zum Zielhost Adressen umgesetzt werden (NAT),
dann gehen die ICMP-Nachrichten nach der NAT an die umgesetzte Adresse und
erreichen vielleicht nicht den Rechner, auf dem ich `traceroute`
gestartet habe.

Schließlich ist es möglich, dass eine sehr restriktive Firewall die
Traceroute-Pakete einfach stillschweigend verwirft. In diesem Fall kann es
sinnvoll sein, `traceroute` mit anderen Protokollen zu wiederholen und die
Ergebnisse zu vergleichen.

Abgesehen davon ist es möglich, mit `traceroute` eine
relativ genaue Karte der erreichbaren Netze zu erstellen.

Da es unterschiedliche Implementierungen von `traceroute` gibt, deren
Kommandozeilenoptionen zum Teil erheblich voneinander abweichen, verweise
ich auf die Dokumentation des installierten Programmes.


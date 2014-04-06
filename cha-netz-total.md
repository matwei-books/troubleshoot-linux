# Totalausfall des Netzwerks {#cha-netz-totalausfall}

Habe ich an einem Rechner überhaupt keine Netzverbindung, oder kann ich ein
ganzes Netzsegment nicht erreichen, spreche ich von einem Totalausfall.

## Ein Rechner hat überhaupt keine Netzverbindung {#sec-gar-kein-netz}

Manchmal kommt es vor, dass ein Rechner überhaupt keine Netzwerkverbindung
hat. Dann bleibt nichts übrig, als dem Problem methodisch auf den Grund zu
gehen. Dazu verwende ich den folgenden Entscheidungsbaum, um das Problem in
Teilprobleme zu zerlegen:

![Entscheidungsbaum Totalausfall Netz](images/eb-netz-totalausfall-rechner.png)

Die allererste Frage geht dabei nach der physischen Netzverbindung, im
OSI-Modell auch Bitübertragungsschicht genannt. Bei Hardware-Rechnern mit
einigermaßen neuer Netzwerkkarte helfen mir die mii-tools beziehungsweise
eth-tools, die Auskunft über die Verbindungsparameter zum Switch geben
können. Habe ich es mit einer virtuellen Maschine zu tun, dann muss ich am
Hostsystem die Netzwerkeinstellungen für diese VM kontrollieren.

Auch das Programm ifconfig zeigt an, ob das betreffende Interface eine
physikalische Verbindung hat (`RUNNING`). Noch deutlicher zeigt  es
`ip link show` beziehungsweise `ip addr show` (`LOWER_UP`
oder `NO-CARRIER`).

Habe ich diese Programme nicht zur Verfügung, kann ich mich vielleicht mit
`netstat -i` behelfen. Dieser Befehl zeigt eine Statistik der
gesendeten und empfangenen Pakete an. Da in jedem Netzwerk ein gewisser
Anteil an Broadcastpaketen unterwegs ist, sollte sich die Anzahl der
empfangenen Datenpakete erhöhen, wenn ich den Befehl im Abstand von einigen
Sekunden aufrufe. Um sicher zu gehen, kann ich auf einem anderen Rechner im
gleichen Netzsegment zum Beispiel mit ping Broadcastpakete erzeugen.

Wenn tcpdump installiert ist, kann ich auch mit
`tcpdump -n -i <schnittstelle>` auf Traffic warten. Wenn ich damit
Traffic sehe, beende ich das Programm nicht gleich, sondern warte, bis ich
an Hand der Datenpakete entscheiden kann, ob die Schnittstelle im richtigen
Segment angeschlossen ist.

Kann ich keinen Traffic nachweisen, muss ich mir die Verkabelung ansehen,
probeweise die Kabel tauschen, den Rechner an einen anderen Switch
anschließen und/oder in ein anderes Netzsegment. Bei virtuellen Maschinen
schaue ich auf dem Host nach, ob andere VM ähnliche Probleme haben, ob
vielleicht ein falscher Netzwerkanschluß zugewiesen wurde oder kontrolliere
die entsprechenden virtuellen Interfaces auf dem Host.

Ein kurzer Test mit `iptables -L` und `ebtables -L` sagt mir, ob
vielleicht Paketfilterregeln die Verbindung unterdrücken.

Erst wenn die Bitübertragungsschicht funktioniert, hat es überhaupt Sinn,
sich dem nächsten Problem, der IP-Konfiguration zuzuwenden. Diese muss zum
angeschlossenen Netzsegment passen. Eventuell ist es besser, für die Dauer
der Fehlersuche, alle Regeln zu entfernen und die Policies auf `ACCEPT`
zu stellen.

Habe ich vorher die Funktionalität der Schnittstelle mit tcpdump
kontrolliert, dann habe ich eventuell schon genügend Pakete gesehen, die mir
zeigen, ob die Schnittstelle im richtigen Segment angeschlossen ist.
Ansonsten kann ich das jetzt nachholen.

Habe ich tcpdump nicht an Board, weiß aber, dass DHCP im Netzwerk zur
Verfügung steht, kann ich versuchen darüber eine IP-Adresse zu bekommen.
Dazu stelle ich temporär die Schnittstellenkonfiguration um. Falls ich es
noch nicht getan habe, deaktiviere ich jetzt alle Paketfilter.

A> ## Konfiguration der Netzwerkschnittstelle
A> Bei Debian: /etc/network/interfaces
A>
A> Bei Redhat: /etc/sysconfig/network-scripts/\*

Kann ich DHCP nicht nutzen, so könnte ich noch versuchen mit Zero
Configuration Networking zu anderen Rechnern in meinem Segment zu bekommen.
Das hängt davon ab, wie das betreffende Netzwerk administriert ist.

Habe ich nicht die Möglichkeit für Tests mit DHCP/Zero Configuration
Networking, kann ich versuchen mit Ping bekannte und aktive Stationen in
meinem Netzsegment zu erreichen. Antworten die Stationen nicht, aber ihre
IP-Adressen tauchen korrekt im ARP-Cache auf (Test mit `arp -an`), dann
liegt das Problem eher an zu restriktiven Paketfiltereinstellungen der
anderen Rechner und ich würde diese dort testweise lockern beziehungsweise
auf den anderen Rechnern mit tcpdump oder Wireshark nachschauen, ob ich
Datenpakete des problematischen Rechners sehen kann. Bei VMs kann ich mit
tcpdump am zugehörigen virtuellen Interface des Hosts nachschauen.

A> ## Sperren von ICMP durch Paketfilter
A> Verweis auf übermäßiges Beschränken von ICMP-Verkehr und die Auswirkungen
A> auf den Netzverkehr.

Habe ich mich davon überzeugt, dass der Rechner im richtigen Netzsegment
angeschlossen ist und Stationen in diesem erreichen kann, muss ich mich nur
noch vergewissern, dass er Rechner in anderen Netzen erreichen kann.

Bei der Überprüfung der Schnittstellenkonfiguration, habe ich mich gleich mit
vergewissert, dass der Rechner das richtige Gateway kennt. Ich überzeuge mich
davon, dass die konfigurierte Konfiguration auch aktiv ist. Insbesondere
überprüfe ich:

*   Stimmen IP-Adresse und Netzmaske? (`ip addr show`)

*   Stimmen Gateway und Routen? (`ip route show`)

*   Kann ich das Gateway erreichen? (`ping $gateway`)

Anschließend versuche ich mit ping einen Rechner in einem anderen
Netzsegment zu erreichen, der zum Beispiel von anderen Stationen
aus diesem Segment erreicht werden kann. Kann ich trotz korrekter
IP-Konfiguration und deaktiviertem Paketfilter auf dem Problemrechner keine
Rechner in anderen Segmenten erreichen, muss ich auf dem Gateway nachsehen, ob
die Datenpakete des Problemrechners dort vorbeikommen. Sehe ich diese am
Gateway, kann ich den Problemrechner bei der Fehlersuche hinter mir lassen,
vielleicht noch einen Dauerping einschalten und muss mich bei der Problemsuche
dem Netz zuwenden.

## Ein oder mehrere Netzsegmente sind nicht erreichbar {#sec-ausfall-netzsegment}

Beim Ausfall eines oder mehrerer Netzsegmente unterscheide ich zunächst, ob
ich mich in einem der betroffenden Segmente befinde, oder nicht.

Bin ich direkt in dem betroffenen Netzsegment - zum Beispiel, wenn der
Ausfall mir von außerhalb gemeldet wird - untersuche ich zunächst, ob ich
innerhalb des Netzsegmentes, vor allem zum Gateway Verbindung habe.
Dabei kann ich gegebenenfalls auf das Vorgehen aus dem
[Abschnitt über Netzwerktotalausfall](#sec-gar-kein-netz) zurückgreifen.
Anschließend versuche ich Kontakt zu dem Netzsegment zu bekommen, aus dem
die Meldung kam. Bekomme ich keinen Kontakt, vermute ich ein Routingproblem.

Bin ich außerhalb der betroffenen Netzsegmente, schaue ich als erstes, ob
die Routen dorthin in Ordnung sind. Dabei kann mir das Programm traceroute
helfen. Genauere Auskunft bekomme ich auf den Gateways oder anderen
Rechnern, die an den Routingprotokollen teilnehmen. Fehlen die Routen, oder
weisen sie in die falsche Richtung, muss ich das Routingproblem untersuchen.
Sind die Routen in Ordnung, aber ich bekomme keine Verbindung, versuche ich
vom Gateway des betreffenden Netzsegmentes eine Verbindung zu den Rechnern
zu bekommen. Ist das möglich, dann handelt es sich möglicherweise um ein
Konfigurationsproblem der betreffenden Rechner - dieses kann auch durch
fehlerhafte Angaben vom DHCP-Server kommen.

### Routingprobleme {#sec-routingprobleme}

### Rückroute fehlt {#sec-rueckroute-fehlt}

*   Problem: Routen scheinen zu stimmen, keine Antwortpakete

*   Analyse: traceroute, analyse des letzten Hops und desjenigen danach

*   Ursache: Rückroute fehlt

## Notizen

*   Entscheidungsbaum, nicht erreichbares Netzsegment!

*   Routingprotokolle

*   OSPF: BDR hatte falschen Neighbor (openbsd, GeNUScreen)

*   Routersoftware quagga

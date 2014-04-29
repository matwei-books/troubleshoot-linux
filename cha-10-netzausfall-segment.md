
## Totalausfall Netzsegment

Neben dem totalen Ausfall der Anbindung eines Rechners an das Netz betrachte
ich die Nichterreichbarkeit eines oder mehrerer Netzsegmente als Totalausfall.
Während ich bei ersterem auf die Kenntnis der Hardware und der unteren
[OSI-Schichten](#sec-osi-modell) setze, um den Fehler einzugrenzen,
benötige ich hier detaillierte Kenntnisse der Netzwerktopologie.

Mein erster Blick gilt den Routen.
Mit `netstat -rn`, `ip route show` oder `route -n` kann ich mir diese
anzeigen lassen.
Da in Netzen mit sehr vielen Routen die Ausgabe sehr
unübersichtlich ist und die Routen nach anderen Kriterien sortiert sind
als nach der schnellen Auffindbarkeit eines Netzes, lautet die komplette
Befehlszeile bei mir meist:

{line-numbers=off,lang="text"}
    $ netstat -rn | sort | less

Finde ich die Route zum ausgefallenen Netzsegment, überprüfe ich als
nächstes mit `traceroute`, wie weit ich auf dem Weg dorthin komme.

Fehlt die Route, schaue ich in die Topologiedaten und suche nach dem
letzten erreichbaren Netzsegment vor dem ausgefallenen.
Dann muss ich mich, von diesem Segment aus, Schritt für Schritt vorarbeiten.
Dazu melde ich mich auf den Gateways an und schaue, ob das jeweils
nächste Gateway auf dem Weg erreichbar ist.

Neben den Netzwerk-Schnittstellen kontrolliere ich auf den Gateways auch
die Routen.
Und zwar in beide Richtungen, zum ausgefallenen Netzsegment und zurück zu
dem Segment, von dem aus ich den Fehler suche.
Mitunter kommen meine Datenpakete im ausgefallenen Netzsegment an, aber die
Antwort nicht, da die Rückroute fehlt.
In diesem Fall kann ich mich auch nicht direkt am Gateway mit der
fehlenden Rückroute anmelden.
Die Anmeldung von Gateway zu Gateway funktioniert aber oft noch, so dass ich
darüber die Konfiguration und die Routen kontrollieren kann.

Da bei ausgefallenem Routingprotokoll oft noch die Anmeldung von einem
Gateway zum nächsten möglich ist, ist es sinnvoll, wenn ich auf den
Gateways immer auch das Client-Programm, `ssh` oder `telnet` zur Verfügung
habe, um mich am nächsten Gateway anmelden zu können.

Je nachdem, ob ich auf dem Gateway ein Problem mit der physischen Verbindung
zum nächsten Hop habe, oder ob eine der benötigten Routen
fehlt, behandle ich den Fall weiter.

Bei Problemen mit der physischen Verbindung untersuche ich das Problem
bei einem Linux-basierten Router, wie im vorigen Abschnitt beschrieben.

Bei fehlenden Routen muss ich nach den Routing-Protokollen schauen.

In dringenden Notfällen kann ich mir mit einer statischen Route kurzfristig
weiterhelfen, aber das sollte die Ausnahme sein.
Wenn im Netz ein Routingprotokoll verwendet wird, so ist es besser, die Routen
darüber zu verbreiten, weil damit Änderungen im Netz automatisch an alle
Gateways bekanntgegeben werden.
Eine vergessene statische Route kann auf sehr subtile Weise zu Netzwerkfehlern
führen, die manchmal schwer zu finden sind und sich zeitlich nicht mit der
Topologieänderung verbinden lassen.

### Statische Routen eintragen

Es gibt mehrere Möglichkeiten, eine statische Route auf einem Linux-System
einzutragen.
Der direkte Weg von Kommandozeile aus geht über

{line-numbers=off,lang="text"}
    # route add -net $destination gw $gateway

oder

{line-numbers=off,lang="text"}
    # ip route add $destination via $gateway

Damit diese statische Route den nächsten Systemstart überlebt, trage ich den
Befehl bei auf Debian basierenden Systemen in */etc/network/interfaces* ein.
Sinnvollerweise bei dem Interface, über das die Verbindung zum Gateway geht:

{line-numbers=off,lang="text"}
    iface eth0 inet static
        ...
        up ip route ...

Bei Systemen, die auf Fedora oder Redhat basieren, trage ich die Route unter
*/etc/sysconfig/* in die passende Datei ein.

Die andere Möglichkeit, eine statische Route einzutragen geht über das
Programm *quagga*.
Dieses ist auf einem Gateway vermutlich sowieso installiert.

Hier melde ich mich am *zebra* Dämon an und trage die statische Route ein:

{line-numbers=off,lang="text"}
    $ telnet localhost 2601
    zebra> enable
    zebra# conf t
    zebra(config)# ip route $destination $gateway
    zebra(config)# end
    zebra# write file
    zebra# quit

Mit dem Befehl `write file` speichere ich die Konfiguration permanent,
so dass sie den nächsten Neustart überlebt.

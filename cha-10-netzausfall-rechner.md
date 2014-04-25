
## Netzausfall an einem Rechner

Komme ich zu einem Rechner, der überhaupt keine Netzverbindung hat, dann
beginne ich in der untersten Schicht, der physikalischen oder
Bitübertragungsschicht, im [OSI-Modell](#sec-osi-modell) und arbeite mich von
da langsam nach oben über die Sicherungsschicht zur Vermittlungsschicht.

Bei neu gestarteten Systemen kontrolliere ich als erstes die
Zuordnung der Schnittstellennamen mit `ifconfig` oder `ip addr show`.

Es gibt keine zuverlässige Möglichkeit,
Netzschnittstellen von vornherein eindeutig zu benennen.
Traditionell heißen Ethernetschnittstellen *eth0*, *eth1*, ...
Sobald mehrere Schnittstellen eingebaut sind, ist es nicht mehr trivial zu
bestimmen, welche physische Schnittstelle *eth0* ist.
Die Nummerierung kann sich von einer Kernel-Version zur anderen ändern, was
glücklicherweise eher selten vor kommt.
Meist ändert sie sich, wenn jemand einen Controller aus- oder einbaut.

Aus diesem Grund wird bei Debian via *udev* beim Systemstart für
jede bisher unbekannte Ethernet-Karte eine Regel in
*/etc/udev/rules.d/70-persistent-net.rules* generiert, die den nächsten
freien Namen mit der MAC-Adresse der Karte verknüpft.
Damit bleibt die Zuordnung immer gleich, unabhängig ob ich Ethernetkarten
hinzufüge oder ausbaue.

Wenn ich nun einen Klon dieses Systems in einen Rechner mit anderen
MAC-Adressen der Ethernetkarten einbaue, dann ändern sich alle
Schnittstellennamen.
Statt *eth0*, *eth1*, *eth2* finde ich dann *eth3*, *eth4*, *eth5* im System
vor.
Dann stimmt die alte Schnittstellenkonfiguration in
*/etc/network/interfaces* nicht mehr.

Na gut, mag man einwenden, aber wann kommt so etwas denn vor?
Zum Beispiel, wenn ein System virtualisiert wird, oder wenn ein bereits
virtualisiertes System geklont wird, oder wenn ein System, welches von
Flashspeicher betrieben wird, in eine andere Hardware kopiert wird.

Die Abhilfe ist einfach.
Ich entferne alle Einträge aus der Datei
*/etc/udev/rules.d/70-persistent-net.rules* und starte das System neu.

Nachdem ich mich von der korrekten Nummerierung der Netzschnittstellen
überzeugt habe, schaue ich nach, ob das System mit dem Hub, Switch oder
Rechner am anderen Ende des Kabels verbunden ist.

Dafür brauche ich keinen neuen Befehl aufrufen, das sagt mir ebenfalls `ip`:

{line-numbers=off,lang="text"}
    $ ip addr show
    ...
    2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> ...
        link/ether 00:1f:d0:97:c4:55 brd ff:ff:ff:ff:ff:ff
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
        link/ether 00:00:e8:df:92:b0 brd ff:ff:ff:ff:ff:ff
        ...

Die Angabe `NO-CARRIER` in spitzen Klammern zeigt mir, dass *eth0* keine
Verbindung hat.
Hier muss ich die Verkabelung prüfen.

A> ### Kabel prüfen
A> 
A> Beim Überprüfen der Verkabelung gehe ich nach folgendem Schema vor.
A> Ich suche zuerst nach einer funktionierenden Verbindung und prüfe
A> dann sukzessive alle Komponenten, um zu sehen, dass sie prinzipiell
A> funktionieren.
A> Das heißt, ich probiere andere Switch-Ports oder einen bisher funktionierenden
A> Rechner am fraglichen Switch-Port.
A> Kabel von defekten Leitungen setze ich in funktionierende Verbindungen ein und
A> umgekehrt.
A> Bei den Kabeln bewege ich diese möglichst über die gesamte Länge und an den
A> Steckern, um Kabelbrüche und dergleichen zu entdecken.
A> Alles, was ich dabei als defekt identifiziert habe, sondere ich aus.

Bevor ich zur nächsten Ebene im [OSI-Modell](#sec-osi-modell) übergehe, stelle
ich sicher, dass ich durch Überprüfung der Kabelverbindung und gegebenenfalls
Austausch defekter Komponenten eine funktionsfähige physische Verbindung
hergestellt habe.

Meldet der Treiber (und `ip`) eine Kabelverbindung, will ich als nächstes
sehen, dass auch Daten darüber ankommen.
Mit dem Befehl `netstat -i` sehe ich, ob Daten über die
Ethernet-Schnittstelle empfangen oder gesendet wurden:

{line-numbers=off,lang="text"}
    $ netstat -i
    Kernel-Schnittstellentabelle
    Iface  MTU Met RX-OK RX-ERR RX-DRP RX-OVR TX-OK ...
    eth0  1500 0       0      0      0 0          0 ...
    eth1  1500 0   44921      0      0 0      28889 ...
    ...

Hier sehe ich, dass an eth1 Daten ankamen und gesendet wurden.
Allerdings weiß ich noch nicht, ob die Schnittstellen jeweils am
richtigen Netz angeschlossen sind.
Mit `ip addr show` lasse ich mir die Adressen anzeigen und vergleiche diese
mit der erwarteten Konfiguration.
Stimmt diese überein, dann versuche ich mit *Ping* einen Rechner in jedem
angeschlossenen Netz zu erreichen.
Bekomme ich keine Antwort können die Karten noch im falschen Netz
angeschlossen sein.
Das überprüfe ich mit:

{line-numbers=off,lang="text"}
    # tcpdump -n -i $if

das mir den Verkehr am betreffenden Interface anzeigt.
Dabei schaue ich nach Broadcasts und ARP-Anfragen, die mir sagen, in welchem
Netzsegment das betreffende Interface angeschlossen ist.
Nötigenfalls tausche ich die Kabel, bis alle Schnittstellen mit dem richtigen
Netzsegment verbunden sind.

A> Oft kommt es vor, dass ich bei einem Ping-Test im korrekten Segment keine
A> Antwort bekomme.
A> Manchmal ist das betreffende System wirklich nicht erreichbar, immer
A> häufiger stelle ich jedoch fest, dass ein Rechner auf Grund seiner
A> Standard-Firewall-Einstellungen nicht auf PING antwortet.
A> In diesem Fall sagt mir ein Blick in den ARP-Cache, ob ich unter der
A> betreffenden IP-Adresse einen Rechner erreichen kann.
A> 
{line-numbers=off,lang="text"}
A>     # arp -an
A>     ? (192.168.1.4) auf <unvollständig> auf eth1
A>     ? (192.168.1.5) auf 00:01:6c:6f:c5:d6 [ether] auf eth1
A>     ...
A> 
A> Im Beispiel ist der Rechner mit IP-Adresse 192.168.1.4 nicht zu
A> erreichen, während der Rechner mit IP-Adresse 192.168.1.5 im Netz erreichbar
A> ist.
A> Bekomme ich keine PING-Antwort, so kann ich bei letzterem auf
A> störende Paketfilter schließen.

Sobald ich irgendeinen Rechner im direkt angeschlossenen Netzsegment erreichen
kann, habe ich es nicht mehr mit einem totalen Netzausfall des Rechners zu tun.

Dann schaue ich als nächstes nach, ob ein Gateway definiert ist, ob ich
dieses erreichen kann und schließlich, ob ich irgend einen Rechner hinter dem
Gateway erreiche.
Aber das gehört schon zu einem anderen Themenkreis und wird an anderer Stelle
in diesem Buch beschrieben.

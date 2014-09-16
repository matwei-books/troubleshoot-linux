
## bridge-utils {#sec-netz-werkzeuge-bridge-utils}

Es gibt mehrere Szenarien, in denen ich mich bei der Fehlersuche mit
Layer2-Bridges beschäftige. Zum einen, wenn ich einen verdächtigen
Rechner habe und zur Kontrolle jeglichen Netzverkehrs eine Bridge vor seinen
Netzanschluß schalten will. Oder, wenn ich den Verkehr auf einer
Punkt-zu-Punkt-Verbindung kontrollieren will. In diesen Fällen möchte ich
das restliche Netzwerk möglichst unverändert lassen und keinen anderen
Rechner umkonfigurieren, um das Problem beobachten zu können.
Mit einer Bridge bekomme ich allen Datenverkehr an der betreffenden Stelle
frei Haus geliefert.
Bis 100 MBit/s eignen sich beispielsweise Einplatinenrechner, wie in
[[Weidner2012](#bib-weidner2012)] beschrieben, sehr gut dafür.
Ein weiteres Szenario ist eine regulär betriebene Bridge, die scheinbar nicht
funktioniert und die ich mit den bridge-utils untersuchen kann.

Prinzipiell kann ich mit einer Linux-Bridge den Verkehr filtern und
begrenzen. Dafür verwende ich auf Layer2-Ebene `ebtables` und auf
Layer3-Ebene `iptables`, bei letzteren benötige ich für eine Bridge
einen Kernel ab Version 2.4.

Linux-Bridges können das Spanning Tree Protocol (STP) verwenden und ich kann
sie auch zur Diagnose von STP-Problemen heranziehen, obwohl mir hier
tcpdump oder wireshark genausogut weiterhelfen.

Generell konfiguriere ich eine Bridge mit `brctl`.
Mit `ipconfig`, `ip` oder einem DHCP-Client kann ich ihr dann eine IP-Adresse
zuweisen.
Das Bridge-Forwarding-Delay von circa 30 Sekunden kann bei DHCP-Clients
Probleme bereiten.
Wenn gar nichts geht, muss ich das Bridge-Interface mit statischen Adressen
konfigurieren.

Lässt eine Bridge keinen Traffic durch, suche ich im Verzeichnis
*/proc/sys/net/bridge/* nach Dateien mit Namen die mit `bridge-nf-*` beginnen.
Diese legen fest, ob die betreffende Bridge Verkehr filtert.
Das kann ich abschalten, indem ich eine '0' in die betreffende Datei schreibe:

{line-numbers=off,lang="text"}
    # echo 0 \
      > /proc/sys/net/bridge/bridge-nf-call-arptables
    # echo 0 \
      > /proc/sys/net/bridge/bridge-nf-call-ip6tables
    # echo 0 \
      > /proc/sys/net/bridge/bridge-nf-call-iptables

Mit dem Program `brctl` inspiziere und bearbeite ich
die Bridge-Konfiguration im Linux-Kernel.

Dabei verwende ich die folgenden Befehle um eine oder mehrere
Bridge-Instanzen zu bearbeiten:

brctl addbr $brname
: fügt eine neue Bridge-Instanz namens *$brname* hinzu.

brctl delbr $brname
: entfernt die Bridge *$brname*.

brctl show
: zeigt alle momentan bekannten Bridges und die ihnen
  zugeordneten Interfaces an.

Jede Bridge benötigt Ports, zwischen denen sie Ethernet-Pakete vermittelt.
Diese bearbeite ich mit den folgenden Befehlen:

brctl addif $brname $if
: fügt die Schnittstelle *$if* zur Bridge
  mit Namen *$brname* hinzu. Das Interface muss ich mit `ifconfig`
  oder `ip` aktivieren.

brctl delif $brname $if
: entfernt Schnittstelle *$if* von Bridge *$brname*.

brctl show $brname
: zeigt Informationen zur Bridge *$brname*.

brctl showmacs $brname
: zeigt die der Bridge *$brname* momentan
  bekannten MAC-Adressen an.
  
  Um herauszufinden, an welcher Schnittstelle
  die betreffende MAC-Adresse zuletzt gesichtet wurde, bestimme ich die
  Adresse und den Port in den Zeilen, in denen bei Spalte
  `is local?` der Wert 'yes' steht und ermittle mit `ifconfig` oder
  `ip` die betreffende Ethernet-Schnittstelle.

{line-numbers=off,lang="text"}
        $ /usr/sbin/arp -an
        192.168.1.253 auf 00:16:3e:ca:72:4c ether auf br0
        192.168.1.223 auf b8:27:eb:74:74:d5 ether auf br0
        ...
        $ brctl showmacs br0 
        port no mac addr          is local? ageing timer
          1     00:00:e8:df:92:b0 yes           0.00
          1     00:16:3e:ca:72:4c no           20.54
          2     00:1f:d0:97:c4:55 yes           0.00
          2     b8:27:eb:74:74:d5 no            7.98
          ...
        $  ip l sh
        ...
        2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
            master br0 state UP qlen 1000
            link/ether 00:1f:d0:97:c4:55 ...
        3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
            master br0 state UNKNOWN qlen 1000
            link/ether 00:00:e8:df:92:b0 ...
        4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
            link/ether 00:00:e8:df:92:b0 ...

  In diesem Beispiel ist der Rechner mit IP `192.168.1.223` an *eth0* und der
  Rechner mit IP `192.168.1.253` an *eth1* angeschlossen, die über die Bridge
  *br0* miteinander verbunden sind.

Die Timer der Bridge kann ich mit den folgenden Befehlen ändern:

brctl setageing $brname $time
: setzt den Timer für die Bridge *$brname*.
  Nach dem eine MAC-Adresse so viele Sekunden nicht gesehen wurde, wird die
  Bridge sie aus der Forwarding-Tabelle austragen.

brctl setgcint $brname $time
: setzt das Intervall für die Garbage Collection auf *$time*.
  Aller *$time* Sekunden kontrolliert die Bridge die Forwarding-Tabelle nach
  veralteten MAC-Adressen.


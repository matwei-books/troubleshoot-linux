
## bridge-utils {#sec-netz-werkzeuge-bridge-utils}

Ein Rechner mit Linux kann nicht nur als Router IP-Pakete in Layer 3
weiterleiten, sondern auch als Bridge in Layer 2. Letzteres wird mit den
bridge-utils konfiguriert.

Es gibt mehrere Szenarien, in denen man sich bei der Fehlersuche mit der
Linux-Layer2-Bridge beschäftigen muß. Zum einen, wenn ich einen verdächtigen
Rechner habe und zur Kontrolle jeglichen Netzverkehrs eine Bridge vor seinen
Netzanschluß schalten will. Oder, wenn ich den Verkehr auf einer
Punkt-zu-Punkt-Verbindung kontrollieren will. In diesen Fällen möchte ich
das restliche Netzwerk möglichst unverändert lassen und keinen anderen
Rechner umkonfigurieren um das Problem beobachten zu können. Mit einer
Bridge bekomme ich allen Datenverkehr an der betreffenden Stelle frei Haus
geliefert. Bis 100 MBit/s eignen sich beispielsweise kleine
Einplatinenrechner, wie in [[Weidner2012](#bib-weidner2012)] beschrieben, sehr
gut dafür. Ein anderes Szenario ist eine regulär betriebene Bridge (zum
Beispiel für virtuelle Maschinen), die scheinbar nicht funktioniert und die
ich mit den bridge-utils untersuchen kann.

Prinzipiell kann ich mit einer Linux-Bridge den Verkehr filtern und
begrenzen. Dafür verwende ich auf Layer2-Ebene `ebtables` und auf
Layer3-Ebene `iptables`, bei letzteren benötige ich für eine Bridge
mindestens einen Kernel ab Version 2.4.

Linux-Bridges können das Spanning Tree Protocol (STP) verwenden und ich kann
sie auch zur Diagnose von STP-Problemen heranziehen (obwohl mir hier sicher
tcpdump, wireshark, etc genausogut weiterhelfen.

Generell wird eine Bridge mit den Programmen `ifconfig`
(beziehungsweise `ip` von iproute2) und `brctl` konfiguriert.

Falls eine Bridge keinen Traffic durchlässt, kann ich in
*/proc/sys/net/bridge/* nach Dateien mit Namen wie `bridge-nf-*`
suchen. Diese legen fest, ob die betreffende Bridge Verkehr filtert. Das
kann ich abschalten, indem ich eine '0' in die betreffende Datei schreibe:

    # echo 0 > /proc/sys/net/bridge/bridge-nf-call-arptables
    # echo 0 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
    # echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables

Ein Problem mit Bridges könnte das Bridge-Forwarding-Delay von circa 30
Sekunden sein, das bei DHCP-Clients Probleme bereiten kann.

Mit dem Program `brctl` bearbeite beziehungsweise inspiziere ich
die Bridge-Konfiguration im Linux-Kernel.

Dabei verwende ich die folgenden Befehle um eine oder mehrere
Bridge-Instanzen zu bearbeiten:

brctl addbr name
: fügt eine neue Bridge-Instanz namens 'name' hinzu.

brctl delbr name
: entfernt die Bridge 'name'.

brctl show
: zeigt alle momentan bekannten Bridges und die ihnen
  zugeordneten Interfaces an.

Jede Bridge benötigt Ports, zwischen denen sie Ethernet-Pakete vermittelt.
Diese bearbeite ich mit den folgenden Befehlen:

brctl addif brname if
: fügt die Schnittstelle 'if' zur Bridge
  mit Namen 'brname' hinzu. Das Interface muss ich mit `ifconfig`
  oder `ip` aktivieren.

brctl delif brname if
: entfernt Schnittstelle 'if' von Bridge 'brname'.

brctl show brname
: zeigt Informationen zur Bridge 'brname'.

brctl showmacs brname
: zeigt die der Bridge 'brname' momentan
  bekannten MAC-Adressen an. Um herauszufinden, an welcher Schnittstelle
  die betreffende MAC-Adresse zuletzt gesichtet wurde, bestimme ich die
  die Adresse und den Port in den Zeilen, in denen bei Spalte
  `is local?` auf 'yes' steht und ermittle mit `ifconfig` oder
  `ip` die betreffende Ethernetschnittstelle.

Die Timer der Bridge kann ich mit den folgenden Befehlen bearbeiten:

brctl setageing brname time
: setzt den Ageing-Timer für die Bridge
  'brname'. Nach dem eine MAC-Adresse so viele Sekunden nicht gesehen
  wurde, wird die Bridge sie aus der Forwarding-Tabelle austragen.

brctl setgcint brname time
: setzt das Intervall für die Garbage
  Collection auf 'time' Sekunden. Aller 'time' Sekunden kontrolliert die
  Bridge die Forwarding-Tabelle nach veralteten MAC-Adressen.

Das Spanning Tree Protocol kann ich mit den folgenden Befehlen bearbeiten:

brctl stp brname status
: schaltet STP an Bridge 'brname' ein, wenn ich für 'status' `on`
  oder `yes` angebe.

brctl showstp brname
: zeigt detaillierte Angaben zu STP an Bridge 'brname'.

Für weitere Befehle zur Manipulation von STP verweise ich auf die
Handbuchseite. Vor deren Einsatz empfiehlt es sich, sich mit dem Spanning
Tree Protocol vertraut zu machen.


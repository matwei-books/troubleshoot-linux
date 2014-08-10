
## ifconfig {#sec-netz-werkzeuge-ifconfig}

Mit dem Programm ifconfig kann ich die Netzwerkschnittstellen konfigurieren.
Außerdem liefert es Informationen über den aktuellen
Zustand und die Konfiguration der Netzwerkschnittstelle.

Es gibt drei Möglichkeiten ifconfig aufzurufen.

{line-numbers=off,lang="text"}
    # ifconfig [-a]

zeigt den Status der aktiven Schnittstellen.
Gebe ich zusätzlich die Option `-a`, zeigt es den Status aller Schnittstellen,
also auch der inaktiven.

{line-numbers=off,lang="text"}
    # ifconfig $schnittstellenname

zeigt den Zustand der angegebenen Schnittstelle an.

In der dritten Form,

{line-numbers=off,lang="text"}
    # ifconfig $schnittstellenname $optionen

wird die Schnittstelle konfiguriert.

Die wichtigsten Optionen bei der Fehlersuche sind

up
: zum Aktivieren von Schnittstellen

down
: zum Deaktivieren

mtn $N
: zum Setzen der Maximum Transfer Unit

netmask $M
: zum Setzen der Netzmaske

hw $A
: zum Setzen der Hardware-Adresse

Weitere Informationen liefert die Handbuchseite.

Es ist möglich, an eine Netzwerkschnittstelle mehrere IP-Adressen zu binden.
Das Programm ifconfig arbeitet jedoch mit einer Adresse pro Schnittstelle.
Um weitere Adressen an diese Schnittstelle zu binden, füge ich an den
Schnittstellennamen einen Doppelpunkt und eine Zahl an.

In letzter Zeit werden die Netzwerkschnittstellen oft mit dem Programm ip
vom Paket iproute2 konfiguriert, welches in der Sektion über
[iproute](#sec-netz-werkzeuge-iproute) beschrieben ist.
Für den schnellen Überblick über die aktuelle Konfiguration der Schnittstellen
gefällt mir die Ausgabe von `ip addr show` besser, da sie kompakter
ist, was sich insbesondere dann auszahlt, wenn ein Rechner mehrere
Netzwerkschnittstellen hat, oder mehrere Adressen an einer Schnittstelle.


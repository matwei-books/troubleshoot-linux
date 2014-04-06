
## ifconfig {#sec-netz-werkzeuge-ifconfig}

Das Programm ifconfig dient traditionell der Konfiguration der
Netzwerkschnittstellen. Außerdem liefert es Informationen über den aktuellen
Zustand und die Konfiguration der Netzwerkschnittstelle.

Es gibt drei prinzipielle Möglichkeiten ifconfig aufzurufen. Mit

{line-numbers=off,lang="text"}
    # ifconfig [-a]

zeigt das Programm den Status der aktiven Schnittstellen.
Gebe ich zusätzlich die Option `-a`, zeigt es den Status aller Schnittstellen,
also auch der inaktiven.

Durch Aufruf von

{line-numbers=off,lang="text"}
    # ifconfig $schnittstellenname

zeigt das Programm den Zustand genau der angegebenen Schnittstelle an.

In der dritten Form,

{line-numbers=off,lang="text"}
    # ifconfig $schnittstellenname $optionen

wird die Schnittstelle konfiguriert.

Die wichtigsten Optionen bei der Fehlersuche sind

up
: zum Aktivieren von Schnittstellen

down
: zum Deaktivieren

mtn N
: zum Setzen der Maximum Transfer Unit

netmask M
: zum Setzen der Netzmaske

hw A
: zum Setzen der Hardware-Adresse

Weitere Informationen liefert die Handbuchseite.

Es ist möglich, an eine Netzwerkschnittstelle mehrere IP-Adressen zu binden.
Das Programm ifconfig arbeitet jedoch mit einer Adresse pro Schnittstelle.
Um weitere Adressen an diese Schnittstelle zu binden, fügt man an den
Schnittstellennamen einen Doppelpunkt und eine Zahl an.

In letzter Zeit werden die Netzwerkschnittstellen auch mit dem Programm ip
vom Paket iproute2 konfiguriert, welches in der Sektion über
[iproute](#sec-netz-werkzeuge-iproute) beschrieben ist.
Für den schnellen Überblick über die aktuelle Konfiguration der Schnittstellen
gefällt mir die Ausgabe von `ip addr show` besser, da sie kompakter
ist, was sich insbesondere dann auszahlt, wenn ein Rechner mehrere
Netzwerkschnittstellen hat, oder mehrere Adressen auf einer Schnittstelle.


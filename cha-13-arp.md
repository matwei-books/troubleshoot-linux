
## arp {#sec-netz-werkzeuge-arp}

Das Programm `arp` dient der Anzeige und Manipulation des ARP-Caches des
Kernels.
Ich setze es bei Problemen in direkt angeschlossenen Netzsegmenten ein und
verwende es

*   um die Zuordnung von IP-Adressen zu Ethernet-Adressen zu verifizieren

*   um zu sehen, ob ein Rechner eine bestimmte IP-Adresse verwendet, auch wenn
    ich keine Antwort auf TCP-, UDP- oder ICMP-Verbindungsversuche (Ping)
    bekomme.

*   seltener: um eine bestimmte Zuordnung zwischen IP-Adresse und
    Ethernet-Adresse fest vorzugeben.

Der prinzipielle Aufruf ist:

{line-numbers=off,lang="text"}
    # arp [Optionen] [Rechnername]

Bei Aufruf ohne Optionen zeigt `arp` die MAC-Adressen an, die *Rechnername*
zugeordnet sind. Fehlt *Rechnername*, zeigt es alle bekannten
Adresszuordnungen an.
*Rechnername* kann ein Hostname sein, ein FQDN oder eine IP-Adresse.

Die für die Fehlersuche wichtigsten Optionen sind:

-n
: unterlässt die Namensauflösung der IP-Adressen

-d Rechnername
: entfernt alle Einträge für *Rechnername*

-s Rechnername Hardwareadresse
: setzt den Eintrag für *Rechnername* auf *Hardwareadresse*

Für weitergehende Informationen verweise ich auf die Handbuchseite.
Nähere Informationen zum ARP-Protokoll sind im
[Grundlagenkapitel für Netze](#sec-grundlagen-arp) zu finden.

Wenn ich `arp` verwende, um mich von der Anwesenheit eines Rechners mit einer
bestimmten IP-Adresse im Netz zu überzeugen, sieht das wie folgt aus:

{line-numbers=off,lang="text"}
    $ ping -c1 192.168.1.5
    PING 192.168.1.5 (192.168.1.5) 56(84) bytes of data.
    
    --- 192.168.1.5 ping statistics ---
    1 packets transmitted, 0 received,\
     100% packet loss, time 0ms
    $ ping -c1 192.168.1.6
    PING 192.168.1.6 (192.168.1.6) 56(84) bytes of data.
    From 192.168.1.3 icmp_seq=1 Destination Host\
     Unreachable
    
    --- 192.168.1.6 ping statistics ---
    1 packets transmitted, 0 received, +1 errors,\
     100% packet loss, time 0ms

Ich habe weder von Adresse `192.168.1.5` noch von `192.168.1.6` eine
Antwort auf die PING-Anfrage bekommen.
Bei der zweiten Adresse kam jedoch die Meldung *Destination Host Unreachable*,
die bei der ersten Adresse fehlte.
Bei der Kontrolle des ARP-Caches zeigt sich, dass für die erste IP-Adresse
eine MAC-Zuordnung gegeben ist, für die zweite nicht.

{line-numbers=off,lang="text"}
    $ arp -an
    ? (192.168.1.5) auf 00:01:6c:6f:c5:d6 [ether] auf eth0
    ? (192.168.1.6) auf <unvollständig> auf eth0
    ...

Das lässt vermuten, dass auf dem Rechner mit IP-Adresse `192.168.1.5` PING
durch Paketfilterregeln blockiert wird.

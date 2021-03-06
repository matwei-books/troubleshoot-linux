
## ARP - Address Resolution Protocol {#sec-grundlagen-arp}

Für die Zuordnung von Adressen der Netzzugangsschicht (OSI-Schichten 1 und 2)
zu denen der Internetschicht (OSI-Schicht 3) dient bei IPv4 das ARP-Protokoll.
Es ist in RFC 826 beschrieben und in RFC 5527 sowie RFC 5494 aktualisiert und
ergänzt.
Für IPv6 wird dafür das Neighbor Discovery Protocol verwendet, das RFC 4861
beschreibt.

Ein Rechner, der via Ethernet eine Verbindung zu einem anderen mit einer
IP-Adresse im direkt angeschlossenen Segment aufbauen will,
sendet eine ARP-Anfrage mit seiner Ethernet- und IP-Adresse als Quelle und der
IP-Adresse des Partners als Ziel an die Ethernet-Broadcast-Adresse
(`ff:ff:ff:ff:ff:ff`).
Erhält der Ziel-Rechner diese ARP-Anfrage, antwortet er direkt an den
anfragenden Rechner.
Daraufhin aktualisiert der Anfragende seinen ARP-Cache.
Zusätzlich kann der Angefragte seinerseits den Cache mit den
Daten der Anfrage aktualisieren.
Das ist vom Protokoll jedoch nicht vorgegeben.

ARP funktioniert grundsätzlich nur im direkt angeschlossenen Netzsegment und
nicht über Router.
Es ist jedoch möglich, dass ein Router stellvertretend für die IP-Adressen,
zu denen er Routen kennt, ARP-Anfragen beantwortet.
Das nennt man Proxy-ARP.
Proxy-ARP setze ich zum Beispiel ein, wenn zwei Netzsegmente zwar durch
Router getrennt sind, aber als ganzes Segment erscheinen sollen.
Im Gegensatz zur Kopplung mit einer Bridge werden in diesem Fall keine
Broadcasts zwischen den Teilnetzen ausgetauscht.

Dann gibt es noch Gratuitous ARP, bei dem der Sender seine Adressen
sowohl bei der Quelle als auch beim Ziel einträgt.
Diese sollten normalerweise nicht beantwortet werden.
Eine Antwort auf Gratuitous ARP ist ein Indiz für eine Fehlkonfiguration.
Gratuitous ARP werden manchmal beim Booten eines Rechners versendet,
in Hochverfügbarkeitsszenarien, wenn eine IP-Adresse auf eine andere
MAC-Adresse umgeschaltet werden soll, sowie bei Mobile-IP-Lösungen.

Schließlich ist ARP Bestandteil bei Zero Configuration Networking, speziell bei
*Dynamic Configuration of IPv4 Link-Local Addresses* (RFC 3927), um dynamisch
eine IP-Adresse zu bestimmen, die nur für das lokale Segment gültig ist.
Für diesen Zweck ist der Adressbereich 169.254.0.0/16 reserviert.



## Ausfall essentieller Dienste im Netz

Der Ausfall essentieller Dienste im Netz erscheint, oberflächlich betrachtet,
manchmal wie ein Totalausfall.
Da oft nur ein Dienst auf einem oder wenigen Servern ausgefallen ist,
behandle ich ihn bei der Fehlersuche als Teilausfall im Netz.
Wichtig ist für mich, diesen Ausfall eines oder weniger Dienste zu
identifizieren und vom Totalausfall des Netzes zu unterscheiden.

Bereits vor dem Ausfall muss ich mir Gedanken machen, wie ich die
Auswirkungen dieses Ausfalls lindere und wie ich vorgehe, um den Ausfall zu
beheben.

Bei DHCP, einem der ersten Netzdienste, mit dem ein Rechner in Kontakt kommt,
hilft nur Redundanz, die Auswirkungen eines Ausfalls zu lindern.
Server sollten, wenn sie nicht gerade im Cluster betrieben werden,
nicht via DHCP konfiguriert werden.
Falls die Arbeitsstationen immer die gleiche Adresse bekommen,
sind längere Lease-Zeiten von Vorteil, weil dadurch die
Client-Konfiguration länger gültig ist und ich etwas mehr Zeit habe, den
Dienst wieder zum Laufen zu bringen, bevor alle Clients ohne Konfiguration da
stehen.

Bei DNS hilft ebenfalls Redundanz, diese ist im Dienst bereits vorgesehen.
In kleinen Satelliten-Netzen kann ich den Nameserver auf dem
Gateway nutzen und für wichtige interne Dienste Einträge in der *hosts* Datei
vorsehen.
Denn ich kann davon ausgehen, dass beim Ausfall des DNS oft auch der
Internetzugang betroffen ist und mir der DNS sowieso nichts genutzt hätte.
Durch die zusätzlichen Einträge in der Datei */etc/hosts* kann ich
intern weiter arbeiten.

Auch bei NTP hilft Redundanz.
Bei Ausfall eines Server kann temporär ein anderer dessen IP-Adresse
übernehmen, wenn ich Clientrechner habe, die nur eine Adresse für den
Zeitserver verwenden können.

Unabdinglich ist, dass ich die essentiellen Dienste überwache und dieses
Überwachungssystem so robust aufsetze, dass es auch dann noch
funktioniert, wenn die Dienste ausgefallen sind.

Genauso wichtig ist eine vollständige und aktuelle Dokumentation des Netzes,
seiner Topologie und der Dienste.
Nach meiner Erfahrung kann die Dokumentation auf lange Sicht nur dann aktuell
bleiben, wenn es nur eine Stelle gibt, an der ich die Konfiguration und
Dokumentation gleichzeitig ändere und wenn mindestens eine der beiden
automatisch generiert wird.

**Natürlich muss ich an die Dokumentation im Fehlerfall herankommen.**
Halte ich diese ausschließlich elektronisch vor, ist eine
Kopie auf USB-Stick und/oder auf dem Notfall-Laptop manchmal die letzte
Rettung.

### Wie erkenne ich den Ausfall eines essentiellen Dienstes?

Diese Frage ist insofern wichtig, als sich dieser Ausfall für den Kunden oft
als Totalausfall des Netzes darstellt, während ich ihn bei der Fehlersuche als
Teilausfall im Netz behandele.
Insbesondere, wenn ich noch keine Hinweise vom Monitoring habe, muss ich
den Totalausfall vom Ausfall essentieller Dienste unterscheiden können.
Die Aussagen des Kunden führen mich hier möglicherweise in die Irre, wenn ich
nicht durch genaue Kenntnis der Netztopologie und der Konfiguration der
betroffenen Rechner zu den richtigen Schlüssen komme.

Leider gibt es keinen generellen Weg, der in jedem Fall zur Lösung des
Problems führt, da jedes Netz seine Eigenheiten hat und einige Dienste nutzt,
andere nicht.

Meldet mir ein Kunde einen Totalausfall des Netzes, so frage ich zunächst
danach, ob das Problem nur seinen Rechner betrifft, oder alle Rechner in einem
bestimmten Bereich.
Betrifft es mehrere Rechner, muss ich entscheiden, ob es sich um ein
Problem der unteren Schichten des Netzes handelt, oder ob ein essentieller
Dienst ausgefallen ist.

Dazu schaue ich mir als erstes die IP-Konfiguration des betroffenen Rechners
an.
Ist diese korrekt, bezogen auf das Netzsegment, in dem sich der Rechner
befindet, kann ich davon ausgehen, dass der DHCP-Dienst nicht der Auslöser des
Problems ist.
Dann versuche ich, verschiedene Rechner an verschiedenen Stellen im Netz mit
PING zu erreichen.
Dabei muss ich immer im Hinterkopf haben, dass manche Rechner nicht auf PING
antworten, weil Firewall-Regeln das unterbinden.
Vielleicht auch, weil der angefragte Rechner auf Grund von Routingproblemen die
Antworten nicht zurückschicken kann.
Dadurch, dass ich versuche, verschiedene Rechner von verschiedenen Stellen aus
zu erreichen, kann ich einige dieser Möglichkeiten ausschließen.

Funktioniert die Verbindung mittels IP-Adresse, versuche ich als
nächstes das gleiche mit Namen statt IP-Adressen, um mich zu vergewissern,
dass DNS funktioniert.

Wenn auch dieses funktioniert, prüfe ich als nächstes das Verhalten der
Anwendungsprogramme.
Da es davon sehr viele gibt, mit den unterschiedlichsten Anforderungen an das
Netz, gehe ich hier nicht auf Details ein.

Stelle ich bei meinen Untersuchungen fest, dass ein essentieller Dienst
ausgefallen ist, versuche ich Kontakt zu dem betreffenden Rechner aufzunehmen
und behandle das Problem weiter wie ein Problem auf einem lokalen
Rechner.

Es folgen ein paar Hinweise, falls ich Ausfälle bestimmter Netzdienste vermute.

### DHCP

Einen Ausfall eines DHCP-Servers erkenne ich daran, dass die Rechner im
betroffenen Netzsegment keine gültige Netzkonfiguration bekommen.
Mitunter können die Rechner noch einige Dienste, zum Beispiel Drucker,
erreichen, wenn sie via Zero Configuration Networking eine Adresse im Netz
169.254.0.0/16 angenommen haben.
Zum Überprüfen ob ein DHCP-Server überhaupt läuft, kann ich zum Beispiel das
entsprechende Plugin für Nagios verwenden.
Ansonsten schaue ich direkt auf dem Rechner mit dem DHCP-Server in den
Protokollen nach.

Falls sich der DHCP-Server in einem anderen Netzsegment befindet wie der
betroffene Rechner, muss ich mir unter Umständen auch das DHCP-Relay auf den
Gateways zwischen DHCP-Server und Client-Rechner ansehen.
Manchmal blockieren Firewall-Regeln diesen Dienst.

### DNS

Bei einem Ausfall des DNS funktioniert die Auflösung der Namen zu IP-Adressen
nicht und für manche Kunden funktioniert scheinbar gar nichts mehr.
Tests mit IP-Adressen zeigen allerdings, dass das Netz als solches
funktioniert.
Natürlich ist es möglich, dass einzelne Namen noch aufgelöst werden.
Diese finde ich dann meist in der Datei */etc/hosts*.

Vermutete ich einen Ausfall des DNS, überprüfe ich zwei Dinge am betroffenen
Rechner: *welche Nameserver sind konfiguriert* und *antworten diese auf gezielte
DNS-Anfragen*?
Bei gezielten DNS-Anfragen verlasse ich mich nicht auf die Resolver-Bibliothek
des Betriebssystems, sondern gebe direkt an, von welchem Nameserver ich eine
Antwort möchte.
Das kann ich mit den Programmen `host`, `nslookup`, `dig` oder mit `busybox
nslookup` machen, die folgenden Befehle befragen jeweils den Nameserver unter
IP 192.168.1.254 nach *www.example.com*:

{line-numbers=off,lang="text"}
    $ host www.example.com 192.168.1.254
    $ nslookup www.example.com 192.168.1.254
    $ dig www.example.com @192.168.1.254
    $ busybox nslookup www.example.com 192.168.1.254

Stelle ich fest, dass ein falscher Nameserver konfiguriert ist, muss ich die
Konfiguration korrigieren.
Kommt diese vom DHCP-Server, dann muss ich mir dessen Konfiguration ansehen.

Bekomme ich von keinem Nameserver eine Antwort, überprüfe ich die Nameserver
von anderen Rechnern aus und mit anderen Anfragen.
Sind die Nameserver an sich in Ordnung, suche ich nach Firewall-Regeln, die
das DNS behindern.

### NTP

Zeitfehler sind subtil, da die Uhrzeit der Rechner oft nur allmählich
auseinander driftet.
Bestimmte Dienste, wie zum Beispiel *Kerberos* für die Authentisierung,
tolerieren nur geringe Abweichungen der Systemzeit und funktionieren dann
scheinbar ohne ersichtlichen Anlass nicht mehr.

Bei zentraler Protokollierung kann ich Zeitfehler bei einzelnen Rechnern an den
Zeitstempeln der Einträge erkennen.

Mit dem Programm `ntpq` kann ich einen NTP-Dämon befragen. Meist sind diese
jedoch so konfiguriert, dass sie nur von bestimmten Rechnern oder nur von
*localhost* abgefragt werden können.
Das bedeutet, ich muß mich an diesem Rechner anmelden.

Auf dem betroffenen Client-Rechner kontrolliere ich, welcher Zeitserver
konfiguriert ist.
Stimmt der konfigurierte Zeitserver nicht, korrigiere ich die Konfiguration
oder schaue mir die Konfiguration des DHCP-Servers an, falls dieser den
zuständigen NTP-Server mitteilt.

### Proxy-Autokonfiguration

Prinzipiell gibt es mehrere Möglichkeiten, die Proxy-Server im Webbrowser
einzustellen:

*   Von Hand. Das skaliert nicht mehr ab einer bestimmten Anzahl Nutzern oder
    verschiedenen Proxy-Servern.

*   Mit einer URL für eine PAC-Datei. Das skaliert nicht mit der Anzahl der
    Nutzer.

*   Vollautomatisch mit dem WPAD-Protokoll. Das will ich haben, wenn es
    funktioniert.

#### PAC-Datei {#sec-proxy-auto-config}

Die Datei für Proxy Auto Configuration (PAC) ist eine Textdatei, die die
JavaScript-Funktion `FindProxyForURL(url, host)` definiert.
In den Argumenten `url` und `host` liefert der Browser den URL und den
Hostnamen für die Datei, die er herunterladen möchte.
Als Rückgabe erwartet er einen String, der ihm den Proxy nennt oder
"DIRECT", um die Datei direkt abzuholen.
Diese Funktion könnte zum Beispiel so aussehen:

{line-numbers=off,lang="text"}
    function FindProxyForURL(url,host) {
        return "PROXY proxy.example.com:3128; DIRECT";
    }

Die Datei muss auf einem Webserver liegen und von diesem mit dem MIME-Typ
`application/x-ns-proxy-autoconfig` ausgeliefert werden.
Gängige Namen sind *proxy.pac* oder *wpad.dat*.
Letzteren verwendet der Browser bei der Bestimmung des URL dieser Datei via
DNS mit dem WPAD-Protokoll.

Habe ich einen Webserver der diese Datei ausliefert, kann ich deren Funktion
durch direkte Konfiguration der URL bei den Proxy-Einstellungen des Browsers
überprüfen.

#### WPAD-Protokoll

Eine Datei zu haben, in der ich zentral festlegen kann, wie die Webbrowser den
richtigen Proxy-Server finden, ist erst die halbe Miete.
Ich muss auch dafür sorgen, dass die Browser diese Datei finden.

Die zunächst am einfachsten erscheinende Lösung ist, den URL dieser Datei im
Browser fest einzutragen.
Der Vorteil ist, dass ich keine weitere Infrastruktur dafür vorhalten muss.
Nachteile sind zum einen, dass ich den URL bei jedem Browser eintragen muss
und zum anderen, dass ich den URL nicht nachträglich ändern kann, ohne
wiederum zu jedem Browser zu gehen und sie vor Ort anzupassen.
Oder kurz: das skaliert nicht mit der Anzahl der Nutzer.

Zum Glück haben sich andere bereits Gedanken über das Problem gemacht und mit
dem WPAD-Protokoll einen Weg geschaffen, mit dem nahezu jeder Webbrowser
automatisch seinen Proxy finden kann.

Dazu greift das WPAD-Protokoll auf verschiedene Methoden zurück, je nach
Browser und Betriebssystem, auf dem der Browser läuft.
Die gängigsten Methoden sind DHCP für Rechner, die auch ihre IP-Adresse via
DHCP erhalten haben, und bestimmte DNS-Einträge, die den Hostnamen der URL für
die PAC-Datei auf eine konkrete IP-Adresse abbilden.

##### Bestimmen des URL mit DHCP

In der Option 252 (*auto-proxy-config*) kann der DHCP-Server einem Client die
URL der PAC-Datei in einem String mitteilen.

Diese Methode funktioniert nur auf Rechnern, die DHCP-Client sind, da die
Browser selbst keine DHCP-Anfragen versenden.
Um diese Option zu verifizieren, schaue ich auf dem Client in der Datei
*/var/lib/dhcp/dhclient.leases* nach.
Je nach verwendeter DHCP-Client-Software finde ich die Datei eventuell an
anderer Stelle.

Dabei kann ich verschiedenen Clients unterschiedliche URLs zuweisen,
indem ich den DHCP-Server unterschiedliche Strings an die verschiedenen
Clients senden lasse.

##### Bestimmen des URL mit DNS

Diese Methode ist auch für Rechner mit statisch vergebener IP-Adresse
geeignet, weil der Webbrowser mit der Resolver-Bibliothek problemlos Anfragen
via DNS stellen kann, während es schwierig ist, den DHCP-Client-Dämon
zu gezielten Anfragen nach bestimmten Optionen zu bewegen.

Der Webbrowser versucht nach dieser Methode die PAC-Datei von einem URL zu
laden, bei dem die Datei unter dem Namen  *wpad.dat* im Wurzelverzeichnis des
Servers zu finden ist und der Hostname *wpad* lautet gefolgt von bestimmten
Domain-Endungen.

Diese Endungen werden zunächst aus dem Domain-Suffix des FQDN des eigenen
Rechners gebildet und dann sukzessive von links verkürzt.
Das heißt, der Webbrowser versucht auf dem Rechner *pc.branch.example.com*
nacheinander, bis er Erfolg hat, die folgenden URLs:

*   *http://wpad.branch.example.com/wpad.dat*

*   *http://wpad.example.com/wpad.dat*

*   *http://wpad.com/wpad.dat*

*   *http://wpad/wpad.dat*

Das birgt die Gefahr, dass der Browser aus der Domain *wpad.com*
fremdgesteuert werden kann, wenn ich nicht dafür sorge, dass in meiner
Second-Level-Zone ein *A* oder *CNAME* Eintrag existiert,
der auf einen Webserver mit ebendieser Datei verweist.

Zum Überprüfen kann ich die entsprechenden DNS-Anfragen von Hand eingeben und
mit *wget* oder *curl* versuchen die Datei ohne Verwendung eines Proxy-Servers
zu laden.


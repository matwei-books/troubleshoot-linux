
## quagga {#sec-netz-werkzeuge-quagga}

Einige Probleme im Netzwerk lassen sich auf fehlerhafte Routen zurückführen.
Die Routingtabelle des Kernels kann ich mit den Befehlen `netstat -rn`,
`route -n` oder `ip route show` schnell kontrollieren.
Stelle ich dabei eine fehlerhafte Route fest, ist meine nächste Frage: woher
kommt diese Route?
Bei der Beantwortung dieser Frage kann mir das Programm quagga helfen.

Quagga ist eine Programmsuite, die Protokolldämonen für die
Routingprotokolle RIP, OSPF, BGP und ISIS enthält. Die Konfigurationssprache
ist derjenigen von Cisco-Routern sehr ähnlich, so dass jemand, der diese
Geräte kennt, sich schnell hineinfindet.

Konfiguriert werden die Protokolldämonen entweder via telnet, über ein
Programm namens vtysh oder durch Editieren der Konfigurationsdateien im
Verzeichnis /etc/quagga und anschließenden Neustart der Protokolldämonen.

### interaktive Konfiguration

Bei der interaktiven Konfiguration via telnet und vtysh habe ich die
Möglichkeit, die interne Hilfefunktion als Gedächtnisstütze heranzuziehen.
Ausserdem werden Syntaxfehler sofort abgewiesen.
Der Befehl `list` listet alle momentan möglichen Befehle nebst Argument
auf.
Ein `?` an beliebiger Stelle zeigt die möglichen Fortsetzungen. Das
heißt, ein Fragezeichen am Zeilenanfang listet alle momentan möglichen
Befehle, ein Fragezeichen nach einem Befehl listet die möglichen nächsten
Argumente.
Befehle müssen nor soweit ausgeschrieben werden, dass sie eindeutig sind.
Das gleiche gilt für die Argumente.

Mit `<Ctrl-P>` erhalte ich die letzte Zeile, mit `<Ctrl-N>` die
nächste. An den Anfang der Zeile der Zeile komme ich mit `<Ctrl-A>`, an
das Ende mit `<Ctrl-E>`. Ausserdem funktionieren auf neueren Systemen
die Cursortasten und alle anderen Funktionen der libreadline.

Bei der interaktiven Arbeit mit den Protokolldaemonen habe ich drei Modi. Im
ersten, dem Operatormodus kann ich im wesentlichen nur Informationen über
den aktuellen Zustand und die Routen abfragen. Mit dem Befehl `enable`
gelange ich in den Administratormodus und mit `disable` komme ich
wieder zurück.
Im Administratormodus sehe ich mehr Informationen, vor allem kann ich die
aktuelle Konfiguration ansehen, sichern oder wiederherstellen.
Aus dem Administratormodus komme ich mit dem Befehl `configure terminal`
in den Konfigurationsmodus und aus diesem mit `end` oder `exit`
zurück in den Administratormodus.
Der Befehl `exit` im Administrator- oder Operatormodus beendet die
Sitzung.

Im Konfigurationsmodus kann ich jeden einzelnen Aspekt der Konfiguration
ändern. Dabei lassen sich einzelne Befehle zurücknehmen, indem sie mit
vorangestelltem `no` noch einmal eingegeben werden. Finde ich zum
Beispiel eine statische Route in der Konfiguration:

{line-numbers=off,lang="text"}
    zebra# ip route destination gateway

dann kann ich diese wie folgt entfernen:

{line-numbers=off,lang="text"}
    zebra# config t
    zebra(config)# no ip route destination gateway
    zebra# end

Auf die gleiche Art bearbeite ich auch ACL. Diese werden oft mit einer
Auffangregel am Ende abgeschlossen. Füge ich eine neue spezielle Regel an,
ist diese nicht aktiv, weil die Auffangregel nun davor steht. In diesem Fall
entferne ich die Auffangregel mit vorangestelltem `no` und füge sie
sofort wieder am Ende an.

### Protokollierung

Mit den `show ..` Befehlen kann ich mir den aktuellen Zustand des
Routingprotokolldämons ansehen. Das hilft mir oft schon, den Fehler
einzugrenzen. Suche ich aber nach der Ursache für den Fehler, dann benötige
ich Informationen darüber, wann etwas passiert ist. Dabei helfen mir die
`log` und `debug` Befehle. Mit dem `log` Befehl lege ich
fest, wohin die Routingdämonen protokollieren und mit den `debug`
Befehlen, was protokolliert wird. Je nach Routingprotokoll und eingestellter
Protokollierung können die Logdateien sehr schnell sehr unübersichtlich
werden. Dann helfen mir ein paar Zeilen Perl-Skript, die relevanten
Informationen herauszufischen und zusammenzusetzen.


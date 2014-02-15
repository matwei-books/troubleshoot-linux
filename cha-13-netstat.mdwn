
## netstat {#sec-netz-werkzeuge-netstat}

Dieses Programm setze ich auch bei manchen lokalen Problemen auf
Linux-Rechnern ein.
Daher habe ich es bereits im [Kapitel Werkzeuge](#sec-lokal-werkzeuge-netstat)
in Teil 2 dieses Buches beschrieben.
Hier gehe ich auf einige Aspekte ein, die beim Untersuchen von Netzproblemen
von Belang sind.

### Sockets

Rufe ich `netstat` ohne Argumente auf, liefert es mir eine Liste der
offenen und aktiven Sockets aller konfigurierten Adressfamilien, das
heisst, der bestehenden Verbindungen.

Meist interessieren mich nicht alle Adressfamilien, sondern nur ganz
bestimmte. Dann kann ich diese zum Beispiel mit der Option
`--protocol=$familie` einschränken. Für `$familie` kann ich in
einer durch Komma separierten Liste die folgenden angeben: `unix`,
`inet`, `ipx`, `ax25`, `netrom`, `ddp`. Alternativ
kann ich jeden gewünschten Familiennamen einzeln als Option übergeben:
`--unix`, `--inet`, und so weiter.

In diesem Teil der Buches interessiert mich vor allem die Familie
`--inet`. Diese kann ich weiter eingrenzen. Mit der Option `-4`
beziehungsweise `-6` beschränke ich die Ausgabe auf die entsprechende
Version des Internet Protokolls.

Außerdem verwende ich

--raw | -w
: wenn ich an Raw-Sockets interessiert bin,

--tcp | -t
: für TCP-Sockets, und

--udp | -u
: für UDP-Sockets.

Bin ich nur daran interessiert, ob überhaupt ein Prozess an einem bestimmten
Socket wartet, verwende ich die Option `--listening` beziehungsweise
`-l`. Diese werden bei der normalen Ausgabe weggelassen. Will ich
hingegen sowohl die aktiven als auch die lauschenden Sockets erfassen,
verwende ich die Option `--all` beziehungsweise `-a`.

### Routen

Wenn ich eher an den Routen als an den Sockets interessiert bin, verwende
ich die Option `--route` beziehungsweise `-r`. Damit bekomme ich
die gleiche Ausgabe, wie mit dem Befehl `route -e`. Auch hier kann ich
mit `-4` oder `-6` die Protokollversion einschränken.

Füge ich die Option `-C` hinzu, bekomme ich Informationen aus dem
Routencache, mit der Option `-F` stattdessen aus der Forwarding
Information Base (der Routentabelle), aber das ist sowieso die
Voreinstellung.

### Interfaces

Mit der Option `--interfaces` oder `-i` kann ich Informationen
über die Netzgeräte bekommen.

Ein einfaches `netstat -i` liefert mir in einer übersichtlichen Tabelle
zu jedem aktiven Interface unter anderem die MTU, die Anzahl der gesendeten
und empfangenen Datenpakete sowie die Anzahl der Sende- beziehungsweise
Empfangsfehler.

Kombiniere ich das mit `-e`, bekomme ich die gleiche Ausgabe wie vom
Program `ifconfig`. Kombiniert mit `-a` werden auch Interfaces
angezeigt, die nicht aktiviert wurden.

### Multicast-Gruppen

Die Option `--groups` beziehungsweise `-g` liefert mir
Informationen zur Mitgliedschaft des Rechners in Multicast-Gruppen.

### Statistiken

Mit der Option `--statistics` beziehungsweise `-s` zeigt netstat
zusammengefasste Statistiken für alle Protokolle.

### allgemeine Optionen

Abschließen möchte ich diese kleine Vorstellung von netstat mit ein paar
allgemeinen Optionen, mit denen ich die Ausgabe modifizieren kann.

Am häufigsten setze ich die Option `--numeric`, kurz `-n` ein.
Mit dieser Option zeigt netstat numerische statt symbolischer
Informationen an,
und das beschleunigt insbesondere bei Netzadressen die Anzeige immens,
weil sonst etliche DNS-Anfragen gestellt werden,
bevor die Ausgabe angezeigt werden kann.
Natürlich kann ich auch das selektiv einstellen mit
`--numeric-hosts`, `--numeric-ports` und `--numeric-users`.

Mit der Option `--verbose` oder `-v` bekomme ich mehr Informationen,
insbesondere zu nicht konfigurierten Adressfamilien.

Ähnliches bietet die Option `--extend` oder `-e`, die zusätzliche
Informationen zum Beispiel bei Interfaces liefert.

Gebe ich die Option `--continuos` oder `-c` an, bekomme ich die
Informationen aller Sekunde neu ausgegeben.


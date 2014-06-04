
## fuser {#sec-lokal-werkzeuge-fuser}

Das Programm `fuser` setze ich ein, wenn ich Informationen darüber
haben will, welche Prozesse bestimmte Dateien oder Netzwerksockets geöffnet
haben, um sie dann mit anderen Programmen zu untersuchen.
Zwar kann ich die ermittelten Prozesse gleich von `fuser` beenden lassen,
aber in diesem Buch geht es vor allem um die Fehleranalyse und dafür wäre
dieses Vorgehen doch zu voreilig.

Was mich vor allem interessiert, sind die Prozesse und die Art und Weise,
wie diese die betreffenden Dateien verwenden.
Die Prozesse zeigt `fuser` in einer Tabelle an.
In der ersten Spalte steht der Dateiname, dahinter die PID.
Mit der Option -v kann ich diese Ausgabe
erweitern, so dass `fuser` für jeden Prozess den Benutzer (USER), die PID, den
Zugriff (ACCESS) und den Namen des Prozesses (COMMAND) anzeigt.

Die Spalte ACCESS interessiert mich am meisten für die Analyse.
Diese kann die folgenden Merkmale haben:

*c*
: CWD, das Arbeitsverzeichnis des Prozesses.

*e*
: Executable, die Datei wird als Programm ausgeführt.

*f*
: File, die Datei ist als normale Datei geöffnet.

*F*
: File, die Datei ist zum Schreiben geöffnet.

*r*
: Root, die Datei ist Wurzelverzeichnis.

*m*
: MMAP, die Datei ist in den Speicherbereich des Prozesses
eingeblendet, zum Beispiel als Bibliothek.

Mit diesen Merkmalen bekomme ich heraus, wie ein Prozess eine Datei
verwendet.
Allerdings sehe ich das nur für Dateien, die im Dateisystem verlinkt sind.
Dateien, die zwar geöffnet, aber nicht mehr im Dateisystem verlinkt sind,
finde ich damit nicht, dafür benötige ich andere Programme, wie zum Beispiel
`lsof`.
Mit der Option `--mount` (`-m`) bekomme ich von `fuser` zumindest die
PID dieser Prozesse, und kann diese dann mit `lsof` näher untersuchen.

Dazu muss ich folgende Besonderheit der Ausgabe von `fuser` beachten.
Das Programm schreibt nur die PIDs an die Standardausgabe, alles andere kommt
über die Fehlerausgabe.
Damit kann ich die Ausgabe sehr bequem in Scripts weiterverarbeiten:

{line-numbers=off,lang="text"}
    for p in $(fuser -m /); do
        lsof -p $p
    done

Will ich die Ausgabe allerdings in einem Pager betrachten, oder
dokumentieren, so schreibe ich:

{line-numbers=off,lang="text"}
    fuser -m / 2>&1 | less

Außer für Dateien in Dateisystemen kann ich mit `fuser` auch die Prozesse
ermitteln, die bestimmte Sockets geöffnet haben.
Dazu wähle ich den entsprechenden Namensraum mit der Option `--namespace SPACE`
(`-n SPACE`) aus.
Das Programm kennt die folgenden Namensräume:

*file*
: ist der Standard-Namensraum, der nicht extra angegeben werden muss.

*tcp*
: steht für TCP-Sockets.

*udp*
: steht für UDP-Sockets.

Sockets werden nach dem folgenden Schema angegeben:

{line-numbers=off,lang="text"}
    [locport][,[remhost][,[remport]]][/namespace]

Den Namensraum kann ich angeben, wenn die Angabe eindeutig ist und ich
diesen nicht explizit mit `--namespace` angeben will.
Die Komma sind wichtig.
So zeigt `fuser ssh/tcp` alle Prozesse, die mit
dem lokalen Port 22 arbeiten, während `fuser ,,ssh/tcp` alle Prozesse mit
abgehender Verbindung zu diesem Port anzeigt.

Mit der Option `-4` beziehungsweise `-6` grenze ich die Ausgabe auf
die entsprechende Version des Internet-Protokolls ein.

Eher selten wende ich die Option `--kill` (`-k`) an, mit
der `fuser` ein Signal (ohne weitere Angaben: `SIGKILL`) an die
ermittelten Prozesse sendet.
Das Signal kann ich mit einem vorangestellten
Bindestrich (`-`) angeben, eine Liste der Signale bekomme ich mit
`--list-signals` (`-l`).

Zum Beispiel könnte ich mit

{line-numbers=off,lang="text"}
    fuser -k -HUP 22/tcp

alle SSH-Anmeldungen an diesem Rechner regulär beenden.
War auch ich via SSH angemeldet, habe ich mich damit selbst hinausgeworfen.

Falls ich eine CD-ROM aushängen will, kann ich mit

{line-numbers=off,lang="text"}
    fuser -k -m /media/cdrom

alle Prozesse, die auf die eingehängte CD-ROM zugreifen, beenden.
Falls unter /media/cdrom kein Dateisystem eingehängt war, werden alle Prozesse,
die das nächsthöhere Dateisystem (meist /) verwenden, beendet.
Das kommt einem unvermittelten Ausschalten des Rechners schon sehr nahe.
Darum gibt es, quasi als
Sicherheitsgurt für solche Fälle, die Option `--ismountpoint`
(`-M`), mit der alle Aktionen nur dann ausgeführt werden, wenn der
angegebene Dateiname ein Mountpoint ist.

Außerdem kann ich mit der Option `-w` das Senden des Signals auf Prozesse
einschränken, die eine Datei zum Schreiben geöffnet haben.
Das ist interessant, wenn ich ein Dateisystem
von read-write auf read-only umhängen will.


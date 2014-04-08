
## fuser {#sec-lokal-werkzeuge-fuser}

Das Programm `fuser` setze ich ein, wenn ich Informationen darüber
haben will, welche Prozesse bestimmte Dateien oder Netzwerksockets geöffnet
haben, um sie dann mit anderen Programmen näher zu untersuchen.
Zwar kann ich die ermittelten Prozesse gleich von `fuser` beenden lassen,
aber in diesem Buch geht es vor allem um die Fehleranalyse und dafür wäre
dieses Vorgehen doch etwas zu grobschlächtig.

Was mich vor allem interessiert, sind die Prozesse und die Art und Weise,
wie diese die betreffenden Dateien verwenden.
Die Prozesse bekomme ich von `fuser` in einer Tabelle angezeigt.
In der ersten Spalte
steht die Datei, dahinter die PID. Mit der Option -v kann ich diese Ausgabe
erweitern, so dass `fuser` für jeden Prozess den Benutzer (USER), die PID, den
Zugriff (ACCESS) und den Namen des Prozesses (COMMAND) anzeigt.

Von diesen ist die Spalte ACCESS für viele Analysen interessant.
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
Allerdings kann ich das nur für Dateien sehen, die noch im
Dateisystem verlinkt sind. Dateien, die zwar geöffnet, aber nicht mehr im
Dateisystem verlinkt sind, kann ich damit nicht finden.
Dazu benötige ich andere Programme, wie zum Beispiel `lsof`.
Mit der Option `--mount` (`-m`) bekomme ich aber von `fuser` zumindest die
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

Neben den Prozessen, die auf bestimmte Dateien zugreifen, bin ich manchmal
an den Prozessen interessiert, die irgendeine Datei in einem Dateisystem
geöffnet haben.
Dafür verwende ich die Option `--mount` (`-m`).
Welche Dateien konkret geöffnet sind, kann ich zwar damit noch nicht sagen,
aber das kann ich zum Beispiel ermitteln, wenn ich die mit `fuser` ermittelten
Prozesse mit `lsof` näher betrachte.

Außer bei Dateien in Dateisystemen kann ich mit `fuser` auch die Prozesse
ermitteln, die bestimmte Sockets geöffnet haben.
Dazu wähle ich den entsprechenden Namensraum mit der Option `--namespace SPACE`
(`-n SPACE`) aus.
Das Programm kennt die folgenden Namensräume:

*file*
: ist der Standardnamensraum, der nicht extra angegeben werden muss.

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
abgehender SSH-Verbindung anzeigt.

Mit der Option `-4` beziehungsweise `-6` kann ich die Ausgabe auf
die entsprechende Version des Internetprotokolls eingrenzen.

Eine Option, die ich eher selten anwende ist `--kill` (`-k`), mit
der `fuser` ein Signal (ohne weitere Angaben: `SIGKILL`) an die
ermittelten Prozesse sendet.
Das Signal kann ich mit einem vorangestellten
Bindestrich (`-`) angeben, eine Liste der Signale bekomme ich mit
`--list-signals` (`-l`).
Zum Beispiel könnte ich mit

{line-numbers=off,lang="text"}
    fuser -k -HUP 22/tcp

alle SSH-Anmeldungen an diesem Rechner beenden. War ich selbst via SSH
angemeldet, dann habe ich mich damit selbst hinausgeworfen.

Oder, falls ich eine CD-ROM aushängen will, beende ich mit

{line-numbers=off,lang="text"}
    fuser -k -m /media/cdrom

alle Prozesse, die auf die eingehängte CD-ROM zugreifen.
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

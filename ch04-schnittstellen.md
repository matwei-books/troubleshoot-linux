
## Schnittstellen von Programmen {#sec-unix-programmschnittstellen}

Bei der Fehlersuche auf Linux-Servern bewege ich mich fast die gesamte Zeit
auf der Kommandozeile und rufe die verschiedensten Programme auf.
Für das Aufrufen von Programmen selbst, brauche ich keine weiteren Kenntnisse.
Bei der Fehlersuche, ist es jedoch von Vorteil, wenn ich genau weiß,
wie ich mit einem Programm kommunizieren kann.
Reinhard Fößmeier erläutert in [[Foessmeier1991]](#bib-foessmeier1991)
die verschiedenen Schnittstellen von Programmen unter UNIX sehr ausführlich.

### Kommandozeile

Die Kommandozeile bezeichnet Fößmeier als K-Schnittstelle.
Diese besteht aus einer Reihe von Parametern, die als C-Strings übergeben werden
und die jedes Programm beim Aufruf erhält.
Das Programm `strace` zeigt diese als Parameter beim `execve()` Systemaufruf an.

Mit dieser Schnittstelle kann ich nur in einer Richtung kommunizieren: von der
Aufrufumgebung zum Programm.

Wenn ich Shell-Skripts schreibe, kann ich auf diese Parameter mit den
Variablen `$0`, `$1`, ... zugreifen. In `$#` habe ich die Anzahl der beim
Aufruf übergebenen Parameter.

In C-Programmen bekommt die Funktion `main()` als ersten Parameter die Anzahl
und als zweiten Parameter einen Zeiger auf das Parameterfeld.

Prinzipiell gibt es keine Regeln für die Gestaltung dieser Parameter.
Es hat sich aber eine Konvention herausgebildet, die von vielen Programmen
eingehalten wird und für die es Unterstützung bei der Programmierung durch
einige Bibliotheken gibt. Nach dieser Konvention werden Parameter in folgende
Gruppen eingeteilt:

Optionen
: bestehen oft aus einem Bindestrich, dem ein einzelnes Zeichen
  folgt. Diese werden unterschieden in Wertoptionen, denen ein Wert
  nachfolgt und Schaltoptionen, deren bloßes Vorhandensein ausreicht.

  Neben den alten Optionen, die aus einem Zeichen bestehen, gibt es seit
  geraumer Zeit lange Optionen, die oft mit zwei Bindestrichen,
  manchmal mit einem `+` oder, seltener, mit einem Bindestrich eingeleitet
  werden.

Werteparameter
: folgen einer Wertoption und beinhalten den zur Option gehörigen Wert.
  Diese Werteparameter können bei den kurzen Optionen direkt anschließen oder
  als nächster Parameter übergeben werden.

  Bei den langen Optionen werden Werteparameter entweder mit einem `=` direkt
  an die Option angefügt oder als nächster Parameter angegeben.

Namensparameter
: stellen oft Namen von Dateien dar, die vom Programm bearbeitet werden
  sollen.

Um Verwechslungen von Namensparametern mit Optionen auszuschließen, gibt es
die Konvention, dass alle Parameter nach `--` als Namensparameter verarbeitet
werden, um so auch Dateien bearbeiten zu können, deren Name mit einem
Bindestrich beginnt.

### Umgebungsvariablen

Umgebungsvariablen bezeichnet Fößmeier als U-Schnittstelle.
Im Gegensatz zur K-Schnittstelle, deren Parameter positionsabhängig sind,
kann ich diese Variablen nur über ihren Namen ansprechen.

Auch mit dieser Schnittstelle kann ich nur von der Aufrufumgebung in Richtung
aufgerufenes Programm kommunizieren.

In Shell-Skripts kann ich auf diese Variablen, genau wie auf lokale
Variablen über den Namen mit vorangestelltem `$` zugreifen.

Wie ich Umgebungsvariablen für ein aufgerufenes Programm setze, hängt
von der verwendeten Shell ab.
Bei der POSIX-Shell und den damit kompatiblen geschieht das durch einfache
Zuweisung `variable="wert"`.
Die Anführungszeichen um den Wert sind notwendig, wenn dieser Leerzeichen
enthält.
Für die Übergabe an aufgerufene Programme habe ich zwei Möglichkeiten:

*   Ich kennzeichne die Variable mit der Anweisung `export`, was für die
    Shell dem Befehl gleich kommt, diese Variable an alle nachfolgend
    aufgerufenen Programme zu übergeben.

{line-numbers=off,lang="text"}
            TERM=vt100
            export TERM
            ssh server1

*   Alternativ setze ich die Variable unmittelbar vor Aufruf des Programmes in
    derselben Zeile.
    In diesem Fall gilt der Variablenwert nur für den in dieser Zeile
    gestarteten Prozess.

{line-numbers=off,lang="text"}
         TERM=vt220 ssh server2

Da die Kommunikation nur in einer Richtung geht, gibt es keine Möglichkeit,
für ein aufgerufenes Programm, die Umgebungsvariablen des aufrufenden
Prozesses zu ändern.
Bei Shellprogrammen kann ich dafür auf einen Trick zurückgreifen, bei dem die
Shell die Ausgabe des aufgerufenen Programms interpretiert und dieses die
Zuweisung an Variablen in die Standardausgabe schreibt.

{line-numbers=off,lang="text"}
    $ echo $abc
    $ eval $(/bin/echo abc=def)
    $ echo $abc
    def

### Rückgabewert

Wenn ein Prozess durch Aufruf von `exit()` endet, kann er einen ganzzahligen
Wert als Statuscode angeben. Dieser Statuscode und der Zeitpunkt zu dem der
Prozess endet bilden die R-Schnittstelle.

Die Shell und das Programm `make` zum Beispiel werten diesen Statuscode aus.
Ein Wert von `0` wird dabei als erfolgreiche Beendigung des
Programms gewertet, alle anderen Codes deuten auf ein Problem und sind
abhängig vom aufgerufenen Programm.

In der Shell kann ich den Statuscode des letzten aufgerufenen Programms in der
Variable `$?` abfragen.
In C-Programmen durch Aufruf der Funktion `wait()`.

Starte ich ein Shell-Skript mit der Option `-e`, bricht die Shell die
Abarbeitung ab, sobald ein aufgerufenes Programm einen anderen Rückgabewert
als `0` hat.
Das ist auch das Standardverhalten von `make`.

### Datenströme

Die S-Schnittstelle fasst alle Schnittstellen zusammen, die aus einem Strom
von Zeichen bestehen.
Das können die Standard-Datenströme sein (STDIN, STDOUT, STDERR) oder weitere
geöffnete Dateien, Sockets oder Pipes.

Auf der Kommandozeile sind insbesondere die Standard-Datenströme relevant,
da ich einzelne Programme damit verketten kann, so dass jedes folgende
Programm die Standardausgabe (STDOUT) des vorigen Programms als
Standardeingabe (STDIN) bekommt.

Im folgenden Beispiel liest das Programm `tail` fortlaufend aus einer Logdatei
und übergibt seine Ausgabe dem Programm `grep` als Eingabe, welches alle
Zeilen ignoriert bis auf diejenigen, die das Wort *CRON* enthalten:

{line-numbers=off,lang="text"}
    $ tail -f /var/log/syslog | grep CRON

Prinzipiell kann über eine S-Schnittstelle ein unbegrenzter Strom von Daten
übertragen werden, wie in obigem Beispiel.

Mit *Dateiende* (EOF) wird zu einem Datenstrom übermittelt, dass keine
weiteren Daten mehr folgen.
In diesem Fall kann ein Programm angemessen reagieren und sich beispielsweise
beenden:

{line-numbers=off,lang="text"}
    $ zcat /var/log/syslog* | grep CRON

In diesem Beispiel liest das Programm `zcat` alle Dateien aus dem Verzeichnis
*/var/log*, deren Name mit *syslog* beginnt und sendet ihren Inhalt wie im
Beispiel davor an `grep`.
Nachdem es den Inhalt aller Dateien zur Standardausgabe geschickt hat,
beendet sich `zcat`, wobei seine Standardausgabe geschlossen wird.
Der Kernel übermittelt das als *Dateiende* bei STDIN an `grep`, welches sich
daraufhin ebenfalls beendet.

Schreibe ich Daten von Hand in die Standardeingabe eines Prozesses, kann
ich mit *CTRL-D* die Dateiendeinformation für den lesenden Prozess erzeugen.

### Dateien

Die N-Schnittstelle entspricht dem Inode, der eine Datei in einem Dateisystem
beschreibt. Diese Schnittstelle enthält Metainformationen über die betreffende
Datei, aber nicht die Daten selbst.
Ich verwende diese Schnittstelle um die Verwaltungsinformationen der Dateien
abzufragen oder zu ändern.

Bei Gerätedateien kann ich darüber auch Einstellungen an den
betreffenden Geräten vornehmen.

### Text-Terminal

Die T-Schnittstelle bezeichnet das Treiberprogramm für das Text-Terminal über
das ich meine Eingaben mache und die Ausgaben angezeigt bekomme. Dabei kann
das Terminal eine normale Computerkonsole sein, eine serielle Konsole oder ein
Programm wie Xterm.

Diese Schnittstelle sorgt dafür, dass beim traditionellen Zeilenendezeichen
(LF) automatisch ein Wagenrücklauf (CR) ausgeführt wird,
damit die nächste Zeile wieder am linken Rand beginnt.
Im Cooked Mode sammelt diese Schnittstelle meine Eingabe bis zum
*RETURN* um sie dann als ganze Zeile an den Prozess zu schicken.

Auf der Kommandozeile kann ich über das Programm `stty` auf diese
Schnittstelle zugreifen und sie bearbeiten.
In *C* Programmen verwende ich die Funktion `ioctl()`.


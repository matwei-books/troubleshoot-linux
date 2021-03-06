
## GDB der GNU Debugger {#sec-lokal-werkzeuge-gdb}

GDB ist ein mächtiges Werkzeug, das ich in extrem schwierigen Fällen einsetze.
Vorzugsweise, wenn ich nachträglich die Ursache eines
Programmabsturzes ermitteln will oder wenn ich einen Programmfehler vermute
und finden will.

Um mit dem Debugger zu arbeiten benötige ich Zugriff auf die Quellen, aus
denen das Programm übersetzt wurde[^gdb-machine-code].
Außerdem brauche ich die Symboltabellen des Programms damit der Debugger die
Maschinenbefehle des Binärprogramms den Quellcodezeilen zuordnen kann.
Diese gibt es, wenn beim Übersetzen des Programms mit dem
Compiler `gcc` die Option `-g` angegeben wurde.
Bei vielen Softwarepaketen
kann ich die Symboltabellen über das entsprechende Paket mit der Endung
`-dbg`, zum Beispiel `avahi-dbg` für `avahi`, installieren.

[^gdb-machine-code]: Zwar ist es auch möglich, direkt die Maschinenbefehle
                     zu verfolgen, aber das liegt definitiv jenseits des
		     Horizonts dieses Buches.

Um einen Prozess postmortal zu analysieren, muss ich das System anweisen, ein
Corefile zu schreiben, das den Zustand des Prozesses beim
Programmabsturz enthält.
Dazu kann ich in der Bash mit dem Befehl `ulimit -c $size` die
maximale Größe des Corefiles festlegen, die das Betriebssystem schreibt.
Diese muss ich hoch genug wählen, damit das Corefile groß genug für den
gewünschten Prozess werden kann.

Ich kann den GNU Debugger auf verschiedene Arten starten:

*gdb $options $program [$core]*
: So starte ich, wenn ich einen Prozess postmortal analysieren will
  (mit `$core`) oder, wenn ich ein Programm nur beim Ablauf verfolgen will
  (ohne `$core`). Dabei ist `$program` der Name der Programmdatei und
`$core` der Name des Corefiles.

*gdb $options --args $program $arguments*
: Hier gebe ich dem
  Programm, dass ich beobachten will gleich die Kommandozeilenargumente
  beim Aufruf des GDB mit.

*gdbtui $options*
: Das startet den GDB mit einer
  Textbenutzeroberfläche, bei der im oberen Teil der Quelltext
  angezeigt wird und im unteren Teil die Befehle und Ausgaben des GDB.

Von den Optionen, die GDB beim Aufruf mitgegeben werden können, sind die
folgenden für die Fehlersuche relevant. Weitere bekomme ich aus der
Handbuchseite, der GDB-Texinfo-Datei oder mit `gdb -help`.

-c $file | -core $file
: Damit gebe ich das Corefile bei den Optionen
  an und brauche es nicht mehr nach dem Programmnamen anzugeben.

-e $file | -exec $file
: Gibt das ausführbare Programm an.

-s $file | -symbols $file
: Gibt die Datei mit den Symboltabellen an.
  Die Optionen `-s` und `-e` können auch zu `-se`
  zusammengefasst werden, wenn die Symboltabellen noch in der
  Binärprogrammdatei enthalten sind.

-help
: Listet alle Optionen mit einer kurzen Erläuterung auf.

Nachdem ich GDB gestartet habe, steuere ich den Ablauf der Sitzung mit
Textbefehlen.
Alle diese Befehle kann ich soweit abkürzen, wie sie noch eindeutig sind.
Die wichtigsten Befehle für die Fehlersuche sind:

break $function | break $file:$function
: So ziemlich als erstes rufe
  ich in einer Debuggingsitzung `break main` auf, damit der Debugger
  an dieser Funktion anhält und ich anschließend das Programm in Ruhe
  analysieren kann. Vor einer Funktion kann ich, durch `:` getrennt
  die Datei angeben, falls der Debugger momentan eine andere geladen hat.

run | run $arglist
: Damit starte ich das Programm im Debugger.
  Optional kann ich dem Prozess mit `$arglist` Kommandozeilenargumente mitgeben.

bt
: Dieser Befehl zeigt den Programmstack an. Bei einer postmortalen
  Analyse eines Prozesses rufe ich diesen Befehl als erstes auf, um
  herauszubekommen, wo das Programm abgestürzt ist.

print $expr
: Mit `print` lasse ich mir die Werte in den
  Variablen und verschiedene andere Daten ausgeben. Dabei kann
  `$expr` ein komplexer C-Ausdruck sein.

c
: Mit `c` (continue) läuft das Programm weiter bis zum
nächsten Haltepunkt oder bis zum Programmende.

next
: Dieser Befehl arbeitet die nächste Zeile im Quelltext ab.
Dabei werden Funktionsaufrufe ausgeführt und übersprungen.

step
: Auch dieser Befehl arbeitet die nächste Zeile im Quelltext ab,
der Debugger folgt hier allerdings Funktionsaufrufen in das Innere der
Funktion.

list | list $function | list $file:$function
: Zeigt die aktuelle
Programmumgebung beziehungsweise die angegebene Funktion im Quelltext.

help $befehl
: Gibt die Hilfe zu dem angegebenen Befehl aus.

quit
: Beendet die Debuggersitzung.

GDB ist ein mächtiges Werkzeug für die Fehlersuche und sehr komplex in der
Anwendung.
Da die Bedienung nicht einfach ist und es auch einiger Vorkehrungen für den
erfolgreichen Einsatz bedarf, setze ich es selten ein, quasi als Ultima Ratio.
Trotzdem ist es sinnvoll, sich gelegentlich hinzusetzen und zum Test das eine
oder andere Programm im Debugger zu beobachten und zu analysieren, damit es
im Ernstfall einfacher von der Hand geht.

X> Installiere die Debug-Informationen (Paket mit Endung `-dbg`) für ein
X> einfaches Programm wie `ls` oder kompiliere ein Programm selbst mit
X> Debug-Informationen.
X> 
X> Verfolge anschließend den Ablauf des Programms mit `gdb` oder `gdbtui`.



## ltrace {#sec-lokal-werkzeuge-ltrace}

Ltrace ist, ähnlich [strace](#sec-lokal-werkzeuge-strace),
ein Programm, mit dem ich einem Prozess bei der
Arbeit zusehen kann. Im Gegensatz zu strace, welches nur die
Kernel-Schnittstelle beobachtet, zeigt ltrace den Aufruf von
Bibliotheksfunktionen.

Beim Start eines Programmes via ltrace läßt dieses den Prozess laufen, bis
es endet. Dabei fängt ltrace Aufrufe von Bibliotheksfunktionen durch den
Prozess und Signale an den Prozess ab und zeigt sie auf STDERR an. Das ist
in etwa das Gleiche, was auch strace macht. Da aber ltrace
Bibliotheksaufrufe abfängt, ist die Ausgabe viel feiner granuliert und
umfangreicher.

Die folgenden Optionen sind für die Fehlersuche mit ltrace interessant. Für
eine komplette Liste der Optionen verweise ich auf die Handbuchseite.

*-S*
: Mit dieser Option zeigt ltrace zusätzlich zu den Bibliotheksaufrufen auch
  Systemaufrufe an der Kernelschnittstelle.
  Diesen wird in der Ausgabe `SYS_` vorangestellt.

*-L*
: Diese Option ist nur zusammen mit `-S` sinnvoll, da sie die Ausgabe der
  Bibliotheksaufrufe unterdrückt.
  Mit beiden Optionen zusammen zeigt ltrace etwa das gleiche an wie strace,
  der auffälligste Unterschied ist das vorangestellte `SYS_` bei ltrace.

*-e expr*
: Damit kann ich die Ereignisse und Funktionen einschränken, die angezeigt
  werden sollen.
  Funktionen, die ich nicht sehen will, kennzeichne ich mit vorangestelltem `!`.
  So kann ich zum Beispiel mit `ltrace -e malloc,free` nachschauen, ob
  angeforderter Speicher auch wieder freigegeben wird.
  Das interessiert mich insbesondere bei lange laufenden Prozessen.

*-f*
: Diese Option bewirkt, genau wie bei strace, das auch Kindprozesse mit
  beobachtet werden.

*-o dateiname*
: Damit gibt ltrace, genau wie strace, die Ausgabe in die angegebene Datei
  anstatt zu STDERR aus.

*-p pid*
: Mit dieser Option kann ich, wie bei strace, einen bereits laufenden
  Prozess untersuchen.

*-i*
: Mit dieser Option zeigt ltrace den Befehlszeiger zu jedem Funktionsaufruf.

*-r*
: Damit fügt ltrace relative Zeitstempel in die Ausgabe, mit denen ich die
  Verzögerungen durch Timeouts genauer eingrenzen kann.

*-T*
: Mit dieser Option zeigt ltrace die Zeit, die für die Funktionsaufrufe
  benötigt wurde.

*-l dateiname*
: Diese Option erlaubt mir, die Beobachtung einzuschränken auf
  Funktionsaufrufe aus der angegebenen Bibliothek.
  Ich muss den kompletten Pfad zur Bibliothek angeben.
  Welche Bibliotheken ein Programm verwendet, bekomme ich mit ldd heraus.
  Wenn ich an mehreren Bibliotheken interessiert bin, kann ich diese Option
  mehrfach angeben.


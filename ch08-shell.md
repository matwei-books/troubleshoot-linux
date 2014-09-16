
## Shell {#sec-lokal-werkzeuge-shell}

Die Shell ist für mich ein wichtiges Hilfsmittel bei der Fehlersuche.
Dies in
zweierlei Hinsicht: zum einen starte ich in einer interaktiven Shell die
Kommandos, mit denen ich den Fehler eingrenzen will, zum anderen verwende
ich die Shell für simple, schnell zusammengeschriebene Programme, die mich bei
der Fehlersuche unterstützen.

Bei der Arbeit auf der Kommandozeile bevorzuge ich eine Shell mit
History-Funktion und Kommandozeilenergänzung (command line completion).
Die History-Funktion benutze ich, um bereits ausgeführte
Befehle wieder hervorzuholen, gegebenenfalls geringfügig zu ändern und noch
einmal auszuführen. Die Kommandozeilenergänzung beschleunigt den Zusammenbau
von neuen Befehlen, indem die Shell, meist nach Eingabe von `<TAB>`,
die Zeile komplettiert oder die nächsten Argumente vorschlägt, wenn mehrere
Vervollständigungen möglich sind.
Das halte ich für unverzichtbar, um den Gedankenflug nicht
abreißen zu lassen.
Ich bin an die Bash gewöhnt, aber andere Shells können das ebensogut.

Für Shell-Scripts bevorzuge ich als kleinsten gemeinsamen Nenner die POSIX
Shell (`/bin/sh`).
Auf manchen Systemen ist das nur ein Link auf die Bash.
Das ist kein Problem, weil diese in der Lage ist, POSIX Shell-Skripts
auszuführen.
Da aber nicht jede POSIX-kompatible Shell in der Lage ist, Bash-Erweiterungen
zu verstehen, beschränke ich mich auf den kleinsten gemeinsamen Nenner,
um auf der sicheren Seite zu sein, wenn das Skript in einer anderen
Umgebung läuft.

Ich will hier keine komplette Einführung in die Programmierung mit der
POSIX Shell geben, sondern verweise stattdessen auf die Handbuchseiten und
die Beschreibung im Standard [[POSIX.1-2008](#bib-posix1-2008)].
Stattdessen stelle ich ein Skript vor, das ich bereits mehrfach für die
Fehlersuche verwendet habe

### Strace Invocator

Bei einem schwierigen Problem greife ich oft auf
[strace](#sec-lokal-werkzeuge-strace) zurück,
um den Prozess bei der Arbeit zu beobachten.
Wenn dieser Prozess jedoch nicht von Kommandozeile,
sondern von einem anderen Prozess gestartet wird, verwende ich folgenden
Trick: Ich benenne das Programm um, indem ich an den Namen die Endung
`.orig` anhänge. Unter dem ursprünglichen Programmnamen platziere ich
einen Link auf dieses Skript:

<<[strace-invocator](code/strace-invocator.sh)

In Zeile 2 bestimme ich den Namen des aufgerufenen Programms und in Zeile 3
den Namen des eigentlichen Programms.

In Zeile 4 bis 9 definiere ich eine Funktion, mit der ich das Skript mit
Fehlermeldung und -code beenden kann.

In Zeile 10 teste ich, ob das Originalprogramm da und ausführbar ist und
breche andernfalls ab. Dazu nutze ich die oben definierte Funktion.

In Zeile 11 lege ich ein temporäres Verzeichnis mit eindeutigem Namen an.
Damit kann ich mich bei der Auswertung in aller Ruhe auf jeden einzelnen
Aufruf des Programms konzentrieren.

In den Zeilen 12 bis 20 halte ich verschiedene Informationen zum Aufruf
fest. Und zwar die aktuelle Zeit, die übergebenen Argumente, die
Benutzer-Id, unter der der Prozess läuft und die Umgebungsvariablen.

In Zeile 21 schließlich rufe ich via strace das Originalprogramm mit allen
Argumenten auf. Diesen Aufruf kann ich noch modifizieren, wenn ich an der
Standardeingabe für das Programm interessiert bin:

{line-numbers=off,lang="bash"}
    tee $tmpdir/stdin \
      | strace -f -o $tmpdir/strace.out $origin "$@"

Oder, wenn ich sowohl an der Standardeingabe als auch an der Standardausgabe
interessiert bin:

{line-numbers=off,lang="bash"}
    tee $tmpdir/stdin \
    | strace -f -o $tmpdir/strace.out $origin "$@" \
    | tee $tmpdir/stdout

### Fehler in Shell-Skripts suchen

Manchmal habe ich ein Problem in einem Shell-Skript selbst.
Dann hilft es, die Shell mit der Option `-x` zu starten,
um zu sehen, wie sie das Skript abarbeitet.

Als Beispiel nehme ich ein Skript, das mir ausgibt, in welchem
Verzeichnis ich mich gerade befinde und zu welchem Projekt dieses gehört:

    #!/bin/sh
    HERE=$PWD
    echo "($HERE)"
    while test "/" != "$HERE"; do
      if [ -f "$HERE/.project" ]; then
    	echo "===" $(cat "$HERE/.project") "==="
    	break
      fi
      HERE=$(dirname $HERE)
    done

Die Ausgabe des Skripts sieht beispielsweise so aus:

{line-numbers=off,lang="bash"}
    $ where
    (/home/mathias/A/2012/12/07/t1)
    === GDB Tests ===

Mit Shell-Debugging dagegen so:

{line-numbers=off,lang="bash"}
    $ sh -x ~/bin/where
    + PROJECT=.project
    + HERE=/home/mathias/A/2012/12/07/t1
    + echo (/home/mathias/A/2012/12/07/t1)
    (/home/mathias/A/2012/12/07/t1)
    + test / != /home/mathias/A/2012/12/07/t1
    + [ -f /home/mathias/A/2012/12/07/t1/.project ]
    + dirname /home/mathias/A/2012/12/07/t1
    + HERE=/home/mathias/A/2012/12/07
    + test / != /home/mathias/A/2012/12/07
    + [ -f /home/mathias/A/2012/12/07/.project ]
    + cat /home/mathias/A/2012/12/07/.project
    + echo === GDB Tests ===
    === GDB Tests ===
    + break
    
Damit sehe ich genau, was beim Abarbeiten des Skripts passiert.
Alle Variablenzuweisungen mit den zugehörigen Werten sowie die Befehlsaufrufe
mit ihren Argumenten stehen auf je einer Zeile, die mit `'+ '` eingeleitet wird.

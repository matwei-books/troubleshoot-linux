
## C (Programmiersprache)

Als Systemadministrator setze ich die Programmiersprache C selten direkt ein.
Gut, zugegeben, ich nutze mein Verständnis dieser Programmiersprache, wenn ich
die Ausgabe von strace auswerte.
Aber das hätte ich auch ohne dieses Wissen hinbekommen.
Wenn ich einen Fehler im Debugger suche, möchte ich die Sprache ebenfalls
kennen, aber auch das mache ich als Systemadministrator sehr selten.

Ich nutze es, wenn ich einem Fehler in einem C-Programm nachspüre und keine
Gelegenheit habe, mit dem Autor des Programms in Kontakt zu treten.
Meist aber, wenn ich ein Werkzeug benötige, das Informationen direkt vom Kernel
abgreift oder mit ihm interagiert.
Dann ist C das Mittel der Wahl, weil es die Sprache ist, die im Kernel
selbst verwendet wird, so dass ich die gleichen Datenstrukturen wie der Kernel
in meinem Programm verwenden kann.

Natürlich kann ich mir damit gewaltig in den Fuß schießen, deshalb setze
ich die Programmiersprache so defensiv wie möglich ein.
Zum Beispiel, wenn ich in meiner bevorzugten
Skriptsprache keine Entsprechung für die benötigte Systemfunktion habe.
Oder, wenn ich ein Programm finde, das in etwa das macht, was ich will,
und nur noch etwas modifiziert werden muss, wie das folgende Beispiel,
das auf [[ctDiedrich2012](#bib-ct-diedrich2012)] zurückgeht.

Dieses Minimalprogramm überwacht Zugriffe auf die Dateien in einem
Verzeichnis mit der Systemfunktion *fanotify* und gibt die PID des Prozesses
aus, der auf die Datei zugreift, sowie den Dateideskriptor der Datei in diesem
Prozess.
Will ich mehr über den Prozess erfahren, kann ich mit `lsof` alle von ihm
geöffneten Dateien herausbekommen, oder mit `strace` seine Systemaufrufe
überwachen.

{lang="c"}
<<[fnotify.c](code/fnotify.c)

Mit `gcc -o fnotify fnotify.c` übersetze ich das Programm.

Für die Systemaufrufe benötigt das Programm die POSIX Capability
*CAP_SYS_ADMIN*, die ich ihm gebe, wie in Kapitel 6 erläutert.
Anschließend kann ich das Programm aufrufen und zum Test in einer anderen
Konsole eine Datei in diesem Verzeichnis öffnen.

{line-numbers=off,lang="text"}
    $ sudo setcap cap_sys_admin=ep fnotify
    $ ./fnotify .
    PID: 5021, FD: 4, M: 0x20

Mit `lsof` schaue ich nach, welches Programm welche Datei geöffnet hat:

{line-numbers=off,lang="text"}
    $ lsof -p5021
    COMMAND...  FD   TYPE...NAME
    less   ... txt    REG.../bin/less
    ...
    less   ...   4r   REG.../home/.../code/fnotify.c

In diesem Beispiel habe ich in einer zweiten Konsole den Quelltext mit `less`
betrachtet, was mir `lsof` in einer weiteren Konsole anzeigt.

Fanotify bietet noch weitergehende Möglichkeiten.
So kann ich den Prozess blockieren und den Zugriff erlauben oder verbieten.
Oder ich modifiziere die Datei vor dem Zugriff.
Eine ausführliche Behandlung dieser Systemschnittstelle würde den Rahmen
dieses Buches sprengen, aber es ist in manchen Fällen gut zu wissen, dass
sich da noch etwas machen lässt.


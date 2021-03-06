
## Magic SysRequest {#sec-lokal-total-magic-sysrq}

Einem Totalausfall recht nahe kommt der Zustand, wenn ein oder mehrere
Prozesse so viele Ressourcen belegen, dass andere Prozesse kaum noch zum Zuge
kommen.

Erkennbar ist das zum Beispiel daran, dass Verbindungen über das Netz scheinbar
noch funktionieren, der Rechner auf Ping antwortet, die Dienste des Rechners
eventuell noch neue Verbindungen annehmen aber keine Antworten senden.
An der Konsole kann ich beim Login noch Benutzername und Kennwort eingeben.
Aber die Prüfung des Kennworts dauert so lange, dass sie durch Timeout
abgebrochen wird.
In einer Shell kann ich Befehle absetzen, aber ein Befehl,
der einen neuen Prozess startet, dauert ewig.

Habe ich bereits einen Systemmonitor laufen, zeigt dieser mir mindestens
eines dieser Symptome: die CPUs sind 100 Prozent ausgelastet, der
Hauptspeicher ist voll, das System lagert ständig Speicherseiten aus und
die Systemlast (die Anzahl der Prozesse, die auf Rechenzeit warten) ist sehr
hoch.

Mit normalen Mitteln werde ich dieser Situation nicht mehr Herr, da ich
nicht genug Einfluss nehmen kann.
Als letzter Ausweg bliebe hier nur ein hartes Ausschalten des Systems mit den
entsprechenden Folgen, wie Fehlern im Dateisystem und beschädigten Dateien.
Bei einer sehr großen Platte würde es allein wegen des Dateisystemchecks ewig
dauern, bis das System wieder einsatzfähig wäre.

Hier hilft mir der Magic SysRequest, wenn ich Zugang zur Konsole habe.
Der Magic SysRequest besteht aus der Tastenkombination `<Alt>` plus
`<Druck>` plus einer weiteren Taste, die eine bestimmte Funktion auslöst.

Um ein hängendes System geordnet neu zu starten, halte ich
`<Alt>` und `<Druck>` gedrückt und drücke dann nacheinander, mit
jeweils einigen Sekunden Abstand die Tasten `r`, `e`, `i`,
`s`, `u`, `b`. Als Eselsbrücke kann ich mir das Wort busier
(geschäftiger) rückwärts merken.

Die genannten Schlüsseltasten bewirken das folgende:

| r | X11 die Tastatur entziehen                           |
| e | alle Prozesse außer Prozess 1 mit SIGTERM beenden    |
| i | alle Prozesse außer Prozess 1 mit SIGKILL abschießen |
| s | alle Dateisystempuffer auf Platte schreiben          |
| u | alle Dateisysteme nur-lesend einhängen               |
| b | Neustart                                             |

Insbesondere die letzten drei Funktionen bewirken, dass der Kernel die
Dateisysteme vor dem Neustart sauber aushängt.
Damit sollte der Dateisystemcheck fehlerfrei laufen.
Mit dem zweiten Befehl (`e`) haben die Prozesse zumindest die Chance,
ihre geöffneten Dateien sauber zu schließen.
Dazu ist die Pause von einigen Sekunden vor dem nächsten Befehl (`i`)
notwendig.

Außer diesen sechs Funktionen bietet der Magic SysRequest noch weitere, deren
Beschreibung ich in der Datei *sysrq.txt* in der Kerneldokumentation finde.

Damit Magic SysRequest überhaupt zur Verfügung steht, muss dieses Feature im
Kernel kompiliert sein.
Das ist bei den Kerneln der meisten Distributionen der Fall.
Die entsprechende Konfigurationsvariable heisst `CONFIG_MAGIC_SYSRQ`.
Außerdem muss es aktiviert sein.
Über die Datei */proc/sys/kernel/sysrq* kann ich das kontrollieren.
Steht in dieser 0, ist Magic SysRequest deaktiviert.
Bei einer 1 sind alle Funktionen aktiv, bei einer höheren Zahl erfahre ich aus
der oben erwähnten Datei *sysrq.txt*, welche Funktionen aktiv sind.

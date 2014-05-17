
## Die ersten Minuten auf dem Server {#sec-local-erste-minute}

Manche Informationen frage ich fast immer ab, wenn ich mich an einem Server
anmelde.
Damit bekomme ich einen intuitiven Einblick in den Allgemeinzustand des
Servers und eventuell weitere Hinweise.

### uptime, w, last - Zeit, Systemlast, Benutzer

Das Programm `uptime` zeigt mir neben der Systemzeit, wie lange der
Systemstart zurückliegt, wieviel Benutzer angemeldet sind und die
durchschnittliche Systemlast der letzten, der letzten fünf und
der letzten fünfzehn Minuten.

Eine Abweichung der Systemzeit erschwert die Korrelation von Lognachrichten.
Außerdem kann sie bei einigen kryptographischen Protokollen, wie zum Beispiel
*kerberos*, die Verbindung stören.

Die Zeit seit dem letzten Neustart weist auf vorangegangene Probleme hin,
wenn sie unerwartet kurz ist, weil der Rechner außerplanmäßig neu
gestartet wurde.

Die Anzahl der Benutzer zeigt mir an, ob ich mit jemand Kontakt aufnehmen
muss, bevor ich schwerwiegende Eingriffe in das System vornehme.

Die Last schließlich zeigt an, wieviel Prozesse in dem betreffenden
Zeitraum durchschnittlich auf Rechenzeit gewartet haben.
Ein Durchschnittswert, der kleiner ist als die Anzahl der Prozessoren
bedeutet, dass die Prozessoren Freilauf hatten, der Server nicht
ausgelastet war.
Ist der Durchschnittswert größer als die Anzahl der Prozessoren bedeutet das,
dass während des betreffenden Zeitabschnitts mehr Rechenleistung benötigt
wurde als zur Verfügung stand.
In diesem Fall ist der Trend interessant, den ich durch Vergleich der Last
für die drei Zeiträume erkennen kann.
Bei steigender Last versuche ich für Entlastung zu sorgen.
Ist der Trend fallend, brauche ich nichts unmittelbar zu unternehmen, außer
die Last weiter im Auge zu behalten.
Das System kommt nach einer Lastspitze gerade von selbst wieder in den
normalen Betriebsbereich.
Natürlich werde ich versuchen die Ursache der Lastspitze zu ermitteln, um zu
entscheiden, welche präventiven Maßnahmen ich für die Zukunft ergreifen will.

Eine Alternative zu *uptime* ist das Programm `w`,
das in der ersten Zeile die gleichen Daten wie *uptime* anzeigt.
In den nachfolgenden Zeilen zeigt es, wer gerade angemeldet ist, wann er das
letzte Mal etwas eingegeben hat und welches Programm er zuletzt aufgerufen hat.
Damit weiß ich, mit wem ich Kontakt aufnehmen muss, falls jemand
anderes angemeldet ist.
Das Programm `w` entnimmt, ebenso wie das Programm `who` die Informationen
über angemeldete Benutzer der Datei */var/log/utmp*.

Falls ich den Beginn des Problems mit letzten Änderungen am System korrelieren
will, rufe ich das Programm `last` auf.
Dieses Programm zeigt an, wer wann und wie lange am System angemeldet war und
außerdem die letzten Systemstarts.
Meist begrenze ich die Anzahl der angezeigten Zeilen, da mich nur die
letzten Anmeldungen interessieren:

{line-numbers=off,lang="text"}
    $ last -5
    mathias pts/2      ..Thu Nov 7 07:38   still...
    mathias pts/1      ..Thu Nov 7 07:33   still...
    mathias pts/0      ..Thu Nov 7 07:21   still...
    reboot  system boot..Thu Nov 7 06:48 - 07:57...
    mathias pts/1      ..Wed Nov 6 09:10 - 11:49...

Diese Daten entnimmt `last` der Datei */var/log/wtmp*.
Die Datei wird üblicherweise am Monatsanfang umbenannt in */var/log/wtmp.1*,
so dass immer nur die Daten des laufenden Monats zur Verfügung stehen.
Will ich die Anmeldungen des Vormonats sehen, gebe ich dieses explizit an:

{line-numbers=off,lang="text"}
    $ last -f /var/log/wtmp.1

Wenn nur ein Konto für alle Anmeldungen verwendet wird, kann ich mit `history`
nachschauen, was zuletzt gemacht wurde.
Bei mehreren Konten schaue ich in der Datei *.bash_history* im
Benutzerverzeichnis des in der fraglichen Zeit angemeldeten Benutzers nach.
Falls der Benutzer die csh verwendet, schaue ich stattdessen in *.history*.

### vmstat - Performancewerte

Mit dem Programm `vmstat` bekomme ich ein Gefühl dafür, wie es einer
Maschine im Moment gerade geht.
Beim Anmelden an der Maschine rufe ich dieses oft wie folgt auf:

{line-numbers=off,lang="text"}
    $ vmstat -SM 1 5

Das kostet mich etwa 5 Sekunden, bis die vollständige Ausgabe erscheint:

{line-numbers=off,lang="text"}
    procs --memory--- -swap- ---io-- -system- ----cpu----
     r  b swpd..cache si  so  bi  bo   in  cs us sy id wa
     1  0    0..  651  0   0 113  14  105 192  3  2 94  1
     0  0    0..  651  0   0   0   0   78 192  2  0 98  0
     0  0    0..  651  0   0   0   0   88 231  1  1 98  0
     0  0    0..  651  0   0   0   0   73 189  1  1 98  0
     0  0    0..  651  0   0   0   0   91 201  1  1 98  0

Die erste Zeile zeigt die Durchschnittswerte des Systems an.
Ich konzentriere mich auf die folgenden vier Zeilen, die die Werte der
jeweiligen Sekunde anzeigen.

Um mich mit dem Rechner vertraut zu machen, das heißt vor einem
Problem, schaue ich mir die Spalten unter *system* und *cpu* an.
Insbesondere die Anzahl der Interrupts (*in*) und Kontextwechsel (*cs*) sowie
der Prozentwert der CPU-Idle-Zeit (*id*) geben mir eine Idee dafür, was auf
dem betreffenden Rechner "normal" ist.
Diese Normalwerte kann ich auch in der Rechnerdokumentation festhalten.

Weichen diese Werte signifikant ab, hat der Rechner ein Lastproblem und ich
schaue mir die anderen Werte an.
Außerdem lasse ich dann das Programm oft mit den Optionen `vmstat -SM 1`
dauerhaft in einer Extra-Konsole laufen um meine Bemühungen, die Rechnerlast
zu reduzieren, verifizieren zu können.

Sind unter *swap* Werte ungleich 0 zu sehen, heißt das dass das Betriebssystem
in diesem Moment Hauptspeicher aus- (*so*) oder einlagert (*si*).
Das deutet auf Speicherprobleme hin.

### free - Hauptspeicher

Der nächste Befehl, der mir hilft ein Bild über den Zustand der
Maschine zu bekommen, ist `free`.

{line-numbers=off,lang="text"}
    $  free -m
                 total used free shared buffers c...
    Mem:          7734 3466 4267      0     676  ...
    -/+ buffers/cache: 1432 6301
    Swap:         5153    0 5153

Dieser Befehl zeigt mir den insgesamt vorhandenen, den benutzten und den
freien Speicher an und außerdem, wieviel Speicher der Kernel gerade für
Dateicaches verwendet.
Mich interessiert vor allem die letzte Zeile, die angibt, wieviel
Auslagerungsspeicher zur Verfügung steht und wieviel der Kernel bereits
ausgelagert hat.
Gerade bei hoher Systemlast sorgt auf Festplatten ausgelagerter RAM für eine
weitere spürbare Verlangsamung des Systems, so dass ich hier schnell für
Abhilfe sorgen möchte.

### df - Plattenplatz

Der vierte Befehl schließlich ist `df`.
Dieser zeigt mir den verfügbaren Platz auf den Dateisystemen der eingehängten
Partitionen an.
Ich rufe diesen Befehl zweimal auf, einmal mit Option `-i`, für die Statistik
der Inodes und einmal ohne für die Belegung des Plattenplatzes.
Die Option `-h` ist für die Ausgabe in lesbarer Form,
zum Beispiel 586G statt der Anzahl in Bytes.

{line-numbers=off,lang="text"}
    $ df -h
    Filesystem   Size  Used Avail Use% Mounted on
    /dev/sda1    586G  207G  350G  38% /
    ...
    $ df -hi
    Filesystem  Inodes IUsed IFree IUse% Mounted on
    /dev/sda1      37M  2.7M   35M    8% /
    ...

Mich interessiert die Spalte mit der prozentualen Nutzung.
Hat diese 100% erreicht, muss ich mit Ausfällen von Diensten rechnen, die, für
sich betrachtet, nicht gleich auf ein Problem mit dem
Plattenplatz gedeutet hätten.
Ab einer Nutzung von 80-90% mache ich mir Gedanken, wie ich für zusätzlichen
verfügbaren Plattenplatz sorgen kann.

Die verfügbaren Inodes in einem Dateisystem werden seltener aufgebraucht.
Dazu müssten auf dem Dateisystem viele kleine Dateien angelegt sein.
Bei Mailservern mit Postfächern im Maildir-Format oder bei Newsservern kann
das vorkommen.

Platzprobleme auf den Laufwerken können sich auf verschiedene Art bemerkbar
machen, noch bevor ich sie beim Besuch des Rechners entdecke.
Das Problem ist, dass sie von außen meist nicht als solche erkennbar sind,
weil nur ein oder wenige Dienste den Betrieb einstellen.
Insbesondere, wenn die Platzprobleme durch große Protokolldateien verursacht
werden, kann es passieren, dass genügend Platz ist, wenn ich mich anmelde und
nachsehe.
In der Nacht werden die Protokolldateien rotiert und dadurch wieder Platz
geschaffen, bis der Plattenplatz erneut aufgebraucht ist.
Aus diesem Grund ist es sinnvoll, den Plattenplatz automatisch, zum Beispiel
von Nagios, überwachen zu lassen.

A> Auch wenn dieser Abschnitt vielleicht den Eindruck erweckt, dass ich
A> viele Probleme
A> gleich nach dem Anmelden am Server diagnostizieren kann, passiert es mir
A> immer wieder, dass ich an einem Problem festhänge, weil ich
A> solche Kleinigkeiten, wie die Kontrolle der Inodes mit `df -i` vergesse.
A> 
A> In einem konkreten Fall hatte CFEngine ein Dateisystem
A> mit kleinen Dateien für Statusmeldungen zugemüllt.
A> Normalerweise generiert CFEngine ungefähr aller 5 Minuten eine
A> Statusmeldung.
A> Bei knapp 300 Statusmeldungen am Tag hatte ich das Problem fast zwei
A> Jahre lang nicht bemerkt, bis alle freien Inodes aufgebraucht waren.
A> Da es kein Mail- oder News-Server war, kam mir nicht in den Sinn, nach den
A> Inodes zu schauen und es war eben nicht zur Routine geworden, sowohl
A> nach dem Plattenplatz als auch nach den Inodes zu sehen.
A> Das hat mich einige unnötige Zeit bei der Fehlersuche gekostet.
A> 
A> Nachdem ich schließlich auf die aufgebrauchten Inodes gekommen war, war das
A> nächste Problem, die Dateien zu finden.
A> Einzeln in alle Verzeichnisse zu schauen dauert zu lange.
A> Mit `find` kann ich das automatisieren.
A> Aber mit welchen Optionen?
A> 
A> Dazu muss ich wissen, wonach ich suche.
A> Wenn die Inodes aufgebraucht sind, gehe ich davon aus, dass viele Tausend
A> Dateien in relativ wenigen Verzeichnissen existieren.
A> Also muss es Verzeichnisse geben, die sehr viele Dateien oder
A> Unterverzeichnisse enthalten.
A> In dem Fall sind diese Verzeichnisse selbst sehr groß, und genau danach
A> suche ich:
A> 
{line-numbers=off,lang="text"}
A>     # find $mountpoint -xdev -type d -size +300k
A> 
A> Ich suche unterhalb des Einhängepunkts des betroffenen Dateisystems
A> (`$mountpoint`) ausschließlich in diesem Dateisystem (`-xdev`) nach
A> Verzeichnissen (`-type d`) deren Größe einen bestimmten Wert überschreitet
A> (`-size +300k`).
A> Bei der Größe muss ich etwas experimentieren, wenn ich
A> zuviel oder zuwenig Ergebnisse bekomme.
A> 
A> Auf genau diese Art bin ich bei diesem Problem auf
A> */var/cfengine/output/* und darüber auf CFEngine als Verursacher gekommen.
A> Der Rechner hatte eine Testkonfiguration und sich selbst als
A> Policy-Server eingestellt.
A> Nach Konfiguration des richtigen Policy-Servers erledigte sich das Problem
A> in kurzer Zeit von selbst.

### pstree, ps - laufende Prozesse

Der letzte Befehl, `pstree`, zeigt mir, ob die notwendigen Prozesse laufen und
ob gegebenenfalls Prozesse zuviel sind.
Die Ausgabe des Befehls sieht auf jeder Maschine anders aus, entsprechend den
Diensten, die diese anbietet.
Mit etwas Erfahrung sehe ich damit schon intuitiv, ob ein Rechner "krank" ist.

{line-numbers=off,lang="text"}
    $ pstree -A
    init-+-courierlogger---authdaemond---5*[auth...
         |-2*[courierlogger---couriertcpd]
         |-cron
         |-getty
         |-master-+-pickup
         |        |-qmgr
         |        `-tlsmgr
         |-ntpd
         |-portmap
         |-rsyslogd---3*[{rsyslogd}]
         |-sshd---sshd---sshd---bash---pstree
         |-6*[stunnel4]
         `-udevd

Der Befehl `ps xjf`, auf Systemen, die `pstree` nicht installiert haben, ist
weniger übersichtlich und nur ein schwacher Ersatz.

Mit diesen ersten Befehlen, die ich gewohnheitsmäßig nach der
Anmeldung am Server aufrufe, bekomme ich schnell eine intuitive
Einschätzung - ein Gefühl - für den Zustand des Systems.
Alle weiteren Schritte hängen vom konkreten Problem und der Situation auf dem
Rechner ab.


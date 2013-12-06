
## strace {#sec-lokal-werkzeuge-strace}

Strace setze ich ein, wenn mir das Verhalten eines Programmes unklar ist.
Wenn ich Probleme mit Zugriffsrechten vermute, aber keinen Anhaltspunkt in
den Fehlermeldungen oder Systemprotokollen finde.
Wenn ich mit einem Programm noch wenig Erfahrung habe, keine Hilfe 
im Internet finde, aber das Problem trotzdem so schnell wie möglich
beheben will.
In [Koenig2012](#bib-koenig2012) führt Harald König sehr gut in die Arbeit
mit strace ein.
  
Strace hilft mir, wenn ich beobachten will, wie ein Programm
mit seiner Umgebung interagiert. Es setzt an der Kernelschnittstelle
an und protokolliert alle Systemaufrufe mit den Parametern und Ergebnissen.
Diese stellt es im Protokoll ähnlich den Systemaufrufen in der
Programmiersprache C dar, mit folgendem Unterschied: das Ergebnis steht
hinter einem Gleichheitszeichen am Ende der Zeile, die Systemzeit steht
vor dem Systemaufruf.
Wenn ich mehrere Prozesse beobachte und in dieselbe Datei protokolliere,
steht zusätzlich die Prozess-ID am Anfang der Zeile.

Um die Ausgabe von strace interpretieren zu können, ist es hilfreich, die
Sektion 2 der Handbuchseiten installiert zu haben.
Diese befinden sich bei Debian-basierten Systemen im Paket *manpages-dev*.

Da strace Systemaufrufe der beobachteten Prozesse protokolliert, verlangsamt
sich deren Ablauf, was zu zusätzlichen Problemen bei der Fehlersuche führen
kann. Dessen muss ich mir beim Einsatz von strace immer bewusst sein.

Ich setze strace bei der Fehlersuche meist auf eine der folgenden Weisen ein.

Bei Programmen, die ich von der Kommandozeile aus aufrufe,
starte ich das betreffende Programm wie gewohnt, allerdings setze ich an den
Anfang `strace` mit einigen Optionen.
So wird aus

{line-numbers=off,lang="bash"}
    $ make xyz

dann

{line-numbers=off,lang="bash"}
    $ strace -f -o make.strace make xyz

Dabei bedeuten die Optionen

*-f*
: Strace soll auch von make gestartete Programme beobachten.

*-o make.strace*
: Die Ausgabe geht in die Datei *make.strace*.

Bei Problemen mit bereits gestarteten Prozessen verwende ich die Option
`-p PID` um mich mit dem Prozess mit dieser PID zu verbinden.
Alle weiteren Optionen bleiben wie gehabt, auf die Angabe des Programmnamens
und der Programmparameter kann ich verzichten.
Prozesse, die bereits vorher von dem untersuchten Prozess gestartet wurden,
beobachtet `strace` nicht, wohl aber neu gestartete Prozesse, wenn ich wieder
die Option `-f` angebe.

Schwieriger ist es, wenn ein Programm ein zweites aufruft, dieses ein
drittes und so weiter.
Wenn ich nur an einem der Programme interessiert bin und nicht genau weiß,
von welchem Prozess beziehungsweise Programm dieses gestartet wird,
helfe ich mir mit einem Trick.
Ich benenne das Programm um und ersetze es durch ein Skript, welches alle
mich interessierenden Werte protokolliert und schließlich
das Originalprogramm via strace aufruft.
Dieses Skript ist im Abschnitt zur [Shell](#sec-lokal-werkzeuge-shell) näher
beschrieben.
Natürlich darf ich am Ende nicht vergessen, das Skript wieder durch das
Originalprogramm zu ersetzen.


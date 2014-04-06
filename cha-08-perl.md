
## Perl {#sec-lokal-werkzeuge-perl}

Zwischen den Spezialwerkzeugen für die Fehlersuche und der Shell als
Kommandozentrale benötige ich hin und wieder ein Werkzeug, mit dem sich auch
kniffligere Probleme angehen lassen, die so vorher noch gar nicht
untersucht worden sind.
Etwas, das sich etwa so schnell wie die Shell programmieren läßt,
aber ausdrucksstärker ist und auch sehr komplexe
Probleme angehen kann.
Für mich ist das Perl.
Für andere vielleicht Python oder eine der anderen Skriptsprachen.

Die Programmiersprache Perl umfasst Konzepte von einfachen Werkzeugen wie sed
oder awk bis hin zu anspruchsvollen Programmiersprachen wie C oder Lisp.
Es gibt umfangreiche Fachliteratur sowohl offline als auch online sowie
Communities, an die man sich bei Problemen wenden kann.

Was Perl aber heraushebt gegenüber vielen anderen Skriptsprachen ist CPAN,
das Comprehensive Perl Archive Network, ein umfangreiches Reservoir an
Softwaremodulen für fast alle erdenklichen Zwecke.
Dieses macht es möglich, die meisten Skripts auf wenige Zeilen zu beschränken.
Die besten und meist verwendeten Module schaffen es mit der Zeit in die
Standarddistribution und stehen dann nach der Installation von Perl gleich
zur Verfügung.
In vielen Fällen muß ich Perl auch gar nicht zusätzlich installieren,
weil es bereits Bestandteil des Systems ist.

Besonders hilfreich bei der Problemlösung ist das Perl Kochbuch von
Tom Christiansen und Nathan Torkington [[CT2000](#bib-ct2000)].
In diesem Buch sind Lösungen für viele Probleme in Rezeptform aufbereitet
und vor allen Dingen erläutert.
Die Codebeispiele aus dem Kochbuch sind online verfügbar, den meisten Wert
zieht man jedoch aus den Erläuterungen im Buch.

### Syslog auswerten

Es kommt immer mal wieder vor, dass ich die Zeilen in den Systemprotokollen
miteinander verknüpfen muss, um eine ganz spezielle Auswertung zu bekommen.
Finde ich kein geeignetes Programm, beginne ich mit folgendem Fragment, dass
ich dann für die Lösung des konkreten Problems ausbaue:
  
{lang="perl"}
<<[read-syslog.pl](code/read-syslog.pl)

In Zeile 3 trage ich den Prozessnamen ein, an dessen Logzeilen ich interessiert
bin.
Sind es mehrere Prozesse, muss ich gegebenenfalls auch die Zeile 19 anpassen.

Die Zeilen 4-13 definieren einen regulären Ausdruck mit dessen Hilfe ich
die Protokollzeilen in ihre Bestandteile aufspalte.

Die Zeitfelder fasse ich in der Funktion `utctime()` zu einer Zahl
zusammen. Als Jahr nimmt das Skript das aktuelle an, dieses wird in den
Zeilen 14, 15 ermittelt.

In Funktion `process_line()` kann ich die gesamte
Auswertelogik für die Protokollzeilen schreiben und dabei auf die bereits
separierten allgemeinen Felder und die eigentliche Nachricht zurückgreifen.

Wenn ich mehrere Protokollzeilen miteinander in Beziehung setzen will,
verwende ich eine globale Datenstruktur und gebe das Ergebnis entweder am
Ende, nach der `while (<>)` Schleife oder zwischendurch in der Funktion
`process_line()` aus.

A> Ein Problem bei Programm-Skripts kann der Zeilenumbruch bereiten, wenn man
A> ein Skript ohne besondere Vorkehrungen von Windows nach UNIX kopiert.
A> 
A> Traditionell gibt es drei verschiedene Standards, den Zeilenumbruch bei
A> ASCII-Dateien zu kodieren:
A> 
A> *   UNIX, Linux, Mac OS X und weitere verwenden das Zeichen `0x0a`
A>     (*"\n"*)
A> *   MS DOS, Windows und einige andere verwenden die Zeichenfolge `0x0d 0x0a`
A>     (*"\r\n"*)
A> *   Mac OS bis Version 9 und einige andere Systeme verwenden das Zeichen
A>     `0x0d` (*"\r"*).
A> 
A> Da der Text selbst sich scheinbar nicht unterscheidet und viele Programme,
A> wie zum Beispiel `less` die Zeilen normal anzeigen, auch wenn der
A> Zeilenumbruch nicht zum System passt, merkt man mitunter erst, wenn man das
A> Skript ausführen will, dass es die falschen Zeilenumbrüche verwendet:
A> 
{line-numbers=off,lang="text"}
A>     $ bash: ./test.pl: /usr/bin/perl^M: bad interpreter:\
A>      No such file or directory
A>     $ od -c test.pl|head -2
A>     0000  #  !  /  u  s  r  /  b  i  n  /  p  e  r  l \r
A>     0020 \n  #     v  i  m  :     s  e  t     t  s  =  4
A> 
A> In diesem Fall muss ich den Zeilenumbruch der Skript-Datei ändern.
A> Das kann ich mit dem Programm `dos2unix` erledigen, oder mit dem folgenden
A> Perl-Einzeiler:
A> 
{line-numbers=off,lang="text"}
A>     $ perl -pi.bak -e 's/\r\n$/\n/g' test.pl
A> 
A> Damit kopiert Perl die Original-Datei mit der Endung *.bak* und ersetzt das
A> Skript durch eine Version mit passenden Zeilenumbrüchen für Linux/Unix.


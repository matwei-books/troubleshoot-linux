
## perl {#sec-netz-werkzeuge-perl}

Für knifflige Probleme, die ich mit den spezialisierten Werkzeugen nicht zu
fassen kriege und denen mit einfacher Shell-Programmierung auch nicht
beizukommen ist, benötige ich ein Werkzeug, das mächtiger ist als die
Shell und universeller als die verschiedenen vorhandenen Spezialprogramme.
Für mich ist das die Programmiersprache Perl.
Insbesondere durch die vielen verfügbaren Module
auf CPAN kann ich damit sehr schnell Speziallösungen für vertrackte
Probleme zusammenbauen.

Ich hatte Perl als Werkzeug bereits im Abschnitt zur lokalen Fehlersuche
beschrieben.
Durch die vielen einfach verfügbaren und meist sehr gut getesteten und
dokumentierten Module auf CPAN ist Perl für mich auch bei Netzwerkproblemen
ein unentbehrliches Werkzeug für die Fehlersuche.

Das Perl Kochbuch [[CT2000](#bib-ct2000)] hatte ich bereits erwähnt.
Mit dessen Hilfe und den darin beschriebenen Modulen von CPAN war
es mir möglich in sehr kurzer Zeit ein spezielles Testprogramm für
ein Timing-Problem bei einem Webservice zu schreiben.

### HTTP Injector

Vor einiger Zeit hatte ich ein Problem, bei dem 502-Fehler eines Webservice
von der Zeit, in der die Anfrage gesendet wurde, abhängig waren.
Der Betreiber des Webservices war nicht kooperativ und um das Problem zu
verifizieren benötigte ich die Möglichkeit HTTP-Anfragen gezielt zu verzögern.
  
Mit Hilfe des Kochbuches kam ich zu folgendem kurzen Programm:

<<[http-injector.pl](code/http-injector.pl)

In den Zeilen 2-4 lädt das Skript die benötigten Module.

`Getopt::Long`
: ist für die Verarbeitung der Kommandozeilenoptionen und sichert ab,
  dass ich mit `--delay` einen Integerwert angebe.

`IO::Socket`
: stellt die Socketfunktionalität bereit, so dass ich diesen Socket wie eine
  Datei verwenden kann.
  
`Time::HiRes`
: stellt mir eine verbesserte `sleep()` Funktion bereit, die mit
  Gleitkommazahlen zurechtkommt und Sekundenbruchteile schlafen kann.

In Zeile 6 stellt es die Option `--delay` auf den Wert 0 ein, falls
diese nicht explizit in der Kommandozeile angegeben wird.
In Zeile 8 werden die Optionen eingelesen.

Zeile 10 und 11 entnehmen den Server und gegebenenfalls den Port der
Kommandozeile und in Zeile 13 öffnet es mit diesen Angaben den Socket.

In Zeile 17 liest das Skript die gesamte Eingabe in ein Array ein.
Die benötigt es, weil es die Anzahl der Zeilen wissen muss, um die einzelnen
Zeilen jeweils nach einem Bruchteil der Gesamtverzögerung senden zu können.

In den Zeilen 19-24 schließlich bereitet es die Zeilenenden auf und sendet die
modifizierten Zeilen verzögert über den Socket.

In Zeile 25 schickt es die abschließende Leerzeile, nach der der Server
antwortet.

In den Zeilen 27-29 liest das Skript die Antwort des Servers vom Socket und
schreibt sie zur Standardausgabe.

Dieses Skript kann ich nun wie folgt aufrufen:

{line-numbers=off}
    $ time ./http-injector.pl --delay 5 localhost 80 \
      < request                                      \
      > reply

    real  0m5.072s
    user  0m0.056s
    sys   0m0.012s

Dabei steht in der Datei *request* die HTTP-Anfrage, die ich an den Server
sende.
Nach fünf Sekunden ist die Anfrage beim Server, und die Antwort landet in
der Datei *reply*.

Mit diesem Skript konnte ich nachweisen, dass dieselbe Anfrage einen Fehler
lieferte, wenn sie mehr als drei Sekunden zur Übertragung brauchte und
fehlerfrei beantwortet wurde, wenn sie weniger als drei Sekunden brauchte.
Danach fand der Betreiber des Webservice die Stelle, an der der Timeout zu
kurz eingestellt war und das Problem konnte aus der Welt geschafft werden.

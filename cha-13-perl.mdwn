
## perl {#sec-netz-werkzeuge-perl}

Für knifflige Probleme, die ich mit den spezialisierten Werkzeugen nicht zu
fassen kriege und denen mit einfacher Shell-Programmierung auch nicht
beizukommen ist, benötige ich eine Programmiersprache, die mächtiger als die
Shell ist, mit der ich aber trotzdem mit wenig Aufwand ein passendes
Programm schreiben kann. Insbesondere durch die vielen verfügbaren Module
auf CPAN kann ich damit relativ schnell eine Speziallösung für vertrackte
Probleme zusammenbauen.

Perl hatte ich als Werkzeug bereits im Abschnitt über die Werkzeuge zur
lokalen Fehlersuche beschrieben. Durch die vielen einfach verfügbaren und
meist sehr gut getesteten und dokumentierten Module auf CPAN ist Perl auch
ein unentbehrliches Werkzeug für die Fehlersuche bei Netzwerkproblemen.

Das Perl Kochbuch [[CT2000](#bib-ct2000)] hatte ich bereits
erwähnt. Mit dessen Hilfe und den darin beschriebenen Modulen von CPAN war
es mir zum Beispiel möglich ein Testprogramm für ein Timing-Problem bei
einem Webservice zu schreiben.

### HTTP Injector

Vor einiger Zeit hatte ich ein Problem, bei dem 502-Fehler von
einem Webservice abhängig waren von der Zeit für die
Anfrage. Der Betreiber des Webservices stritt das ab und um das
Problem zu verifizieren benötigte ich die Möglichkeit HTTP-Anfragen gezielt
zu verzögern.
  
Ich kam mit Hilfe des Kochbuches zu folgendem Programm:

<<[http-injector.pl](code/http-injector.pl)

In den Zeilen 2-4 lade ich die benötigten Module. `Getopt::Long` ist
für die Verarbeitung der Kommandozeilenoptionen und sichert ab, dass ich mit
`--delay` einen Integerwert angebe. `IO::Socket` stellt die
Socketfunktionalität bereit, so dass ich diesen Socket wie eine Datei
verwenden kann. `Time::HiRes` stellt mir eine verbesserte
`sleep()` Funktion bereit, die mit Gleitkommazahlen zurechtkommt.

In Zeile 6 stelle ich die Option `--delay` auf den Wert 0 ein, falls
sie nicht explizit angegeben wird. In Zeile 8 werden die Optionen
eingelesen.

Zeile 10 und 11 entnehmen den Server und gegebenenfalls den Port der
Kommandozeile und in Zeile 13 öffne ich mit diesen Angaben den Socket.

In Zeile 18 lese ich die gesamte Eingabe in ein Array ein. Dies benötige
ich, da ich die Anzahl der Zeilen wissen muss, denn ich verzögere das Senden
zeilenweise um jeweils einen Bruchteil der Gesamtverzögerung. Die Zeilen
20-25 schließlich bereiten die Zeilenenden auf und senden die modifizierten
Zeilen verzögert über den Socket. Zeile 26 schickt die Leerzeile, nach der
der Server antwortet.

In Zeile 28-30 liest das Skript die Antwort des Servers vom Socket und
schreibt sie zur Standardausgabe.

Dieses Skript kann ich nun wie folgt aufrufen:

{line-numbers=off}
    $ time ./http-injector.pl --delay 5 localhost 80 < request > reply

    real  0m5.072s
    user  0m0.056s
    sys   0m0.012s

Dabei steht in der Datei request die HTTP-Anfrage, die ich an den Server
sende.
Nach fünf Sekunden ist die Anfrage beim Server, und die Antwort landet in
der Datei reply.

Damit konnte ich nachweisen, dass dieselbe Anfrage einen Fehler
lieferte, wenn sie mehr als drei Sekunden zur Übertragung brauchte und
fehlerfrei beantwortet wurde, wenn sie weniger als drei Sekunden brauchte.


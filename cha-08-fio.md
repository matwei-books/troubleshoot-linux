
## fio - flexible I/O tester

Manche Fehler treten nur unter Last zutage.
Genauso ist es beim Performance-Tuning.
Ob meine Maßnahmen erfolgreich sind, sehe ich erst, wenn das System unter Last
arbeitet.
Damit ich nicht auf die Systembenutzer angewiesen bin, deren Last meist
stochastisch und nicht vorhersagbar ist, benötige ich in diesem Fall ein
Werkzeug, das mir eine geeignete Last erzeugen kann.

Früher habe ich dann schnell ein kleines Skript oder Programm gebastelt,
das ungefähr die geforderte Last erzeugt, und dieses anschließend entsorgt.

Mit `fio` brauche ich kein Programm mehr zu schreiben, sondern nur noch eine
Beschreibung für die gewünschte Last.
Und das kann fast jede erdenkliche Last sein.
Das Programm `fio` kann in einem Job synchron oder asynchron schreiben, per
mmap() eingebundene Dateien bewegen, Netzlast simulieren oder einfach nur
CPU-Zeit verbrennen.
Und es kann mehrere Jobs gleichzeitig ausführen, so dass ich mir die
gewünschte Last sehr genau zusammenstellen kann.

Die Jobs, die `fio` abarbeitet, werden in Dateien beschrieben, deren
Format den *Ini*-Dateien entspricht, mit Sektionen, die durch ihren Namen in
eckigen Klammern eingeleitet werden und Kommentaren, die mit `;` oder `#`
am Zeilenanfang eingeleitet werden.

Meist rufe ich `fio` nur mit dem Namen der Job-Datei als einzigem Argument auf.
Habe ich nur einen einzigen Job, könnte ich dessen Parameter auch gleich auf
der Kommandozeile angeben.

Details zum Einsatz von `fio` finde ich in der Handbuchseite, der Datei
*HOWTO* und den Beispiel-Job-Dateien im Verzeichnis *examples/* bei der
Paketdokumentation.


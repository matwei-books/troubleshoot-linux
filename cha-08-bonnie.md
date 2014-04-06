
## bonnie++ {#sec-lokal-werkzeuge-bonnie}

Bei jeglicher Art von Performance Tuning ist es essentiell, eine
Bestandsaufnahme vor den Tuning-Maßnahmen und danach zu machen, um sich von
der Wirkung des Tunings zu überzeugen.
Bonnie++ ist ein Programm, mit dem ich die Performance der Lese- und
Schreiboperationen im Dateisystem in Zahlen ausdrücken und damit
vergleichen kann.
Ich setze bonnie++ ein, wenn ich

*   Optimierungen am Festplattenzugriff (zum Beispiel mit hdparm)
    verifizieren will,

*   Optimierungen am Dateisystem verifizieren will, oder

*   eine Baseline aufnehmen will, um gleichartige Rechner zu vergleichen oder
    um später sehen zu können, ob das System schlechter oder besser geworden
    ist.

**Bonnie++ sollte niemals auf aktiven Produktionsmaschinen laufen, da die
Performance durch die Tests sehr stark beeinträchtigt wird.**

Das Programm gibt für jeden Test, den es durchführt, zwei Kennzahlen
aus: die geschaffte Arbeit (je mehr, um so besser) und die dafür benötigte
CPU-Zeit (je weniger, umso besser).

Die Tests teilen sich grob in zwei Abschnitte, die ich überspringen kann.
In einem Abschnitt testet bonnie++ den I/O-Durchsatz mit großen Dateien,
wie er ähnlich bei Datenbankanwendungen vorkommt.
Im anderen Abschnitt geht es um das Erzeugen, Lesen und Löschen vieler
kleiner Dateien, wie es auf Proxy-, Mail- und News-Servern vorkommt.

In den meisten Fällen bin ich daran interessiert, das I/O-Verhalten bei
einzelnen Dateizugriffen zu beobachten.
Bei bestimmten Problemen möchte ich jedoch den Einfluss von gleichzeitigen
Dateizugriffen bewerten.
Zu diesem Zweck kann ich mehrere bonnie++ Prozesse synchron starten.

Die Ausgabe von bonnie++ kommt, wie schon beim Vorgängerprogramm bonnie als
Text mit 80 Spalten.
Zusätzlich gibt bonnie++ die Werte noch als kommaseparierte Werte (CSV)
aus, die einfacher weiterverarbeitet werden und mehr als 80 Zeichen pro Zeile
einnehmen können.
Für diese CSV-Daten gibt es zwei Programme (`bon_csv2html`, `bon_csv2txt`),
die die Daten für die HTML-Ausgabe beziehungsweise das bekannte Textformat
aufbereiten. In deren Handbuchseiten sind die Felder der CSV-Daten
beschrieben.

### Optionen

*-d dir*
: In diesem Verzeichnis, legt bonnie++ die Testdateien an.
  Ohne Angabe dieser Option werden die Testdateien im aktuellen
  Verzeichnis angelegt.

*-s size*
: Die Größe der Dateien für die I/O-Performance-Tests. Mit
  einer Größe von 0 wird dieser Test übersprungen.

*-n number*
: Die Anzahl der Dateien für den Dateierzeugungstest.
  Die Anzahl wird als Vielfaches von 1024 angegeben.
  Ist die Anzahl 0, überspringt bonnie++ diesen Test.
  Per Default werden leere Dateien angelegt.
  Es ist möglich, die maximale und minimale Größe der Dateien und die Anzahl
  der Verzeichnisse durch Doppelpunkt getrennt gemeinsam mit der Anzahl
  anzugeben.
  Details stehen in den Handbuchseiten.

*-x number*
: Die Anzahl der Testläufe.
  Damit ist es möglich, mehrere Tests ununterbrochen nacheinander zu machen,
  die Ergebnisse kommen kontinuierlich als CSV-Daten.

*-u user*
: Der Benutzer, unter dem der bonnie++ Prozess laufen soll.
  Bonnie++ kann als normaler Nutzer gestartet werden.
  Startet man es als root, gibt man mit dieser Option einen anderen Benutzer
  vor, um Fehler am Dateisystem zu vermeiden.

*-f | -f size*
: Fast Mode Control, überspringt den zeichenweisen
  I/O-Test, wenn kein Parameter.
  Ansonsten gibt es die Testgröße für zeichenweisen I/O-Test vor (default 20M).

*-b*
: Keine Pufferung der Schreiboperationen, das heißt bonnie++ ruft
  `fsync()` nach jedem Schreiben auf.

*-q*
: Quiet Mode.
  Ein Teil der Ausgabe wird unterdrückt, an STDOUT werden nur die CSV-Daten
  ausgegeben, alles andere an STDERR.
  Damit ist es einfacher, die Ausgabe weiter zu verarbeiten.

*-p number*
: Die Anzahl der Prozesse, für die Semaphore reserviert werden sollen.
  Alle Prozesse, die Semaphore mit Option `-ys` verwenden, starten synchron.

*-y s*
: Durch Semaphor synchronisiert starten

*-y p*
: Mit Prompt synchronisieren. Bonnie++ startet erst, wenn
  `<RETURN>` eingegeben wurde.

*-D*
: Direct-I/O (`O_DIRECT`) für Massen-I/O-Tests verwenden.

*-z seed*
: Die Startzahl für den Zufallsgenerator angeben, um den gleichen Test zu
  wiederholen.

*-Z file*
: Zufallsdaten aus der angegebenen Datei verwenden.

### Synchrone Tests

Um mehrere Prozesse mit bonnie++ synchron zu starten, kann ich wie folgt
vorgehen:

{line-numbers=off,lang="text"}
    $ bonnie++ -p3
    $ bonnie++ [weitere Optionen] -ys > out1 &
    $ bonnie++ [weitere Optionen] -ys > out2 &
    $ bonnie++ [weitere Optionen] -ys > out3 &

### Signale

Bonnie++ kann mitunter recht lange laufen, vor allem wenn es mit Option
`-x`  seine Tests wiederholt.

Mit SIGINT kann ich die Ausführung abbrechen, bonnie++ räumt dann wieder
auf, das heißt, es entfernt die temporären Dateien und Verzeichnisse.
Das kann etwas dauern.
Durch wiederholtes Senden von SIGINT bricht es das Aufräumen ab.

SIGHUP wird ignoriert, das heißt, wenn bonnie++ im Hintergrund läuft, bricht es
nicht nach Abmelden vom Terminal ab.


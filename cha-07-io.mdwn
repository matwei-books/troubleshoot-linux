
## Engpass Ein-/Ausgabe

Stelle ich fest, dass das System wenig bis gar keinen Hauptspeicher auslagert
und die CPU ihre Zeit nicht zum größten Teil im User- oder Kernelcode sondern
wartend verbringt, dann habe ich es mit einem Engpass beim I/O-Subsystem
zu tun.

Probleme bei Ein- und Ausgabe können durch das Netzwerk verursacht sein, darum
kümmere ich mich im dritten Teil des Buches.
Sie können durch spezielle Hardware verursacht werden, das lasse ich außen vor,
weil diese Probleme nur mit eben dieser Hardware gelöst werden können.
Oder, sie kommen durch Plattenzugriffe zustande, die ich optimieren kann.
Genau darum geht es in dem nun folgenden Abschnitt.

Wenn ich die Platten-Performance verbessern will, brauche ich ein gewisses
Grundverständnis über die Zusammenhänge und die Stellen, an denen ich
schrauben kann, sowie eine Möglichkeit, das Ergebnis meiner Bemühungen zu
verifizieren.

### Grundlagen

Daten, die auf Festplatte gespeichert sind, sind den Benutzerprogrammen im
Allgemeinen als Dateien im Dateisystem zugänglich.
Einige Datenbanksysteme arbeiten statt mit Dateien direkt mit den
Blockdevices, die die Festplatte beziehungsweise deren Partition repräsentieren.
Da bei diesen Datenbanksystemen meist in der Dokumentation Anleitungen zum
Performancetuning zu finden sind, lasse ich auch diese hier außen vor.

Ich betrachte als oberste Abstraktion für den Zugriff auf
Festplattendaten Dateien in den zugehörigen, mit `mount` eingebundenen
Dateisystemen.
Auf dieser Ebene kann ich Einfluß auf die Performance nehmen, durch die Wahl
des Dateisystems und die Parameter für `mount` beim Einhängen in den Dateibaum.

Die nächsttiefere Ebene ist das Blockdevice, auf dem das Dateisystem angelegt
ist.
Hier habe ich selten eine Wahl bezüglich des Treibers.
Bei speziellen Blockdevices, wie zum Beispiel verschlüsselten Partitionen,
stehen mir mitunter Alternativen offen, die ich gegeneinander abwägen muss.
Habe ich mehr Festplatten als ich Plattenplatz benötige, kann ich durch die
Wahl geeigneter RAID-Level das System für meinen Bedarf optimieren.
Dabei darf ich neben der Geschwindigkeit die Datensicherheit nicht aus den
Augen lassen.

Schließlich komme ich zur untersten Schicht, dem Festplattencontroller und der
Plattenelektronik.
Für den Anschluss der Festplatte gibt es verschiedene Systeme, wie IDE, SCSI,
SATA, SAS, die ich bei fertigen Systemen und konkreten Festplatten nicht mehr
ändern kann.
Allerdings habe ich die Möglichkeit, durch Änderung einiger Parameter die
Übertragung der Daten zu beschleunigen.
Diese Parameter kann ich mit dem Programm `hdparm` einstellen.

Halten wir fest, dass ich die Geschwindigkeit der Dateizugriffe
beeinflussen kann durch:

*   die Wahl der Hardware und Übertragungsmodi
*   den Kerneltreiber, dessen Optionen und gegebenenfalls den RAID-Level
*   die Wahl des Dateisystems und der Optionen beim Einhängen dieses in den
    Dateibaum

### Verifizierung der Tuningmaßnahmen

Um mich zu vergewissern, dass mein Tuning erfolgreich war, muss ich die
Performance vor und nach den Änderungen messen und protokollieren.
Dafür habe ich verschiedene Möglichkeiten.

Die einfachste und fast immer verfügbare ist das Lesen und Schreiben von Daten
mit `dd`.
Dieses Programm ist auf fast allen Systemen installiert, mit speziellen
Optionen kann ich es anweisen, Dateizugriffe synchron zu schreiben oder direkt
zu lesen, so dass ich den Einfluss der Dateipuffer eliminieren kann.
Dann brauche ich nur die Zeit zu messen und kann die Geschwindigkeit für
sequentielles Lesen und Schreiben ermitteln.

Um neben der sequentiellen Lese- und Schreibgeschwindigkeit auch die
Performance bei wahlfreiem Zugriff einzuschätzen, kann ich auf `bonnie++`
zurückgreifen.
Dieses Programm liefert mir die Auswertungen in übersichtlichen Tabellen,
die das Vergleichen erleichtern.

Schließlich kann ich mit dem Programm `fio` gezielt ganz bestimmte I/O-Lasten
erzeugen.

Wichtig bei all diesen Messverfahren ist, dass das System unbelastet von
anderen Aufgaben ist, damit ich die Messungen vergleichen kann.

### Monitoring

Habe ich kein unbelastetes System, an dem ich in Ruhe meine Messungen machen
kann, sondern ein stark belastetes, dem ich helfen will, dann bin ich mit
`top` und `iostat` besser bedient.

Bei `top` schalte ich mit den Tasten `F` und dann `u` die Anzeige um, so dass
sie nach Pagefaults sortiert wird.
Damit kenne ich die Prozesse, welche die meisten Ein- und Ausgaben machen und
kann mir überlegen, wie ich die dadurch verursachte Last reduziere.
Der Befehl

{line-numbers=off,lang="text"}
    $ iostat -p -xk

zeigt mir auf, welchen Partitionen geschrieben beziehungsweise gelesen wird.
Mit `fuser` und `lsof` kann ich die Dateien und Verzeichnisse ermitteln und
diese vielleicht auf eine andere Platte verschieben, um die Last gleichmäßiger
zu verteilen.

### Tuningmaßnahmen

Die Einstellungen sollten vor Inbetriebnahme des Systems erfolgen.
Ist es erstmal produktiv, bleibt oft keine Zeit für größere Maßnahmen.

Wenn es möglich ist, eine weitere Platte einzubauen, kann ich damit die Last
besser verteilen und so das System entlasten.
Dazu bestimme ich mit `iostat`, `fuser` und `lsof` die bisherige Auslastung und
die Lage der Dateien, um sie dann geschickter zu verteilen.

Dateien mit ähnlichen Zugriffsmustern sollten auf der selben Partition liegen,
wenn ich die Partitionen über `mount` Optionen optimiere.

Auf Festplatten, rotierenden Scheiben, sollten so wenige
Partitionen wie möglich sein, bei mehreren häufig genutzten Partitionen muss
der Lesekopf sonst unnötig große Wege zurücklegen.

RAID0 kann die Lesegeschwindigkeit erhöhen, RAID1 die Schreibgeschwindigkeit.
Gerade bei letzterem darf ich die Datensicherheit nicht aus dem Auge verlieren.

Mit `hdparm` kann ich verschiedene Parameter des Plattencontrollers und der
Plattenelektronik einstellen.


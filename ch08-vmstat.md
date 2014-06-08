
## vmstat {#sec-lokal-werkzeuge-vmstat}

Das Programm `vmstat` verwende ich, um bei lokalen Performanceengpässen einen
Überblick über das Gesamtsystem zu bekommen. Es liefert mir statistische
Informationen über Prozesse, Speicher, I/O, Platten- und CPU-Aktivitäten.
Durch die kompakte Darstellung kann ich im Wiederholungsmodus  ein Gefühl
für die Aktivität des Gesamtsystems bekommen.
Wenn ein Performanceengpass auftritt, sehe ich sofort, ob es ein allgemeines
Ressourcenproblem ist - zuwenig Speicher, zu schwache CPU, zu langsame
Platte - oder ob ich mich eher mit dem betreffenden Programm
beschäftigen muss.

Für die meisten Optionen sind keine speziellen Privilegien erforderlich.
Ich kann mit `vmstat` als normaler Benutzer nachsehen,
wie es dem System geht.
  
Im Wiederholungsmodus zeigt das Programm in der ersten Zeile für alle Werte
den Durchschnitt seit Systemstart an und in den folgenden Zeilen die Werte
für die betreffende Abtastperiode. Diesen Modus verwende ich am häufigsten:

{line-numbers=off,lang="text"}
    vmstat [-a] [-n] [$periode [$anzahl]]

Lasse ich die beiden Zahlen für `$periode` und `$anzahl` weg, dann
bekomme ich nur die Durchschnittswerte seit Systemstart angezeigt. Das
brauche ich eigentlich nur, wenn ich das System sehr gut kenne oder mehrere
ähnliche Systeme vergleichen will.

Gebe ich eine Zahl für `$periode` an, dann verwendet `vmstat` diese als Länge
der Periode in Sekunden mit der es kontinuierlich die Werte der letzten Periode
ausgibt. Auch hier steht in der ersten Zeile der Durchschnitt seit
Systemstart, so dass ich gleich ab der zweiten Zeile sehen kann, wie das
System im Moment beschäftigt ist.

Gebe ich eine Zahl für `$anzahl` an, beendet sich `vmstat` nach
soviel Perioden, wie angegeben.

Die Ausgabe von `vmstat` in diesem Modus bedeutet folgendes:

*Procs*
: Unter `r` steht die Anzahl der Prozesse, die laufen
  können und unter `b` die Anzahl der Prozesse in
  uninteruptible sleep, das sind Prozesse, die im Kernelcode auf I/O
  warten.

*Memory*
: Hier habe ich unter `swpd` die Menge des verwendeten
  virtuellen Speichers, also des ausgelagerten Hauptspeichers.
  Unter `free` finde ich den unbenutzten Speicher, unter `buff`
  Speicher, den der Kernel für Datei- und Socketpuffer verwendet.
  Den unter `cache` aufgeführte Speicher verwendet er für zwischengespeicherte
  Daten von Blockdevices.

  Habe ich die Option `-a` angegeben, zeigt `vmstat` statt `buffer/cache`
  aktiven und inaktiven Speicher an.

*IO*
: Unter des Spalte `bi` finde ich die Anzahl der von
  Blockdevices gelesenen Blöcke (blocks in) und unter `bo` die
  geschriebenen (blocks out).

*System*
: Hier finde ich unter `in` die Anzahl der Interrupts pro
  Sekunde und unter `cs` die Anzahl der Kontextwechsel pro Sekunde.

*CPU*
: Diese Spalten zeigen prozentual, wie die CPU ihre Zeit
  verbringt. Unter `us` steht der Anteil, den die CPU mit Code in
  Benutzerprogrammen verbringt. Unter `sy` steht die Zeit für das
  Abarbeiten von Systemaufrufen und unter `id` die untätige (idle)
  Zeit. Bis zum Kernel 2.5.41 zählte die Zeit, in der die CPU auf I/O
  wartete hierzu, ab dann gab es dafür die Spalte `wa`.

Im Wiederholungsmodus kann ich mit Option `-a` die Anzeige des Speichers
von buffer/cache auf inactive/active umschalten und mit `-n` die
wiederholte Anzeige der Kopfzeilen abschalten. Letztere sind insbesondere
bei länger laufender Ausgabe praktisch, wenn ich nicht genau im Kopf habe,
welche Spalte was anzeigt. Daher verwende ich `-n` so gut wie nie.

Mit Option `-m`, die Superuserprivilegien erfordert, zeigt `vmstat`
Informationen zum Slab Allocator an. Das ist ein Verfahren zur Verwaltung
des Arbeitsspeichers. Weitere Informationen dazu finden sich in
[[Bonwick1994](#bib-bonwick1994)].

Mit Option `-d` zeigt `vmstat` einmalig Diskstatistiken für alle Disk
Devices an, das können auch RAM-Disks und Loop Devices sein.
Dabei bedeuten:

*Reads/Writes*
: für Lese-/Schreib-Zugriffe:

  *total*
  : alle erfolgreichen Zugriffe

  *merged*
  : gruppierte Zugriffe, die in einem I/O-Vorgang resultieren

  *sectors*
  : erfolgreich gelesene/geschriebene Sektoren

  *ms*
  : Anzahl der lesend/schreibend verbrachten Millisekunden

*I/O*
: Unter `cur` die gerade laufende I/O und unter `s` die
  Sekunden, die das System mit I/O verbracht hat.

Mit Option `-D` zeigt `vmstat` einmalig zusammengefasste Statistiken zu
allen Disks.

Und mit `-p $partition` schließlich zeigt `vmstat` einmalig Statistiken für
diese Partition. Hierbei bedeuten in der Ausgabe:

*reads*
: die Gesamtzahl der Lesezugriffe auf diese Partition

*read sectors*
: die Gesamtzahl der gelesenen Sektoren dieser Partition

*writes*
: die Gesamtzahl der Schreibzugriffe auf diese Partition

*requested writes*
: die Gesamtzahl der Schreibanforderungen für diese Partition


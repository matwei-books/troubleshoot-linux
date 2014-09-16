
## Mount-Fehler {#sec-mount-fehler}

Wenn ganze Dateisysteme nicht verfügbar sind oder nicht ausgehängt werden
können, habe ich es mit einem Mountproblem zu tun.
Kann ich ein Dateisystem nicht einhängen, kann das vielfältige Ursachen haben.
Kann ich es nicht aushängen, hängt das sehr oft an geöffneten Dateien.

### mount: / is busy

Dieser Fehler tritt bei `umount` auf, aber auch, wenn ich ein
Dateisystem von read-write auf read-only umhängen will.
Die Meldung `is busy` deutet es schon an, der Kernel, genauer gesagt,
das Dateisystem ist beschäftigt.
Wenn ich das Dateisystem aushängen will, reicht ein Prozess, der auf
irgendeine Art auf das Dateisystem zugreift. Will ich es read-only umhängen,
muss ich nach Prozessen suchen, die Dateien zum Schreiben geöffnet haben.
In [[Weidner2012](#bib-weidner2012)] habe ich einen solchen Fall detailliert
beschrieben, hier gehe ich nur kurz auf die Schritte ein um die
betreffenden Prozesse und die geöffneten Dateien zu finden.

A> ### Offene gelöschte Dateien
A> 
A> Auch Dateilöschungen sind Schreibzugriffe. Wenn
A> Systembibliotheken aktualisiert werden, dann wird der Verweis auf
A> die alte Datei mit dem
A> Systembefehl `unlink()` gelöscht und die neue Datei mit dem gleichen
A> Namen gespeichert. Neu gestartete Prozesse verwenden die neue
A> Bibliothek. Prozesse, die bereits vor der Aktualisierung liefen, arbeiten
A> weiter mit der alten Bibliothek, weil sie diese vor der Aktualisierung
A> geöffnet hatten.
A> 
A> Abgesehen von möglichen Sicherheitsproblemen, die die alte Bibliothek
A> hat und damit auch die alten Prozesse, kann ich nun das
A> Dateisystem mit der alten Bibliothek nicht read-only umhängen.
A> Diese ist zwar nicht mehr im Dateisystem verlinkt, die
A> betreffenden Blöcke werden aber erst freigegeben, wenn der letzte
A> Prozess, der sie verwendet, beendet ist.
A> 
A> Das gleiche gilt für Dateien, die geöffnet und unmittelbar darauf
A> im Dateisystem gelöscht werden. Diese sind damit nur für den Prozess, der
A> sie geöffnet hat, "sichtbar".

Prozesse, die in irgendeiner Weise auf ein Dateisystem zugreifen, finde ich
am schnellsten mit:

{line-numbers=off,lang="text"}
    # fuser -vm $mntpnt

Diesen Befehl rufe ich mit den Privilegien von *root* auf, um alle Prozesse
angezeigt zu bekommen.
Dabei interessieren mich neben der PID und dem Prozessnamen (COMMAND) vor
allem die Angaben unter ACCESS. Insbesondere Prozesse mit `F` und
`m`, da diese es sind, die das read-only Umhängen des Dateisystems
verhindern.
Ich könnte diese Prozesse mit Option `-k` gleich von fuser beenden
lassen, aber besser ist es, erst mit

{line-numbers=off,lang="text"}
    # lsof -p $pid
    
nachzuschauen, welcher Prozess das genau ist und welche Dateien er offen hält.
Auch kann ich dann mit

{line-numbers=off,lang="text"}
    # pstree -p
    
abschätzen, ob ich
vitale Systemfunktionen beende, wenn ich den Prozess einfach abschieße.
Handelt es sich um einen Systemdienst, wie SSH, dann ist oft der
Listening-Daemon bereits neu gestartet und nur die Instanz, über die ich
angemeldet bin, verwendet noch die alte Bibliothek.
In diesem Fall reicht es meist, wenn ich mich ein zweites Mal anmelde und
danach die alte Verbindung trenne.

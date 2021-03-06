
## sysstat {#sec-lokal-werkzeuge-sysstat}

Das Paket *sysstat* enthält Accounting-Programme, mit denen ich den
Ressourcenbedarf des Systems erfassen kann.

Üblicherweise startet `cron` aller 10 Minuten ein Skript,
das die Systemstatistiken sichert.
Diese Statistiken kann ich mit verschiedenen Auswertewerkzeugen auslesen.

Alternativ können diese Werkzeuge selbst periodisch die
Performancedaten sammeln und als aktuelle Schnappschüsse ausgeben.

Zur Auswertung mit sysstat stehen die folgenden Werkzeuge zur Verfügung:

*cifsiostat*
: liefert CIFS Statistiken

*iostat*
: liefert CPU- und I/O-Statistiken für Geräte und Partitionen

*mpstat*
: liefert (multi-)prozessorbezogene Statistiken

*nfsiostat*
: liefert NFS-bezogene I/O-Statistiken

*pidstat*
: liefert Statistiken über Linux-Tasks (-Prozesse)

*sar, sadf*
: *sar* sammelt, berichtet und sichert Informationen zu
  Systemaktivitäten, *sadf* gibt die von *sar* gesammelten Daten in
  verschiedenen Formaten aus.

Die Auswertung der Statistikdaten mit *sar* ist in
[[Loukides1996](#bib-loukides1996)] beschrieben.
Da sich die Software seitdem weiterentwickelt hat, ist ein Blick in die
Handbuchseiten unerlässlich.

Für die grafische Auswertung gibt es verschiedene Programme.
Ein Programm, *sargraph*, wird als Beispiel mit sysstat verteilt.
Dieses wertet
die XML-Ausgabe von sadf aus und übergibt sie an gnuplot zur Darstellung.


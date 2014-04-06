
## acct {#sec-lokal-werkzeuge-acct}

Abrechnungsprogramme spielen eine wichtige Rolle bei der
Performanceoptimierung.
Sie liefern einen einfachen Weg um herauszufinden, was ein Rechner macht.
Welche Anwendungen laufen, wieviel Systemzeit verbrauchen
diese Programme, wie stark belasten sie das System, und so weiter.
Wenn ich die Programme und ihr Verhalten im Großen und Ganzen kenne,
kann ich mir eine Strategie überlegen, um die Performance zu optimieren.
Das Programmpaket acct liefert diese Abrechnungsdaten.

Natürlich belastet das Führen der Statistiken das System zusätzlich.
Und Extra-Plattenplatz benötigen die Statistiken auch.
Andererseits: wenn das System deutlich auf das Einschalten der
Statistikerfassung reagiert, arbeitet es bereits in einem Bereich nahe der
Belastungsgrenze und eine Analyse der Systemperformance und entsprechende
Maßnahmen sind längst fällig.

Ist das Paket acct installiert, so wird das Accounting meist automatisch
beim Systemstart via accton eingeschaltet.
Will ich es deaktivieren, reicht es nicht, es über das Startscript
auszuschalten, da cron in regelmäßigen Abständen die Komprimierung der
Protokolle anstößt und dabei das Accounting ab und wieder angeschaltet wird.
Um das Accounting zu deaktivieren ändere ich bei Debian-Systemen in
*/etc/default/acct* die Variable `ACCT_ENABLE` auf 0.

Die Abrechnungsdaten werte ich mit dem Programm `sa` aus.
`sa` gibt eine Tabelle aus mit einer Zeile pro Programm,
der Anzahl der Aufrufe des Programms in der ersten Spalte und den
folgenden Bezeichnungen in den anderen Spalten:

*cpu*
: die Summe von von CPU-System- und -Userzeit in CPU-Minuten

*re*
: die ``wirkliche'' Laufzeit des Programms

*k*
: der durchschnittliche Speicherverbrauch in KByte. Der
  Durchschnitt basiert auf der CPU-Zeit des Programms.

*avio*
: die durchschnittliche Anzahl von I/O-Operationen pro Programmaufruf

*tio*
: die Gesamtzahl der I/O-Operationen

*k*sec*
: das Integral über den Speicher und die CPU-Zeit

*s*
: die Systemzeit

*u*
: die Benutzerzeit

Ganz rechts, ohne Bezeichnung steht der Programmname.  
Ist dieser mit einem Asterisk ('*') gekennzeichnet, ist das Programm als
Daemon gelaufen. Das heißt, es hat `fork()` aufgerufen, aber nicht
`exec()`. Daemon-Prozesse sammeln durch ihre lange Laufzeit auch sehr
viel CPU-Zeit an.

Die Tabelle ist nach der CPU-Zeit absteigend sortiert.

Programme, die nur einmalig gelaufen sind, werden in der Zeile
`***other*` zusammengefasst.

Mit den folgenden Optionen kann ich die Ausgabe von sa modifizieren, die
Handbuchseite kennt noch mehr davon:

*-a | --list-all-names*
: Zeigt alle Programme (fasst keine Programme unter
  `***other*` zusammen).

*-b | --sort-sys-user-div-calls*
: Sortiert die Aufrufe nach der
  CPU-Zeit geteilt durch die Anzahl der Aufrufe.

*-d | --sort-avio*
: Sortiert nach der durchschnittlichen Anzahl der
  I/O-Operationen.

*-D | --sort-tio*
: Sortiert nach der Gesamtzahl der I/O-Operationen.

*-i | --dont-read-summary-file*
: Ignoriert die Auswertungsdatei. Mit
  dieser Option zeigt sa die Prozesse seit dem letzten Aufruf von 
  `sa -s`.

*-k | --sort-cpu-avmem*
: Sortiert nach dem durchschnittlichen
  Speicherverbrauch. Dieser Report identifiziert die größten
  Speichernutzer.

*-n | --sort-num-calls*
: Sortiert nach der Anzahl der Aufrufe,
  identifiziert die am häufigsten aufgerufenen Programme.

*-r | --reverse-sort*
: Dreht die Sortierreihenfolge um.

*-s | --merge*
: Fasst die aktuellen Accountingdaten in der
  Auswertungsdatei zusammen.

*-t | --print-ratio*
: Zeigt das Verhältnis von Laufzeit zu CPU-Zeit,
  identifiziert Programme mit sehr viel Leerlauf.


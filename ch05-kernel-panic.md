
## Kernel Panic

Eine Kernel Panic ist eine Meldung des Kernels nachdem ein Fehler auftrat,
auf Grund dessen sich das Betriebssystem in einem undefinierten Zustand
befindet und nicht mehr kontrolliert weiter betrieben werden kann.
Diese Meldung erscheint auf der Konsole zusammen mit weiteren Informationen,
die für Laien meist unverständlich sind, dem Experten jedoch manchmal einen
Hinweis auf die Ursache geben.
Anschließend hält das Betriebssystem an.

### Konsolenausgaben protokollieren

Um diese Informationen für spätere Auswertungen festzuhalten, kann ich
eine serielle Schnittstelle als Konsole verwenden und deren
Ausgaben auf einem anderen Rechner protokollieren.
Bei virtuellen Maschinen zum Beispiel auf dem Hostsystem.
Dazu muss ich dem Kernel beim Systemstart mitteilen, dass ich - zusätzlich zur
normalen Konsole - eine serielle Schnittstelle verwenden will.
Das geht mit folgender Option in der Kernel-Kommandozeile des Bootloaders:

{line-numbers=off,lang="text"}
    console=ttyS0,38400

Damit behandelt der Kernel die erste serielle Schnittstelle als Konsole und
stellt eine Schnittstellengeschwindigkeit von 38400 Baud ein.
Die Konsolenausgabe kann ich in einer Datei protokollieren und bei Bedarf
auswerten.

### Crash-Dumps

Falls die Konsolenmeldungen nicht ausreichen, um das dahinter liegende Problem
zu bestimmen, habe ich bei einem neueren Kernel die Möglichkeit, im Fall einer
Kernel Panic mit kdump einen Dump des Kernelspeichers auf ein geeignetes
Medium schreiben zu lassen.
Kdump verwendet den *kexec* Systemaufruf, um einen Dump-Capture-Kernel zu
starten mit dem ich einen Speicherabzug des alten Kernels sichern kann.

Das Speicherabbild des alten Kernels bleibt während des Reboots erhalten und
ist für den neuen Kernel zugänglich.
Wenn der neue Kernel gestartet ist, kann ich das Speicherabbild für die spätere
Analyse mit Bordmitteln (cp, scp, ftp) sichern.
Details finden sich in der Datei *kdump/kdump.txt* in der
Kernel-Dokumentation.

Zur Analyse selbst starte ich wieder den Standard-Kernel.


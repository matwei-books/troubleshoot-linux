
## Fehlersuche im Initramfs {#sec-lokal-initramfs}

Ein wesentliches Element des Systemstarts ist das Initramfs.
Das ist ein kleines Dateisystem, das der Bootloader zusammen mit dem Kernel
in den Hauptspeicher lädt, und das für das Laden beim
Start benötigter Treiber und deren Konfiguration zuständig ist.
Damit ist es möglich, einen modularen Kernel, wie ihn die meisten
Distributionen heutzutage verwenden, an unterschiedliche Hardware
anzupassen.
Somit ist es nur noch in seltenen Fällen nötig, einen Kernel speziell für
eine bestimmte Maschine zu kompilieren.

### Wie funktioniert das Initramfs?

Beim Systemstart lädt der Bootloader sowohl den Kernel als auch das
komprimierte Initramfs in den Hauptspeicher.
Anschließend startet er den Kernel und übergibt dabei die Kerneloptionen.
Der Kernel selbst reserviert einen Teil des Hauptspeichers und erzeugt darin
ein RAM-Dateisystem.
In dieses entpackt er das Initramfs.
Anschließend startet er das Skript `init` im Wurzelverzeichnis der RAM-Disk.
Alles weitere kann ich durch Analyse dieses Skripts erschließen, das ist von
Distribution zu Distribution verschieden.

Im Rahmen der Fehlersuche beschäftige ich mich mit dem Initramfs nur,
wenn ein System nicht startet.
Dabei interessieren mich vor allem zwei Fragen:

*   Wie kann ich Fehler im Initramfs finden?

*   Wie mache ich eine gefundene Lösung permanent?

### Wie kann ich Fehler im Initramfs finden?

Ich suche den Fehler im Initramfs, wenn ich genau weiß, dass der
Fehler nach dem Start des init Skripts und vor dem Einhängen des eigentlichen
Root-Dateisystems passiert.

Bei den automatisch erzeugten Initramfs der verschiedenen Distributionen lande
ich bei Problemen manchmal in einer Shell und kann dann versuchen, mit
den Werkzeugen des Initramfs das Problem zu analysieren.
Da auf dem Initramfs fast immer `busybox` vorhanden ist, stehen mir hier oft
mehr Werkzeuge zur Verfügung, als auf den ersten Blick ersichtlich ist.

Bekomme ich keine Shell oder fehlt mir ein Werkzeug, muss ich das Initramfs
modifizieren.
Dabei kann ich das aktuelle als Ausgangsbasis nehmen.

Bei Debian-basierten Distributionen ist das Initramfs ein komprimiertes
cpio-Archiv im Verzeichnis /boot.
Dieses kann ich wie folgt entpacken:

{line-numbers=off,lang="text"}
    # zcat /boot/initrd.img-$(uname -r) | cpio -idmv

Nun kann ich in den entpackten Verzeichnissen die Skripts anpassen und
gegebenenfalls weitere Programme installieren.
Dabei muss ich darauf achten, dass alle benötigten Bibliotheken vorhanden
sind.
Das kann ich mit `chroot` überprüfen.
Anschließend baue ich ein neues Initramfs:

{line-numbers=off,lang="text"}
    # find . \
    | cpio -oH newc \
    | gzip -c > /boot/initrd-test.img

Anschließend muss ich dem Bootloader klarmachen, dass er das modifizierte
Initramfs laden soll.
Bei Grub ist das kein Problem, da ich die Booteinträge während des
Bootvorgangs modifizieren kann.
Bei anderen Bootloadern muss ich diesen gegebenenfalls neu konfigurieren
und/oder installieren.
Bei PXELINUX passe ich einfach die Datei im Verzeichnis pxelinux.cfg auf dem
TFTP-Server an, so dass das modifizierte Initramfs geladen wird.

### Wie mache ich meine Lösung permanent?

Habe ich im vorigen Schritt eine Lösung für mein Problem gefunden, dann will
ich diese dauerhaft im System verankern.
Hier kommt in's Spiel, dass der Paketmanager bei jedem Kernelupdate
oder der Installation von Kernelmodulen automatisch ein neues Initramfs erzeugt.
Dabei ignoriert er meine Änderungen, wenn ich sie nicht an den richtigen
Stellen unterbringe.

#### Permanente Änderungen bei Debian GNU/Linux

Bei Debian und darauf basierenden Distributionen sind diese Stellen:

*   /etc/initramfs-tools/scripts - für eigene Skripts

*   /usr/share/initramfs-tools/init - falls ich das init-Skript selbst
    modifizieren muss

*   /etc/initramfs-tools/modules - für zusätzliche Module

*   /etc/modprobe.d - für Moduloptionen

*   /etc/udev/rules.d - für zusätzliche udev-Regeln

Nachdem ich die Änderungen eingearbeitet habe, erzeuge ich ein Initramfs nach
Art des Hauses:

{line-numbers=off,lang="text"}
    # update-initramfs -k $(uname -r) -u

Anschließend starte ich den Rechner neu und verifiziere meine Änderungen.


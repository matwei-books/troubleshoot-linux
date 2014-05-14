
## Bootprobleme {#sec-lokal-bootprobleme}

Zwar treten Bootprobleme selten auf, wenn sie aber erstmal da sind, bekommen
sie die volle Konzentration, weil eben wirklich "nichts mehr geht".

Um die Bootprobleme eines Systems diagnostizieren und beheben zu
können, muss ich das Verhalten eines gesunden Systems beim Startvorgang
kennen. Dieses zeichnet sich durch verschiedene Phasen mit unterschiedlicher
Zuständigkeit und dementsprechend unterschiedlicher Herangehensweise aus.
Grob teile ich den Startvorgang eines Linux-Rechners in die folgenden Phasen
ein:

1.  Die Firmware des Rechners initialisiert die Hardware. Das ist bei
    einem PC gekennzeichnet durch die verschiedenen BIOS-Meldungen.
    Eingriffe an dieser Stelle sind abhängig von der konkreten
    Hardware und nicht explizit Thema dieses Buches, obwohl diese das
    Verhalten des Linux-Systems sehr wohl beeinflussen.
2.  Die Firmware lädt und startet den Bootmanager.
    Je nach Bootmanager habe ich hier bereits die Möglichkeit, das
    spätere Verhalten des Linux-Systems zu steuern.
3.  Der Bootloader als Bestandteil des Bootmanagers lädt den Kernel und
    das Initramfs und startet den Kernel. Hier werden Änderungen, die ich
    im Bootmanager vorgenommen habe, zum ersten Mal wirksam.
4.  Der Kernel nimmt die wichtigsten Systemkomponenten in Betrieb und
    startet ein Initialisierungsskript vom Initramfs. In dieser Phase kann ich
    nicht eingreifen, nur beobachten.
5.  Das Initialisierungsskript des Initramfs lädt Treiber, überprüft das
    Root-Dateisystem und hängt dieses ein. Bei einem Problem startet es
    manchmal eine Shell, in der ich dieses interaktiv bearbeiten kann.
6.  Sobald das Root-Dateisystem als rootfs eingehängt ist, übergibt das
    Initialisierungsskript an den Initd des Systems, der über Skripts weitere
    Dateisysteme einhängt sowie Hintergrunddienste und Anmeldeprogramme startet.
    Wenn dieser auf Probleme mit Dateisystemen trifft, bietet er an,
    das Problem in einer Shell - nach Eingabe eines Kennworts - zu lösen,
    oder einen Neustart zu versuchen.
7.  Sobald ich mich am System regulär anmelden kann, ist der Rechner
    benutzbar, auch wenn noch Systemteile initialisiert werden.

### Startphasen des Rechners identifizieren

Da ich, je nachdem in welcher Phase ein Problem auftritt, auf verschiedene
Weise an die Lösung herangehe, ist es wichtig, dass ich die
einzelnen Phasen erkennen und auseinander halten kann.

Dazu muss ich gegebenenfalls die nötigen Startinformationen erst freilegen.
Das können zum einen Einstellungen im BIOS sein, die abhängig von der Hard-
und Firmware und daher nicht Thema dieses Buches sind.

Viele moderne Linux-Distributionen verstecken die Informationen,
die Linux-Kernel und System auf den Bildschirm schicken.
Mit dem Bootmanager kann ich die betreffenden Kerneloptionen ändern,
um mehr Informationen zu erhalten.
So entferne ich zum Beispiel die folgenden Kerneloptionen:

*  `quiet`

*  `rhgb` bei Fedora oder Red Hat

*  `splash` bei Ubuntu

*  `splash=silent` bei OpenSuse

*  `vt.handoff=7` bei Ubuntu 11.10

Gibt es bei Grub2 in der Konfiguration die Zeile

{line-numbers=off,lang="text"}
    set gfxpayload=$linux_gfx_mode

ändere ich diese in

{line-numbers=off,lang="text"}
    set gfxpayload=text

Habe ich die Bootinformationen sichtbar gemacht, kann ich mit Ihrer Hilfe den
Bootvorgang besser diagnostizieren und die einzelnen Phasen unterscheiden.

Nach den Firmwaremeldungen meldet sich der Bootmanager.
Manchmal nur mit einer kurzen Zeile, die den Namen des Bootmanagers enthält.
Oft aber auch mit einem Menü, aus dem ich das System, welches starten soll,
auswählen kann.
Fehlt das Menü, kann ich es mit `<ESC>` oder `<TAB>` hervorrufen,
bevor der Bootloader den Kernel lädt.

Die Meldung 'Loading Kernel' oder 'Loading initial ramdisk' zeigt den Übergang
von Phase 2 zu Phase 3 an.
Dieser folgen Dutzende Kernelmeldungen zur Hardware-Initialisierung,
die bei der Kernel-Option `quiet` unterdrückt worden wären.

Eine Meldung wie 'dracut: dracut ...' bei Fedora oder 'Write protecting the
kernel ...' und Meldungen von Udev zeigen an, dass der Kernel geladen ist
und die Skripte des Initramfs die Arbeit übernommen haben.

Meldungen wie 'Switching root' und 'Welcome to xyz Linux' zeigen an, dass die
Skripte des Initramfs fertig sind und der Init-Daemon des Systems übernimmt.
Sobald ein Konsolenlogin oder grafisches Login präsentiert wird und ich mich
anmelden kann, betrachte ich den Systemstart als abgeschlossen, auch wenn im
Hintergrund noch der eine oder andere Dienst gestartet wird.

Mit dem Wissen um die Übergänge zwischen den einzelnen Phasen des Startvorgangs
kann ich mich nun den Problemen in den einzelnen Bootphasen zuwenden.

Da Probleme mit der Firmware abhängig von der konkreten Hardware sind,
behandle ich diese hier nicht weiter.
Wichtig für die Fehlersuche ist trotzdem ein grundlegendes Verständnis der
Einstellmöglichkeiten in der Firmware, weil diese Einfluss auf das Verhalten
des Kernels haben können.

### Probleme mit dem Bootloader

Bleibt nach den Selbsttests der Firmware der Bildschirm schwarz, kommt eine
Meldung wie 'Operating system not found' oder erscheinen Fehlermeldungen von
Grub, Lilo oder anderen Bootloadern, habe ich ein Problem mit dem Bootloader.

Eine mögliche Ursache ist, dass die Firmware den Bootmanager nicht gefunden
hat.
Das kann auf einen defekten Master Boot Record (MBR) hindeuten.
Möglich ist auch, dass der Bootloader nicht im MBR, sondern in einer Partition
installiert und diese nicht als bootfähig gekennzeichnet ist.
Vielleicht wurde die Bootreihenfolge im BIOS geändert oder durch einen
zusätzlich angesteckten Datenträger durcheinander gebracht.
Eventuell ist die Installation des Bootmanagers beschädigt.
Grub2 zum Beispiel speichert einen Teil des Bootmanagers direkt hinter dem MBR
vor der ersten Partition.
Vielleicht ist auch die Partition beziehungsweise das Dateisystem, welches
weitere Teile des Bootmanagers enthält, beschädigt.

A> #### Grub-Shell
A> 
A> Bei Bootproblemen kann ich den Rechner vielleicht mit der Grub-Shell starten.
A> In dieser lande ich automatisch, wenn Grub seine Dateien nicht finden kann.
A> Alternativ gelange ich dorthin, wenn ich im Auswahlmenü mit der Taste `c` die
A> Konsole oder mit `e` den Editor aufrufe.
A> Mit `help` bekomme ich alle verfügbaren Befehle angezeigt, mit `help Befehl`
A> die Hilfe zu einem Befehl.
A> Mit der Tabulatortaste greife ich auf die automatische Vervollständigung zu,
A> wo diese zur Verfügung steht.
A> Mit `boot` kann ich den Rechner schließlich mit meinen Änderungen starten
A> lassen beziehungsweise mit `reboot` ganz von vorn anfangen.
A> Das ist praktisch, wenn ich eigentlich in das BIOS wollte, aber den rechten
A> Zeitpunkt verpasst habe.
A> 
A> Wichtig ist, falls ich den Rechner mit meinen Änderungen starten konnte, dass
A> ich die Änderungen permanent in der Grub-Konfiguration ablege.
A> Wie genau, ist abhängig von der Distribution, deren Anleitung hilft mir da
A> weiter.

Wenn eine Vertauschung der Bootreihenfolge und ein zusätzlicher Datenträger
ausgeschlossen werden können, starte ich den Rechner von einem Live- oder
Rescue-System auf einer CD-ROM oder einem USB-Stick. Dann kann ich die
Systemplatte mit allen zur Verfügung stehenden Mitteln und Werkzeugen
überprüfen.

*   Ist die Partitionstabelle korrekt?

*   Sind die Dateisysteme in Ordnung?

*   Sind alle benötigten Dateien an der richtigen Stelle?

Außerdem kann ich den Bootmanager neu installieren.
Das mache ich am besten aus dem System auf der Festplatte heraus.
Dazu hänge ich die Partitionen an den korrekten Mountpoints ein und wechsle
mit `chroot` in das System.

### Probleme beim Start des Kernels

Nach dem der Bootloader den Kernel startet, bleibt das System stehen oder
startet neu.
Das passiert mitunter nach einem BIOS- oder Kernel-Upgrade oder
nach Änderungen in den BIOS-Einstellungen.
Daher versuche ich herauszubekommen, ob eine dieser Bedingungen hier vorliegt
und ob ich diese rückgängig machen kann.

Zum Test kann ich alle Peripherie (USB, seriell, parallel, ...) und
alle nicht zum Booten benötigten Komponenten entfernen.
Falls das System dann startet, füge ich nach und nach die einzelnen
Komponenten wieder hinzu, bis der Fehler wieder auftritt.

Als nächstes kann ich systematisch die verschiedenen hardwarerelevanten
Kernelparameter durchprobieren. Dann genauso die BIOS-Einstellungen und
schließlich die Kombination beider.

### Kernel Panic

Nach Ausgabe einiger Zeilen bleibt der Kernel mit der Meldung
'Kernel panic' stehen.

Das kann an einer fehlerhaften Kernkomponente, wie Prozessor, Speicher oder
Chipsatz auf dem Mainboard liegen.
Insbesondere, wenn der Kernel gleich nach dem Anlaufen mit Panic abbricht.
In diesem Fall muss ich mit den Kernelparametern experimentieren.
Manchmal hilft eine Internet-Suche nach der
gleichen Hardware in Zusammenhang mit Problemen bei Linux.

Bei Problemen mit Treibern versuche ich meist die folgenden Strategien:

*   Internet-Suche mit den Informationen aus den letzten Zeilen oberhalb
    der Abbruchmeldung

*   Suche in der Kernel-Dokumentation zu Parametern für diesen Treiber.
    Bei modularen Treibern hilft auch `modinfo -p treibername` für eine
    erste Übersicht.

*   Mit der Kerneloption `modulename.disable=1` kann ich das Laden
    dieses Treibers unterbinden.

Wenn bereits nach einigen Zeilen der Bildschirm schwarz wird oder das System
neu startet, könnte es am Grafiktreiber liegen, falls die Zeilen davor
nicht auf andere Ursachen hindeuten.

Als erstes kann ich den Standard-VGA-Textmodus mit dem Kernelparameter
`nomodeset` einschalten.
Falls das funktioniert, könnte es an einer fehlerhaften Erkennung des Monitors
liegen.
Mit `video=1024x768-24@75` gebe ich eine Auflösung von 1024x768 bei 24 Bit
Farbtiefe und einer Bildwiederholrate von 75 Hertz vor.
Funktioniert auch das, kann ich den Parameter so ändern, das er zu meinem
Monitor passt.
Sitzen die Probleme tiefer, kann ich versuchen, die Debug-Informationen des
Direct Rendering Manager (DRM) des Kernels mittels des Kernelparameters
`drm.debug=14` auszuwerten.
Auch die DRM-Treiber bieten Optionen, mit denen ich experimentieren kann.

#### Attempted to kill init

Der Prozess mit PID 1 ist abgestürzt.
Das könnte durch ein beschädigtes Initramfs verursacht sein oder, falls das
System schon mit dem Root-Dateisystem arbeitet, durch beschädigte oder
fehlende Dateien auf eben diesem.

Zur Lösung starte ich den Rechner mit einem Live- oder Rescue-System,
ermittle die genaue Ursache und repariere diese.

Alternativ, falls ich gerade nicht von einem anderen Medium starten kann,
starte ich mit dem Kernelparameter `init=/bin/sh` eine Shell anstelle des
Init-Daemons.
Dann muss ich die Initialisierungen von Hand erledigen, bevor ich
das System reparieren kann.

#### No init found ...

Der Kernel hat das Programm, das er als erstes starten soll, nicht gefunden.
Ich behandle das Problem ähnlich wie das vorige und starte ein Live- oder
Rescue-System beziehungsweise gebe mit der Option `init=...` ein
anderes Programm an.

#### Fatal Exception / Aiee, Killing Interrupt Handler

Diese Probleme können vielfältige Ursachen haben. Meist finden sich Hinweise
ein paar Zeilen weiter oben. Steht dort ein `Oops`, hat der Kernel ein
Problem erkannt und zunächst versucht weiter zu arbeiten.

Ein `Oops` ist eine Abweichung vom korrekten Verhalten des Kernels, die
eine Fehlermeldung produziert, welche via Syslog protokolliert werden kann.
Im Gegensatz dazu ist bei einem Kernel-Panic kein Logging mehr möglich.
Wenn der Kernel ein Problem entdeckt, gibt er eine `Oops` Nachricht aus und
beendet den verursachenden Prozess.
Die offizielle Dokumentation dazu findet sich in der Datei *oops_tracing.txt*
bei der Kernel-Dokumentation.
Sobald ein System einen `Oops` erlebt hat, arbeiten einige interne Ressourcen
nicht mehr korrekt.
Das wiederum kann zu weiteren `Oops` und schließlich zum Kernel-Panic führen.
Daher ist es bei der Analyse wichtig, sich zunächst auf den ersten `Oops` zu
konzentrieren.
Dabei helfen Internet-Suchen, die Dokumentation und gegebenenfalls eine Anfrage
auf der entsprechenden Mailingliste.

#### not syncing: VFS: Unable to mount rootfs on ...

Der Kernel findet sein Root-Dateisystem nicht.
Das kann an einem fehlenden oder defekten Initramfs liegen.
Oder das in der Kernel-Kommandozeile genannte Dateisystem ist nicht erreichbar.

Als erstes sehe ich mir hier die Bootloader-Konfiguration genau an.

*   Ist das Initramfs korrekt angegeben?

*   Ist das Root-Dateisystem korrekt angegeben? 

*   Ist, bei NFS-Root, der Server mit dem Rootfs erreichbar und auf ihm
    das Dateisystem?
    
Manchmal muss ich den Rechner mit einem Live- oder Rescue-System starten,
um das Problem genauer einzugrenzen und zu beheben.

### Probleme im Initramfs

Bekomme ich Meldungen wie `dracut: Warning: ...` (Fedora) oder
`Gave up waiting for root device` (Debian, Ubuntu) und anschließend einen
Shell-Prompt, dann haben die Skripts des Initramfs das Root-Dateisystem nicht
gefunden.

Mit `dmesg|less` sehe ich mir die Kernelmeldungen noch einmal an.
Dabei suche ich nach Meldungen zu den Speichersystemen.
Habe ich less nicht zur Verfügung, kann ich mit `<Shift>-<Bild auf/ab>`
blättern.
Dabei überprüfe ich, ob die Systemplatte gefunden wurde, beziehungsweise bei
NFS-Root der Netzwerkadapter.

Falls das Root-Dateisystem als UUID oder Label spezifiziert wurde, kann ich
mit `blkid` alle Label und UUIDs ausgeben lassen.
Unter */proc* und */sys* kann ich weitere Informationen zu erkannter Hardware
finden.
So liefert mir */proc/mdstat* zum Beispiel Informationen zu einem Software-RAID.

### Udev

Kurz nachdem Udev gestartet wurde, bleibt das System hängen.

In diesem Fall helfen mir die Kerneloptionen  
`udev.log_priority=info` und `udev.children-max=1`.
Damit startet Udev nur einen Kind-Prozess und gibt eine Reihe von
zusätzlichen Informationen aus.
Habe ich damit ein problematisches Modul identifiziert, kann ich dieses mit
`modulename.disable=1` in den Kernel-Optionen deaktivieren.

### Stopp bei der Dateisystemüberprüfung

{line-numbers=off,lang="text"}
    ...
    error checking filesystem
    ...
    Give root password for rescue shell or type\
     Control-D for reboot.

Der Init-Daemon hat ein Problem beim Dateisystemcheck erkannt und bietet mir
an, dieses in einer Shell zu beheben. Dazu muss ich das Kennwort von *root*
wissen.

Ein Neustart mit `<CTRL>-D` wird mir nicht weiterhelfen, da ich es hier mit
einem schwerwiegenden Problem im Dateisystem zu tun habe und beim nächsten
Start genauso weit kommen würde.

Ich brauche also das Kennwort oder eine andere Möglichkeit, eine
Root-Shell auf dem Rechner zu bekommen, wie zum Beispiel die Option
`init=/bin/sh`.

A> #### Der erste Prozess: init
A> 
A> Bei der Erläuterung des [UNIX-Prozessmodelles](#sec-unix-prozessmodell) hatte
A> ich erwähnt, dass der Lebenszyklus aller Prozesse bis auf den ersten mit dem
A> `fork()` Systemaufruf beginnt.
A> 
A> Der erste Prozess wird vom Kernel gestartet und führt traditionell das
A> Programm */sbin/init* aus.
A> Dieses Programm liest seine Konfiguration ein und startet entsprechend dieser
A> andere Prozesse, welche die Hardware initialisieren oder Dienste
A> bereitstellen.
A> Mit dem Kernelparameter `init`, den der Bootloader an den Kernel übergibt,
A> kann ich ein anderes Programm bestimmen.
A> Mit `init=/bin/sh` lege ich zum Beispiel die Standard-Shell als Startprogramm
A> fest.
A> Das ist im Normalfall nicht sinnvoll, da die Shell keinerlei
A> Initialisierung vornimmt und somit keine Dateisysteme außer dem
A> Root-Dateisystem eingehängt und auch sonst keine Dienste gestartet werden.
A> 
A> In Notfällen, wenn *init* beschädigt ist, oder ich das Kennwort von *root*
A> nicht weiß, kann ich aber die nötigen Initialisierungen selbst vornehmen
A> und damit das System wieder benutzbar machen.

Dann starte ich die Dateisystemüberprüfung von Hand für alle
benötigten Dateisysteme und starte den Rechner anschließend neu.
Läuft der Rechner wieder, muss ich nun noch schauen, welche
Dateien ich aus dem Backup ersetzen muss.

Problem erkannt, Problem gelöst. 
Oder?

Habe ich den Rechner selbst aufgesetzt und mir notiert, welche Partitionen mit
welchem Dateisystem wo eingehängt werden, dann ist es wirklich so einfach.
Bei einem fremden Rechner, oder wenn es ein älteres Gerät ist, zu dem ich keine
Aufzeichnungen habe, muss ich erst herausfinden, welche Partitionen ich
mit `fsck` überprüfen muss.

In der Bildschirmmeldung steht, bei welcher Partition die automatische
Überprüfung aufgegeben hat. Nötigenfalls kann ich mit `<Shift>-<PgUp>` nach oben
blättern, wenn die Meldung schon nach oben hinaus geschoben ist.

Je nach Alter des Rechners und verwendeter Linux Distribution steht da entweder
ein Gerätename wie /dev/sda1, ein Label wie ``rootfs'' oder eine UUID.
Das fsck-Programm erwartet als Angabe einen Gerätenamen.
Beim Label und bei der UUID muss ich die Zuordnung dafür herausbekommen.

Die Datei /etc/fstab kann ich als erste Anlaufstelle nehmen, die mir Hinweise
auf die Partition und das Dateisystem gibt.
Diese benötige ich, um das richtige Programm für die Dateisystemüberprüfung
zu verwenden.
Allerdings stehen in /etc/fstab auch nur Label beziehungsweise UUID,
die ich aus der Konsolenmeldung bereits kenne.

Mit den verschiedenen Partitionierungsprogrammen kann ich mir die
Partitionen ausgeben lassen.
Insbesondere `cfdisk` ist hier nützlich, weil es vergebene Label anzeigt, so
dass ich sie einem Gerätenamen zuordnen kann.
Bei UUID hilft es mir leider nicht.

Das Programm `blkid` zeigt mir sowohl Label als auch UUIDs an:

{line-numbers=off,lang="text"}
    # blkid
    /dev/sda1: UUID="f7...4f" TYPE="ext3" 
    /dev/sda5: LABEL="swap" UUID="bc.." TYPE="swap"

Alternativ kann ich die Gerätedateien mit `findfs` bestimmen:

{line-numbers=off,lang="text"}
    # findfs LABEL=swap
    /dev/sda5
    # findfs UUID=f779141e-...-9dde9de0b64f
    /dev/sda1

Habe ich keines dieser Programme, aber file, hilft das folgende Vorgehen
(Umbruch ist von mir eingefügt):

{line-numbers=off,lang="text"}
    # dd if=/dev/sda1 of=sda1 bs=4096 count=1
    1+0 records in
    1+0 records out
    4096 bytes (4.1 kB) copied, 0.00.. s, 14.9 MB/s
    # dd if=/dev/sda5 of=sda5 bs=4096 count=1
    1+0 records in
    1+0 records out
    4096 bytes (4.1 kB) copied, 0.00.. s, 39.5 MB/s
    # file sda1 sda5
    sda1: Linux rev 1.0 ext3 filesystem data, \
    UUID=f77...0b64f (needs journal recovery) \
    (large files)
    sda5: Linux/i386 swap file (new style), \
    version 1 (4K pages), size 1319329 pages, \
    LABEL=swap, UUID=bc3aa59f-...-cf72ce99b70b

Da `file` bei der direkten Abfrage der Gerätedateien nur deren Typ angeben
würde, kopiere ich den ersten Block des Dateisystems in eine Datei und lasse
diese von `file` analysieren.


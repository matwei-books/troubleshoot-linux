
## PID 1 - Init

Bei dem ersten vom Kernel gestarteten Prozess, habe ich es je nach Alter
und Distribution des Linux-Systems mit einem der folgenden
Programme zu tun:

*   SysVInit

*   Upstart

*   Systemd

Bei sehr alten Systemen besteht noch die Möglichkeit, dass ein BSD-Init im
Einsatz ist.
Ehrlich gesagt, habe ich das schon sehr lange nicht mehr gesehen.

### SysVInit

SysVInit ist einer der ältesten Init-Dämonen unter Linux.
Er wird über die Datei */etc/inittab* gesteuert.
Bei diesem Dämon läuft der Rechner in einem von mehreren möglichen
Runleveln, die bestimmten Systemzuständen entsprechen.
Je nachdem, in welchem Zustand sich das System gerade befindet, startet oder
beendet SysVInit die zugehörigen Dienste.

Die Runlevel selbst unterscheiden sich zwischen den Distributionen.
Die folgende Zuordnung trifft jedoch für die meisten zu:

| 0   | aus, hinunterfahren, beenden                         |
| 1/S | Systemstart, Single-User                             |
| 2-5 | Multi-User, mit Netzwerk, mit graphischer Oberfläche |
| 6   | Neustart                                             |

Den aktuellen Runlevel kann ich mit dem Befehl `runlevel` erfragen.

Für jeden Runlevel `$rl` gibt es ein Verzeichnis */etc/rc$rl.d/*, in dem sich
Skripts zum Beenden von Diensten (*K...*) und zum Starten von Diensten
(*S...*) befinden.
Bei jedem Wechsel ruft `init` ein Skript auf, das im Wesentlichen
nichts anderes macht, als die Skripts deren Namen mit K beginnt, mit der
Option `stop` aufzurufen und die Skripts, deren Name mit S beginnt, mit der
Option `start` aufzurufen.
Vergleichbar diesem Shellcode:

{line-numbers=off,lang="text"}
    for k in /etc/rc$rl.d/K*; do
        $k stop
    done
    for s in /etc/rc$rl.d/S*; do
        $s start
    done

Die Reihenfolge, in der die Skripts aufgerufen werden, hängt vom Namen der
Skripts ab.
Dieser setzt sich zusammen aus dem Buchstabe `K` oder `S`, einer
zweistelligen Zahl und dem eigentlichen Namen des Skripts.
Die Zahl bestimmt die Reihenfolge und bei gleicher Zahl der Name.
Wenn SysVInit Dienste parallel startet, dann diejenigen mit der selben Zahl.

Üblicherweise liegt das Skript im Verzeichnis */etc/init.d/* oder
*/etc/rc/init.d/* während sich in den Verzeichnissen für die Runlevel
nur ein symbolischer Link darauf befindet, dessen Name der obigen Konvention
entspricht.

Etwas komplizierter, als eben beschrieben, verläuft das Starten und Anhalten
von Diensten, wenn SysVInit mit Parallelverarbeitung läuft.
In diesem Fall müssen die Abhängigkeiten für die Startreihenfolge in allen
Skripts in Kommentarkopfzeilen beschrieben sein.
Diese Kopfzeilen beschreibt die Handbuchseite zu `insserv`.

Für das Aktivieren und Deaktivieren von Boot-Skripts empfiehlt sich auf
Debian-basierenden Systemen das Programm `update-rc.d`, welches die
erforderlichen Links von */etc/rc$rl.d/* zu den Skripts in */etc/init.d/*
anlegt.
Dieses Skript kann auf zweierlei Arten aufgerufen werden.
Im älteren (Legacy-)Modus gebe ich Reihenfolge und Runlevel auf der
Kommandozeile vor.
Im Default-Modus bestimmt es mittels `insserv` die Abhängigkeiten aus den
LSB-konformen Kommentarkopfzeilen der Skripts und berechnet damit die
Reihenfolge.

Sollte ich eine andere Reihenfolge benötigen, brauche ich
nicht die Zeilen im Skript selbst ändern, sondern kann diese mit
Dateien im Verzeichnis */etc/insserv.override/* überschreiben.

### Upstart

Insserv funktioniert auch mit dem vorwiegend für Ubuntu entwickelten und zu
SysVInit kompatiblen Programm Upstart zusammen.
Upstart arbeitet ereignisorientiert mit Jobs, die über Dateien in
*/etc/event.d/* gesteuert werden.
Dabei gibt es keine feste Reihenfolge.
Tritt ein Ereignis auf, startet Upstart parallel alle Jobs, die darauf
gewartet haben.

Eine einfache Job-Datei könnte so aussehen:

{line-numbers=off,lang="text"}
    start on event1
    stop on event2
    exec /path/to/script

Mit `start on` und `stop on` gebe ich an, bei welchen Ereignissen der Job
gestartet oder angehalten werden soll.
Nach `exec`  folgt das Programm, welches Upstart aufruft.
Dabei erwartet Upstart im Gegensatz zu SysVInit, dass das Programm im
Vordergrund läuft, so dass Upstart mitbekommt, wenn der Prozess endet und
dann entsprechende Ereignisse, wie `stopped $job` erzeugen kann.

Von Hand kann ich die Jobs mit

{line-numbers=off,lang="text"}
    # initctl start $job

starten und mit

{line-numbers=off,lang="text"}
    # initctl stop $job

beenden.

{line-numbers=off,lang="text"}
    $ initctl list
    avahi-daemon start/running, process 657
    ...
    ureadahead stop/waiting

zeigt mir den Zustand aller bekannten Jobs und

{line-numbers=off,lang="text"}
    $ initctl status dbus
    dbus start/running, process 599

zeigt den Status eines einzelnen Jobs, in diesem Fall von dbus.

Beim Beenden eines Jobs kümmert sich Upstart nur um den per `exec` angegebenen
Prozess.
Diesem sendet es zunächst ein SIGTERM und, falls er sich nicht schnell genug
beendet, ein SIGKILL.

Mit den Befehlen `pre-stop` und `post-stop` in der Beschreibung des Jobs kann
ich Befehle angeben, die Upstart vor und nach Beenden des Dienstes ausführen
soll.
Damit kann ich das System aufräumen und übrig gebliebene PID-Dateien entfernen.

Analog gibt es mit `pre-start` und `post-start` Anweisungen für den Start
eines Jobs.
Allerdings wird `post-start` gemeinsam mit dem Job ausgeführt, da Upstart
nicht einschätzen kann, wann genau der Job gestartet ist und läuft.

Anstelle von `exec` oder eben genannter Befehle kann ich auch einen
Befehlsblock setzen, den ich mit `script` und `end script` einfasse.

{line-numbers=off,lang="text"}
    pre-start script
      if [ ! -e /var/run/job ]; then
        mkdir -p /var/run/job
      fi
    end script

Eine weitere Möglichkeit in die Steuerung von Upstart einzugreifen, ist das
Erzeugen eines Ereignisses mit 

{line-numbers=off,lang="text"}
    # initctl emit $event

Damit kann ich zum Beispiel über Udev Reaktionen auslösen, wenn ein Stück
Hardware angesteckt oder abgezogen wird.

Für die Fehlersuche wichtiger ist, dass ich damit gezielt einzelne Details von
Upstart untersuchen kann, indem ich ein Ereignis vorgebe und die Reaktion der
Programme beobachte.

### Systemd

Mit Systemd ist nach Upstart ein zweites modernes Programm für die
Systeminitialisierung und Ressourcenverwaltung am Start.
Neben dem parallelen Start von Hintergrunddiensten, den bereits Upstart und
ansatzweise auch SysVInit beherrschen, ist ein wesentliches Merkmal von
Systemd, dass ich Abhängigkeiten zwischen Diensten nicht explizit festlegen
muss.

Damit Systemd Hintergrunddienste ohne explizite Konfiguration der
Abhängigkeiten parallel starten kann, nutzt es die sogenannte
Socket-Aktivierung.
Das bedeutet, dass Systemd die Sockets anlegt, über die die verschiedenen
Dienste miteinander kommunizieren, wie */dev/log* für den
Protokolldienst.
Anschließend übergibt es die Sockets den Diensten beim Start.
Der Kernel blockiert einen Prozess, der in einen Socket schreibt, bis
ein anderer Prozess aus diesem Socket liest.
Umgekehrt wird ein lesender Prozess blockiert, bis ein anderer Prozess in
den Socket geschrieben hat.
Auf diese Weise aktiviert der Kernel die einzelnen Dienste automatisch, wenn die
Gegenstelle am Socket verfügbar ist.

Das hat den zusätzlichen Vorteil, dass ich einen abgestürzten Dienst einfach neu
starten kann, ohne dass andere mit dem Socket verbundene Programme die
Verbindung verlieren.
Da der Kernel eingehende Anfragen puffert, kann der neue Dienst dort
fortfahren, wo der alte aufgehört hat.

Die Aufgaben von Systemd sind in Units organisiert.
Für jede Aufgabe benötige ich eine Konfigurationsdatei für die entsprechende
Unit.
Diese Dateien liegen im Verzeichnis */lib/systemd/system/*.
Gibt es eine gleichnamige Datei unter */etc/systemd/system/*, ignoriert
Systemd die Datei unter */lib/*.
So ist es möglich, die Konfiguration dauerhaft an das eigene System
anzupassen, ohne Gefahr zu laufen, dass die Änderungen bei der nächsten
Aktualisierung des Systems überschrieben werden.

Mit dem Befehl `systemctl` kann ich mir eine Liste der Units ausgeben lassen.

Es gibt verschiedene Typen von Units, die Systemd an der Endung des
Dateinamens erkennt:

.service
: Service-Units, die sich um Dienste kümmern, welche SysVInit meist über
  Init-Skripts startet oder beendet.

.mount
: Units zum Ein- und Aushängen von Dateisystemen

.path
: Die spezifizierten Dateien und Verzeichnisse werden mit *inotify*
  überwacht.

.socket
: Ein oder mehrere Sockets, für die Socket-Aktivierung.
  Für den Start der zugehörigen Dienste ist jedoch eine Service-Unit
  zuständig.

.target
: Gruppen von Units.
  Diese machen selbst wenig, aktivieren aber andere Units.

  Beim Hochfahren des Systems ruft Systemd die Unit namens `default.target`
  auf.
  Das ist meist nur ein Link auf eine andere Unit wie zum Beispiel
  `multi-user.target`.

Systemd steckt jeden Dienst beim Start in eine nach dem Dienst benannte
Control Group, eine Prozessgruppe.
Bei modernen Kerneln kann ich darüber Prozesse isolieren und Ressourcen
steuern.
Da Kindprozesse die Gruppenzugehörigkeit erben, können diese Prozessgruppen
als Einheit verwaltet werden und alle zugehörigen Prozesse beim Beenden eines
Dienstes zuverlässig beendet werden.

Sehr häufig setze ich das Programm `systemctl` bei der Fehlersuche ein.
Ohne Argumente zeigt dieses mir eine Liste der Units an.
Da das sehr viele sein können, kann ich mit den entsprechenden Optionen die
Auswahl einschränken.

{line-numbers=off,lang="text"}
    # systemctl --type=service

Dieser Befehl zeigt mir alle Service-Units an.

{line-numbers=off,lang="text"}
    systemctl status ntpd.service

Damit bekomme ich weitere Informationen zum NTP-Dienst.
Unter anderem den Zeitpunkt des Abbruchs und den Fehlercode, bei Units,
die in der Liste als `failed` markiert sind.

Wie bereits erwähnt fassen Target-Units mehrere Units zusammen.
Diese bieten damit ein Konzept, das den Runlevels bei SysVInit ähnelt.
Ohne weitere Angaben aktiviert Systemd die Unit *default.target*.
Will ich beim Systemstart eine andere Unit, kann ich diese im Bootloader auf
der Kernel-Kommandozeile angeben:

{line-numbers=off,lang="text"}
    systemd.unit=rescue.target

Will ich im Betrieb umschalten, geht das zum Beispiel mit 

{line-numbers=off,lang="text"}
    # systemctl isolate multi-user.target

Um eine Unit permanent zum Standard zu machen, passe ich den symbolischen Link
von `default.target` an, so dass er auf die gewünschte Unit verweist.

Mit dem Befehl `show` liefert systemctl weitere Informationen zu den laufenden
Units.

Um eine Service-Unit permanent zu deaktivieren, verwende ich

{line-numbers=off,lang="text"}
    # systemctl disable $unit.service

Das wirkt sich jedoch erst auf den nächsten Systemstart aus.
Um den Dienst sofort zu beenden oder zu starten, verwende ich 

{line-numbers=off,lang="text"}
    # systemctl stop $unit.service
    # systemctl start $unit.service

Um herauszufinden, welche Prozesse zu einem Dienst gehören, kann ich
`systemd-cgls` verwenden, oder

{line-numbers=off,lang="text"}
    # ps xaw -eo pid,args,cgroup

Treten Probleme beim Systemstart auf, kann ich die folgenden Kernelparameter
beim Bootloader angeben:

{line-numbers=off,lang="text"}
    systemd.log_target=kmsg systemd.log_level=debug

Damit landen die Fehlermeldungen im Kernelpuffer und können später mit `dmesg`
betrachtet werden.

Über die systemctl-Befehle `poweroff`, `halt` und `reboot` kann systemd
das System ausschalten, anhalten und neu starten.
Mit `systemctl kexec` kann ich darüber hinaus direkt einen vorkonfigurierten
Kernel vom laufenden Kernel starten lassen und so das System unter Umgehung
von BIOS und Bootloader neu starten.

Seit einiger Zeit enthält Systemd ein Journal, welches die Meldungen
aufzeichnet, die die Dienste an den Syslog-Dämon senden oder auf Kommandozeile
ausgeben.
Diese Meldungen kann ich mit dem Befehl `journalctl` ansehen und filtern.

{line-numbers=off,lang="text"}
    # journalctl -u sshd

zeigt zum Beispiel alle Meldungen des SSH-Dienstes an.
Journalctl kann die Ausgabe auch nach einzelnen Programmen oder Geräten
filtern:

{line-numbers=off,lang="text"}
    # journalctl /sbin/dhclient
    # journalctl /dev/sd?

Bei einigen Distributionen, Fedora wäre zu nennen, kann Systemd bereits aus
dem Initramfs starten.

Seit einiger Zeit ist es möglich Timer-Units anzulegen, die andere Units zu
bestimmten oder wiederkehrenden Zeitpunkten starten können.
Damit kann Systemd Aufgaben von `cron` und `at` übernehmen.


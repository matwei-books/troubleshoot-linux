
## Bootprobleme virtueller Maschinen {#sec-lokal-bootprobleme-vm}

### Partitionen von Festplattenimages einhängen {#sec-mount-hdimage-partition}

Bei Problemen mit dem Start von virtuellen Maschinen ist es oft hilfreich,
wenigstens die Bootpartition der betroffenen VM zu untersuchen.

Manchmal kann
ich dazu das Festplattenimage der defekten VM einfach einer anderen VM
zuordnen und es von dieser aus untersuchen.
Das erscheint zumindest bei grafischen Oberflächen für die Administration
als der einfachste Weg.
Allerdings muss ich dann immer zwischen dem Hostsystem beziehungsweise der
Administrationsoberfläche und der VM, mit der ich das Festplattenimage
untersuche, wechseln.
Dadurch verliere ich Zeit beim Zuordnen, Ein- und Aushängen und den
Startversuchen.

Besser ist in meinen Augen, die Partitionen des betroffenen Images gleich im
Hostsystem für die Analyse und Störungsbeseitigung einzubinden und die
Vorteile der Shell für zügiges Arbeiten zu nutzen.

Dann habe ich das Problem, dass ich auf dem Hostsystem nicht, wie bei den
eigenen Festplatten, die Partitionen direkt zur Verfügung habe, sondern nur
das Komplettimage der Festplatte für die VM.
Und dieses beginnt nicht mit dem Dateisystem sondern mit der Partitionstabelle.
Um die gewünschte Partition einzubinden, muss ich dem Mount-Befehl den Offset
der Partition mitgeben.

Den Offset kann ich mit dem Programm fdisk bestimmen.
Dieses listet mit der Option `-l` die Partitionen und deren Offsets auf.
Da ich letztere genau bestimmen muss, verwende ich zusätzlich die Option
`-u`, damit fdisk die Offsets als Anzahl von Sektoren zu je 512 Byte ausgibt:

{line-numbers=off,lang="text"}
    # fdisk -l -u /dev/camion/ssh3 

    Disk /dev/camion/ssh3: 4294 MB, 4294967296 bytes
    255 heads, 63 sectors/track, 522 cylinders, total\
     8388608 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 4096 bytes
    Disk identifier: 0x000c48f7

                Device Boot      Start         End\
          Blocks   Id  System
    /dev/camion/ssh3p1            2048     7706623\
         3852288   83  Linux
    /dev/camion/ssh3p2         7708670     8386559\
          338945    5  Extended
    Partition 2 does not start on physical sector \
    boundary.
    /dev/camion/ssh3p5         7708672     8386559\
          338944   82  Linux swap

Der Offset für die Systempartition `ssh3p1` ist {$$}512 \times 2048{/$$},
also {$$}1048576{/$$}.
Damit kann ich diese Partition im Hostsystem wie folgt einhängen:

{line-numbers=off,lang="text"}
    # mount /dev/camion/ssh3 /tmp/mnt \
            -o loop,offset=1048576

Wenn ich fertig bin, hänge ich die Partition normal mit umount wieder aus.

Wichtig ist, dass ich die Partition im Hostsystem nur einhänge, wenn die VM
nicht läuft.
Das ist beim Untersuchen von Bootproblemen meist gegeben.
Bei laufenden VMs habe ich mit LVM die Möglichkeit, einen Snapshot anzufertigen
und diesen Snapshot nur-lesend einzuhängen.
Dabei muss ich bedenken, dass Dateien, die in der VM geöffnet waren,
vermutlich in einem inkonsistenten Zustand sind.

A> #### Reparatur mit chroot
A> 
A> Manchmal geht die Reparatur eines Systems einfacher, wenn ich den Datenträger
A> in einem anderen System (Live-System von DVD oder Reparatursystem bei
A> einer VM) einhänge und mit `chroot` in das defekte System wechsle.
A> Damit die chroot-Umgebung funktioniert, benötige ich mehr als nur das
A> Dateisystem.
A> Viele Programme greifen auf die Informationen des *proc*, *dev* und *sys*
A> Dateisystems zurück, die ich ohne Vorkehrungen nicht in der chroot-Umgebung
A> habe.
A> Darum gehe ich wie folgt vor:
A> 
{line-numbers=off,lang="text"}
A>     # mount /dev/sdXY /mnt/rescue
A>     # mount /dev/sdXZ /mnt/rescue/boot
A>     # mount -o bind /dev /mnt/rescue/dev
A>     # mount -o bind /sys /mnt/rescue/sys
A>     # mount -o bind /proc /mnt/rescue/proc
A>     # chroot /mnt/rescue
A> 
A> Dann kann ich, zum Beispiel, aus der chroot-Umgebung heraus den Bootlader
A> *grub* mit `grub-install /dev/sdX` erneut im MBR installieren.
A> Oder mit `update-grub` die Steuerdatei neu zusammensetzen lassen.


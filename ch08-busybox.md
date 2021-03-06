
## busybox {#sec-lokal-werkzeuge-busybox}

Busybox kombiniert Mini-Versionen vieler gebräuchlicher UNIX-Befehle in einem
Programm.
Es ist mit Blick auf Größenoptimierung und geringen Ressourcenverbrauch
geschrieben.
Für ein arbeitsfähiges System benötige ich nur noch ein */dev*
Verzeichnis mit den Gerätedateien, ein */etc* Verzeichnis mit den
Konfigurationsdateien und einen Linux-Kernel.
Busybox ist extrem anpassungsfähig.
Beim Kompilieren kann ich festlegen, welche Befehle hineinkommen und
so die Funktionalität gegen die Programmgröße abwägen.
Das macht es ideal für eingebettete Systeme und kleine Systemumgebungen.

Damit bin ich beim Punkt, warum man Busybox kennen sollte.
Es befindet sich auf dem InitRamFS, dem ersten Dateisystem, das zusammen mit
dem Kernel vom Bootloader geladen wird.
Auf Live-CDs, beim Netboot und bei Rescue-Disks kann ich mit Busybox rechnen.
Auch in kleineren Einzelgeräten, wie Routern, wird es oft eingesetzt.

Busybox ist ein Multi-Call-Binary.
Das heißt, es verhält sich komplett anders, je nachdem, wie es aufgerufen
wird.
Sämtliche enthaltenen UNIX-Befehle kann ich auf zwei Arten aufrufen.
Entweder ich gebe den Befehl als erstes Argument und danach dessen Argumente
an:

{line-numbers=off,lang="text"}
    $ /bin/busybox cp file file.bak

Oder ich erzeuge einen Link auf Busybox mit dem Namen des Befehls und rufe
es über diesen Link auf:

{line-numbers=off,lang="text"}
    $ /bin/busybox ln -s /bin/busybox ./cp
    $ ./cp file file.bak

Hieße der Link stattdessen `mv`, hätte `busybox` die Datei nicht kopiert
sondern umbenannt.

Weil Busybox extrem konfigurierbar ist, möchte ich vielleicht wissen, welche
Funktionen mein konkretes Binary kennt.
Dazu rufe ich Busybox ohne Argumente auf:

{line-numbers=off,lang="text"}
    $ busybox
    BusyBox v1.18.5 (Ubuntu 1:1.18.5-1ubuntu4.1) \
    multi-call binary.
    Copyright (C) 1998-2009 Erik Andersen, Rob Landley, \
    Denys Vlasenko
    and others. Licensed under GPLv2.
    See source distribution for full notice.

    Usage: busybox [function] [arguments]...
       or: busybox --list[-full]
       or: function [arguments]...

        BusyBox is a multi-call binary that combines \
        many common Unix
        utilities into a single executable. Most people \
        will create a
        link to busybox for each function they wish to \
        use and BusyBox
        will act like whatever it was invoked as.

    Currently defined functions:
        [, [[ , acpid, addgroup, adduser, adjtimex, ar, \
        arping, ash, awk,
        ...
        xargs, xz, xzcat, yes, zcat

Da die in Busybox implementierten Versionen der UNIX-Befehle von den
täglich benutzten in Details abweichen, muss ich die genauen Optionen wissen.
Neben der Handbuchseite, die ich in einer kleinen Umgebung oft
nicht zur Verfügung habe, hilft mir Busybox selbst.
Ich rufe den Befehl mit der Option `--help` auf, welche die meisten der
implementierten Befehle verstehen:

{line-numbers=off,lang="text"}
    $ busybox ln --help
    BusyBox v1.18.5 (Ubuntu 1:1.18.5-1ubuntu4.1) \
    multi-call binary.

    Usage: ln [OPTIONS] TARGET... LINK|DIR

    Create a link LINK or DIR/TARGET to the specified \
    TARGET(s)

    Options:
        -s  Make symlinks instead of hardlinks
        -f  Remove existing destinations
        -n  Don't dereference symlinks - treat like \
            normal file
        -b  Make a backup of the target (if exists) \
            before link operation
        -S suf  Use suffix instead of ~ when making \
            backup files


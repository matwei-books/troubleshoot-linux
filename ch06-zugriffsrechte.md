
## Zugriffsprobleme {#sec-lokal-zugriffsrechte}

Ein Indiz für ein Zugriffsproblem ist zum Beispiel ein fehlgeschlagener
Systemaufruf, den ich in der Ausgabe von *strace* finden kann, wie diesen hier:

{line-numbers=off,lang="text"}
    open("abc", O_RDONLY) = -1 EACCES (Permission denied)

Um Zugriffsprobleme analysieren zu können, muss ich die Grundlagen
der Zugriffskontrolle verstehen. Außerdem ist ein minimales Verständnis der
Rolle von Dateien und Verzeichnissen nötig, wie im Grundlagenkapitel zu Linux
gegeben.

Ich beginne meine Betrachtungen mit der traditionellen benutzerbestimmten
Zugriffskontrolle (discretionary access control, DAC) und komme danach
zu erweiterten Dateiattributen, Capabilities, AppArmor und SELinux.

Allen Mechanismen für Zugriffskontrolle gemeinsam ist, dass in dem Moment
die Zugriffsrechte geprüft, und gewährt oder verweigert werden,
in dem ein Subjekt - ein Prozess - eine Aktion, wie zum Beispiel Lesen oder
Schreiben, auf ein Objekt - eine Datei - anwenden will,

### Traditionelle Unix-Dateirechte

Im traditionellen Zugriffsmodell führt das Dateisystem die Informationen über
die Zugriffsrechte zusammen mit den Informationen über den Eigentümer und die
Gruppe der Datei im Inode,
und zwar als Bitmap mit je drei Bits, die die grundlegenden Rechte für den
Dateieigentümer, die Gruppe sowie alle anderen bestimmen.
In dieser Reihenfolge prüft der Kernel auch die Rechte gegen die UID und GID
des Prozesses.

#### Grundlegende Rechte

Mit dem Leserecht (**r**, read) darf ein Prozess Daten aus regulären und
Gerätedateien lesen und Verzeichnisse auflisten.

Hat ein Prozess das Schreibrecht (**w**, write), darf er Daten in reguläre
Dateien und Gerätedateien schreiben.
Bei Verzeichnissen bedeutet es, dass er Einträge neu anlegen beziehungsweise
entfernen darf, unabhängig von den Rechten der Datei, auf die
der betreffende Eintrag verweist.
Somit ist es möglich, eine Datei zu löschen oder umzubenennen, auf die ein
Prozess keine Schreib- oder Leserechte besitzt.
Das wird klar, wenn ich mir vor Augen halte, dass ein
Verzeichniseintrag nichts weiter ist, als ein Name für und ein Verweis auf
eine Datei und nur insofern die Eigenschaften der Datei beeinflusst als im
Inode gezählt wird, wie viele Verweise auf die Datei es gibt.
Erst, nachdem der letzte Verweis entfernt wurde, gibt der Kernel den von der
Datei belegten Speicherplatz wirklich frei.

Das Ausführrecht (**x**, execute) bei einer regulären Datei bedeutet, dass
ein Prozess sie ausführen kann.
Dabei ist bei einer Binärdatei nicht einmal das Leserecht auf diese Datei nötig.
Bei einem ausführbaren Skript benötigt der Prozess das Leserecht, da der
Skript-Interpreter die Datei lesen muss, um ihr Programm abzuarbeiten.
Bei einem Verzeichnis bedeutet das **x** Bit, dass der Prozess in das
Verzeichnis wechseln und darin verzeichnete Dateien benutzen darf.
Dafür braucht er kein Leserecht, wenn er den Namen der Datei kennt.

#### Sonderrechte

Zusätzlich zu den Standardrechten gibt es drei Bits für Sonderrechte.

Bei einer ausführbaren Datei mit gesetztem  *setuid* Bit ändert sich die UID
des ausführenden Prozesses zu der der Datei.

Das *setgid* Bit bei einem Verzeichnis bewirkt, dass in diesem Verzeichnis
neu angelegte Dateien automatisch der Gruppe des Verzeichnisses anstelle der
aktiven Gruppe des erzeugenden Prozesses zugeordnet werden.

In Verzeichnissen mit gesetztem  *sticky* Bit dürfen nur *root* oder der
Eigentümer einer Datei diese löschen.
Dieses Bit ist üblicherweise beim */tmp/* Verzeichnis gesetzt:

{line-numbers=off,lang="text"}
    $ ls -ld /tmp/
    drwxrwxrwt 16 root root 12288 Mai 21 08:17 /tmp/

Bei einer ausführbaren Datei bewirkte das *sticky* Bit früher, dass der
Programmcode nach der Ausführung im Hauptspeicher verblieb. 
Das brachte Vorteile bei Programmen, die sehr häufig benutzt wurden und dann
nicht mehr jedesmal von der Platte geladen werden mussten.
Bei modernen Systemen ist das obsolet.

#### Einschränkungen

Ich kann die Zugriffsrechte durch Optionen beim Einhängen des Dateisystems
einschränken.
Diese Einschränkungen kann ich mit dem Befehl `mount` ohne Parameter anzeigen
lassen.

Die Option *noexec* bewirkt, dass das **x** Bit keinen Effekt hat.
Damit gekennzeichnete Dateien kann ich nun nicht einfach durch Angabe ihres
Pfades starten.

Die Option *nosuid* bewirkt, dass das **setuid** Bit keinen Effekt hat.
Auch diese Dateien werden dann immer mit der UID des aufrufenden Prozesses
ausgeführt.

#### Ansehen und Bearbeiten der Zugriffsrechte

Um die traditionellen Zugriffsrechte einer Datei anzusehen kann ich das
Programm `ls` mit der Option `-l` verwenden:

{line-numbers=off,lang="text"}
    $ ls -a -l
    insgesamt 116
    drwxr-xr-x 2 mathias mathias 4096... 5 10:19 .
    drwxr-xr-x 5 mathias mathias 4096...30 22:26 ..
    -rw-r--r-- 1 mathias mathias   34...30 22:26 .project
    ...

Das Programm zeigt mir in der ersten Spalte den Typ und die Rechte der Datei
an, in der dritten Spalte den Eigentümer und in der vierten die Gruppe.

Mit dem Programm `id` kann ich die UID und GIDs meiner Shell ermitteln.
Das Programm `ps` zeigt mir diese für beliebige Prozesse an.

Um den Eigentümer einer Datei zu ändern, verwende ich das Programm *chown*.
Diese Operation ist nur *root* erlaubt, da alle anderen Benutzer
damit ihre Rechte an der Datei verlieren würden.

Die Gruppe einer Datei kann ich mit *chgrp* ändern. Das darf sowohl der
Eigentümer der Datei als auch *root*.

Die Dateirechte ändere ich mit dem Programm *chmod*. Auch diese
Operation darf nur der Eigentümer oder *root*.

Details zu den Programmen finden sich in den entsprechenden Handbuchseiten.

### Erweiterte Dateiattribute

Wenn die Standardzugriffsrechte einer Datei in Ordnung sind, ich aber
trotzdem keinen Zugriff habe, prüfe ich als nächstes die erweiterten Attribute
des Dateisystems für diese Datei.

Zum Anzeigen verwende ich das Programm `lsattr`:

{line-numbers=off,lang="text"}
    $ ls -l tmp/abc 
    -rw-r--r-- 1 mathias mathias 4 Okt  9 11:11 tmp/abc
    $ echo def > tmp/abc
    bash: tmp/abc: Keine Berechtigung
    $ lsattr tmp/abc 
    ----i---------- tmp/abc

Ändern kann ich die Attribute mit dem Programm `chattr`.

{line-numbers=off,lang="text"}
    $ sudo chattr -i tmp/abc 
    $ echo def > tmp/abc 
    $ cat tmp/abc 
    def

Die Handbuchseite listet sämtliche Aufrufoptionen des Programmes und alle
möglichen Dateiattribute auf.
Ich gehe hier nur auf die wichtigsten für die Fehlersuche ein.

Bei Dateien mit dem Attribut `a` kann ich den vorhandenen Text nicht
verändern, sondern lediglich neuen Text hinzufügen.
Dieses Attribut ist eine gute Wahl für Logdateien.

Dateien mit dem Attribut `c` werden komprimiert auf der Platte abgelegt.
Das ist im Normalbetrieb nicht weiter von Belang.
Es beeinträchtigt aber die Möglichkeit, Dateien nach einem Plattencrash zu
retten, weil Programme, welche Dateien anhand ihrer Signatur erkennen, damit
nicht funktionieren.

Dateien mit dem Attribut `i` kann ich nicht ändern, löschen oder umbenennen.
Ich kann keinen zusätzlichen Link anlegen und den Dateiinhalt nicht
ändern.

Bei Dateien mit dem Attribut `s` überschreibt der Kernel beim Löschen alle
Blöcke mit `0x0` und schreibt diese vor dem Löschen der Datei auf die Platte
zurück.
Das heißt, ich kann diese Dateien nicht wiederherstellen.
Bei sensiblen Daten würde ich mich jedoch nicht darauf verlassen,
da mitunter die Elektronik des
Speichermediums Sektoren vor dem Betriebssystem verbirgt und meine
Anstrengungen, eine Datei sicher zu löschen, zunichte macht.

Demgegenüber werden bei Dateien mit dem Attribut `u` beim Löschen Inode
und Dateiblöcke explizit vor weiterer Verwendung geschützt, so dass die
Datei auch bei intensiver Plattennutzung wieder gerettet werden kann.

Bei Dateien mit dem Attribut `t` gibt es kein *tail merge*.
Beim *Tail-Merging* werden die Daten des letzten Dateiblocks für mehrere
Dateien in einen gemeinsamen Block geschrieben.
Damit kann zum Beispiel der Bootlader LILO nicht umgehen.
Mit dem Attribut `t` für die Datei des Kernel-Images wird Tail-Merging
unterdrückt und es gibt keine Probleme mit dem Bootlader.

Bleibt zum Schluss nur noch anzumerken, dass *ext2* und *ext3* die Attribute
`c`, `s` und `u` nicht honorieren.
Diese beiden Dateisystem verwenden auch kein Tail-Merging.

### POSIX Capabilities {#ch06-rechte-posix-cap}

Das Ziel bei der Entwicklung der POSIX Capabilities war, die alles umfassenden
Privilegien des *root* Benutzers aufzuteilen in einzelne Privilegien, die je
nach Bedarf einzelnen Prozessen und/oder Programmen zugewiesen werden.
Traditionell darf ein Prozess, der unter UID 0 läuft, in einem
UNIX-System fast alles: auf alle Speicherbereiche, alle Geräte, alle Dateien
zugreifen, Netzwerkschnittstellen direkt nutzen, ...

Wenn ein Programm, wie *ping*, welches direkt auf die
Netzwerkschnittstelle zugreift, nur eines dieser Privilegien benötigt, dann
bekommt der Prozess, der es ausführt mit dem SUID-Bit alle anderen Privilegien
ebenfalls.
Gelingt es einem Angreifer, einen Programmfehler auszunutzen, kann er damit
seine Privilegien erhöhen, also die Rechte von *root* erlangen.

Genau an dieser Stelle setzen die POSIX Capabilities an.
Auf einem System, das diese kennt, kann ich dem Programm *ping* das SUID-Bit
entfernen und stattdessen die Capability `CAP_NET_RAW` vergeben.
Damit funktioniert das Programm wie vorher, bei einem ausgenutzten
Programmfehler gewinnt der Angreifer maximal genau dieses Privileg.

Wer sich tiefer in das Thema einarbeiten möchte, dem empfehle ich
die Seite von Chris Friedhoff zum Thema
[POSIX Capabilities & File POSIX Capabilities](http://www.friedhoff.org/posixfilecaps.html).
Hier zeige ich nur, wie man einen Einstieg in das Thema findet,
um sich im Rahmen einer Fehlersuche ein Bild machen zu können.
Trotzdem komme ich nicht um einige Grundlagen herum.

#### Wie funktionieren die POSIX Capabilities?

Welche Capabilities es im Einzelnen gibt, erfahre ich aus der Handbuchseite
*capabilities* in Sektion 7 (`man 7 capabilities`), oder direkt aus der Datei
*/usr/include/linux/capabilities.h*.

Capabilities werden zum einen für ausführbare Dateien festgelegt und zum
anderen für Prozesse.
Sie können das Kennzeichen *permitted* (erlaubt), *effective* (aktiv) oder
*inheritable* (vererbbar) haben.
Alle Capabilities mit einem bestimmten Kennzeichen bilden das entsprechende
Set.

Das Permitted Set einer Datei verleiht die entsprechenden Capabilities dem
Prozess, der sie ausführt.
Das Permitted Set eines Prozesses enthält alle Capabilities, die dieser
Prozess verwenden darf.

Das Inheritable Set einer Datei geht nur dann in das Permitted Set eines
Prozesses ein, wenn dieser die entsprechenden Kennzeichen ebenfalls in seinem
Inherited Set hat.
Damit ist es möglich, die an eine Datei vergebenen Capabilities nur
ausgewählten Prozessen verfügbar zu machen, die über die entsprechenden
inheritable Kennzeichen verfügen.

Das Effective Set einer Datei benötigt zusätzlich noch das effective oder
inheritable Kennzeichen der einzelnen Capabilities. Dann setzt es das
Effective Set des Prozesses für die Capabilities, die im Permitted Set des
Prozesses enthalten sind.

#### Was muss ich tun?

Kommen wir zum praktischen Teil, am Beispiel von *ping*.
Nachdem ich das SUID-Bit entfernt habe, funktioniert das Programm nicht mehr:

{line-numbers=off,lang="text"}
    $  ls -l /bin/ping
    -rwxr-xr-x 1 root root 35712 Nov  8  2011 /bin/ping
    $ ping -c1 localhost
    ping: icmp open socket: Operation not permitted

Die Fehlermeldung zeigt mir schon die Ursache, *strace* macht es noch einmal
deutlich:

{line-numbers=off,lang="text"}
     $ strace ping -c1 localhost 2>&1|grep EPERM
     socket(PF_INET, SOCK_RAW, IPPROTO_ICMP) = -1 EPERM

Mit dem Programm *setcap* kann ich *ping* die benötigte Capability verleihen:

{line-numbers=off,lang="text"}
     $ sudo setcap cap_net_raw=ep /bin/ping
     $ getcap /bin/ping
     /bin/ping = cap_net_raw+ep
     $  ping -c1 localhost
     PING localhost (127.0.0.1) 56(84) bytes of data.
     64 bytes from localhost (127.0.0.1): icmp_req=1 ...

     --- localhost ping statistics ---
     1 packets transmitted, 1 received, 0% packet loss...
     rtt min/avg/max/mdev = 0.107/0.107/0.107/0.000 ms

Und schon funktioniert es wieder.
Damit kann jeder auf dem System *ping* verwenden, ohne dass dieses
Programm mit den Rechten von *root* laufen muss.
Will ich die Anzahl der Prozesse und/oder Benutzer einschränken, die das
Programm nutzen können, verwende ich statt dem Kennzeichen *permitted* das
Kennzeichen *inheritable*:

{line-numbers=off,lang="text"}
     $ sudo setcap cap_net_raw=ei /bin/ping
     $ getcap /bin/ping
     /bin/ping = cap_net_raw+ei
     $ /sbin/getpcaps $$
     Capabilities for `4848': =
     $ ping -c1 localhost
     ping: icmp open socket: Operation not permitted

Da die File-Capability mit dem Kennzeichen *inheritable* nur wirkt, wenn
auch der Prozess das Kennzeichen *inheritable* für
diese Capability besitzt, fehlen mir die nötigen Rechte.

Diese kann ich beim Login am System, oder mit `su`
bekommen, wenn ich *libpam-cap* installiert habe.
Für `su` füge ich die folgende Zeile in */etc/pam.d/su* ein

{line-numbers=off,lang="text"}
    auth        required    pam_cap.so

und "vererbe" mir via */etc/security/capability.conf* die nötigen
Capabilities:

{line-numbers=off,lang="text"}
    $ egrep -v '^(|#.*)$' /etc/security/capability.conf 
    cap_net_raw mathias
    none  *

Nun muss ich mir noch die nötigen Rechte holen:

{line-numbers=off,lang="text"}
    $ /sbin/getpcaps $$
    Capabilities for `4848': =
    $ su - mathias
    Password: 
    $ /sbin/getpcaps $$
    Capabilities for `22807': = cap_net_raw+i
    $ ping -c1 localhost
    PING localhost (127.0.0.1) 56(84) bytes of data.
    64 bytes from localhost (127.0.0.1): icmp_req=1 ...

    --- localhost ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss,...
    rtt min/avg/max/mdev = 0.103/0.103/0.103/0.000 ms

Und schon funktioniert es wieder.

Halten wir fest, dass ich für die Analyse von Problemen vier Programme
verwenden kann:

*   **strace**, das mir anzeigt, bei welcher Operation ich
    Zugriffsprobleme habe.

*   **getcap**, das mir die Capabilities einer Datei anzeigt.

*   **setcap**, mit dem ich diese setzen kann.

*   **getpcaps**, dass mir die Capabilities von Prozessen anzeigt.

Und natürlich die Datei */usr/include/linux/capabilities.h* beziehungsweise
die Handbuchseite *capabilities*, die mir zeigen, welche Capabilities ich
verwenden kann.

### AppArmor

Auch bei AppArmor reiße ich das Thema nur kurz aus dem Blickwinkel Fehlersuche
an.
Für weiterführende Informationen zu AppArmor verweise ich auf die
[Projekt-Homepage](http://apparmor.net/).

Wie bei jedem Sicherheitssystem, dass unerlaubte Aktivitäten verhindern soll,
kann es auch bei AppArmor vorkommen, das erlaubte Aktivitäten gestört oder
verhindert werden.
Habe ich bei einem Problem AppArmor im Verdacht, überprüfe ich als erstes, ob
es aktiv ist:

{line-numbers=off,lang="text"}
    # aa-status
    apparmor module is loaded.
    22 profiles are loaded.
    20 profiles are in enforce mode.
       /sbin/dhclient
       ...
       /usr/share/gdm/guest-session/Xsession
    2 profiles are in complain mode.
       /usr/sbin/libvirtd
       /usr/sbin/ntpd
    3 processes have profiles defined.
    1 processes are in enforce mode.
       /usr/sbin/cupsd (727) 
    2 processes are in complain mode.
       /usr/sbin/libvirtd (1667) 
       /usr/sbin/ntpd (1436) 
    0 processes are unconfined but have a profile defined.

AppArmor beschränkt nur Anwendungen, für die Profile definiert sind.
Falls AppArmor nicht aktiviert ist oder keine Profile geladen sind, kann ich
davon ausgehen, dass das Problem nicht von AppArmor verursacht wird.

#### Nachrichten im Logfile

Wenn AppArmor aktiviert ist, schaue ich als nächstes nach Nachrichten im
Systemlog.
Diese finde ich unter Ubuntu mit:

{line-numbers=off,lang="text"}
    # grep type=1400 /var/log/syslog

Ist AppArmor aktiviert, aber ich sehe keine Logmeldungen, überprüfe ich den
Audit-Modus:

{line-numbers=off,lang="text"}
    # cat /sys/module/apparmor/parameters/audit
    normal

Der Audit-Modus kann die folgenden Werte haben:

*   **normal**

*   **quiet_denied** - verweigerte Zugriffe werden nicht protokolliert

*   **quiet** - das Modul protokolliert gar nichts

*   **noquiet** - das Modul überschreibt Profilregeln, die einzelne
      Nachrichten unterdrücken

*   **all** - gibt alle Prüfungen für alle Zugangsanfragen aus, auch für
      erlaubte Zugriffe

Um den Audit-Modus zu ändern, schreibe ich den gewünschten Modus in die Datei:

{line-numbers=off,lang="text"}
    # echo -n all > /sys/module/apparmor/parameters/audit

#### Audit-Einstellungen der Profile

AppArmor prüft nur Tasks (Prozesse), für die es ein Profil gibt.
Dabei kennt es vier Modi:

*   **Enforce mode** - nur Statusereignisse und
      abgewiesene Ereignisse erzeugen Audit-Nachrichten.

*   **Complain mode** - wie *Enforce Mode*, außer dass es den Nachrichtentyp
      von verboten zu erlaubt ändert, so dass AppArmor diese Anwendung nicht
      beschränkt.
      In diesem Modus protokolliert AppArmor nur unbekanntes Verhalten.

*   **Audit mode** - schreibt eine Protokollnachricht für jedes Ereignis,
      egal ob erlaubt oder verboten.

*   **Kill mode** - schreibt eine Protokollnachricht für jedes verbotene
      Ereignis und beendet die Anwendung.

Profile können Kennzeichen (Flags) enthalten, die das Audit beeinflussen.

*   **Deny rule** - jedes passende Ereignis zu einer Regel, die diesen Präfix
      enthält, wird ohne Protokollnachricht abgewiesen.
      Das setze ich ein, wenn ich die abgewiesenen Ereignisse kenne und nicht
      in den Systemlogs sehen will.

*   **Audit rule** - mit diesem Präfix werden die zur Regel passenden
      Ereignisse protokolliert.

#### Beschränkungen eines Prozesses untersuchen

Wenn ich ein Problem mit AppArmor untersuche, schaue ich zunächst, ob AppArmor
den betroffenen Prozess überhaupt beschränkt.
Das kann ich entweder mit `ps` machen oder indem ich mir die entsprechenden
Attribute des Prozesses im *proc* Dateisystem anschaue:

{line-numbers=off,lang="text"}
    # ps -Z 727
    LABEL           PID TTY STAT TIME COMMAND
    /usr/sbin/cupsd 727 ?   Ss   0:01 /usr/sbin/cupsd -F
    # cat /proc/727/attr/current 
    /usr/sbin/cupsd (enforce)
    # ps -Z 1667
    LABEL               PID TTY STAT TIME COMMAND
    /usr/sbin/libvirtd 1667 ?   Sl   0:00 /usr/sbin/li...
    # cat /proc/1667/attr/current 
    /usr/sbin/libvirtd (complain)
    # ps -Z 1
    LABEL               PID TTY STAT TIME COMMAND
    unconfined            1 ?   Ss   0:00 /sbin/init
    # cat /proc/1/attr/current 
    unconfined

#### Probleme mit AppArmor behandeln

Ich kann das Programm `aa-logprof` verwenden, um ein Profil anzupassen.
Dieses interaktive Programm durchsucht die Protokolldatei und schlägt bei
unbekannten AppArmor-Ereignissen Änderungen am jeweiligen Profil vor.
Am Ende schreibt es die Änderungen in die Profildatei und lädt die
geänderten Profile neu.
Falls nötig, aktualisiert es die Profile laufender Prozesse.

Alternativ kann ich die Profildatei unter */etc/apparmor.d/* mit einem Editor
direkt bearbeiten und mit

{line-numbers=off,lang="text"}
    # apparmor_parser -r /etc/apparmor.d/$profile

neu laden.

**Wichtig!** Ich kann zwar einem laufenden Prozess zusätzliche Rechte
gewähren. Will ich aber einer laufenden Anwendung Rechte entziehen, habe ich
nur die Möglichkeit, das Profil ganz zu entfernen, es anschließend mit
weniger Rechten wieder hinzuzufügen und dann den Prozess neu zu starten.

#### Profile in den Beschwerdemodus setzen

Wenn ich ein Profil im Moment nicht anpassen kann, kann ich es
in den Beschwerdemodus setzen.
Entweder zeitweilig, bis zum Reboot:

{line-numbers=off,lang="text"}
    # apparmor_parser -Cr /etc/apparmor.d/$profile

Oder permanent:

{line-numbers=off,lang="text"}
    # aa-complain $profile

Dann sollte die entsprechende Anwendung sich verhalten, wie eine
unbeschränkte, während AppArmor weiterhin Protokollnachrichten schreibt.

### SELinux

[SELinux](http://selinuxproject.org/)
ist, wie AppArmor ein Mandatory Access Control System.
Das heißt, die Vergabe von Rechten unter dem Einflussbereich von SELinux liegt
nicht im Ermessensspielraum des Benutzers, sondern wird vom System durch
Richtlinien und Regeln vorgegeben.

SELinux besteht aus einem Kernelmodul, unterstützenden Werkzeugen und
Konfigurationsdateien.
Damit kann ich die Zugriffskontrolle sehr feinkörnig einstellen.
SELinux funktioniert dabei völlig unabhängig von den traditionellen
Benutzernamen und Gruppen.

#### Wie stelle ich fest, ob SELinux aktiv ist?

Um herauszufinden, ob auf dem untersuchten System SELinux läuft, schaue ich
nach, ob es ein Verzeichnis */selinux/* gibt und ob dieses Dateien enthält.
Der Befehl `mount` sollte anzeigen, dass an diesem Punkt im Dateisystem ein
*selinuxfs* eingehängt ist:

{line-numbers=off,lang="text"}
    $ mount | grep selinux
    none on /selinux type selinuxfs (rw,relatime)

Mit `sestatus` bekomme ich erste Informationen über den Zustand von SELinux
auf dem betrachteten System:

{line-numbers=off,lang="text"}
    $ sudo sestatus
    SELinux status:                 enabled
    SELinuxfs mount:                /selinux
    Current mode:                   enforcing
    Mode from config file:          permissive
    Policy version:                 24
    Policy from config file:        default

#### Betriebsmodi

SELinux kennt zwei Modi:
Im Zwangsmodus (*enforcing mode*) verweigert der Kernel jede Aktion,
für die SELinux die Erlaubnis verweigert.
Im zulassenden Modus (*permissive mode*) gelten die Beschränkungen des
traditionellen Rechtesystems, SELinux protokolliert nur verweigerte Aktionen.

Als *root* kann ich zwischen beiden Modi mit dem Programm `setenforce`
umschalten.

{line-numbers=off,lang="text"}
    # setenforce 0

schaltet in den permissive Mode.

{line-numbers=off,lang="text"}
    # setenforce 1

schaltet in den enforcing Mode.

Mit dem Kernelparameter `enforcing=0` kann ich den permissive Mode bereits
beim Rechnerstart erzwingen.
Damit kann ich einem System temporär wieder auf die Beine helfen, dessen
Richtlinien und Regeln überhaupt kein Arbeiten mehr erlauben.

#### Konzepte

Eine Richtlinie (Policy) ist eine Sammlung von
Vereinbarungen und Regeln, die dem SELinux-Kern sagen, was erlaubt ist, was
nicht und wie er sich in verschiedenen Situationen verhalten soll.

Dabei unterscheidet man zwischen gezielten Richtlinien (*targeted policy*),
die nur wenige Anwendungen einschränken und strengen
Richtlinien (*strict policy*), die versuchen, alle Aktivitäten des Rechners
mit SELinux zu kontrollieren.

Richtlinien werden kompiliert und können als Binärmodule jederzeit ge- und
entladen werden.
Beim Start des Rechners lädt *init* eine Anfangsrichtlinie (*initial
policy*).

Das zweite wichtige Konzept bei SELinux ist der Kontext.
Jeder Prozess und Socket, jede Datei und Pipe ist mit einem Kontext markiert,
den ich zum Beispiel mit `ps -Z`, oder `ls -Z` erfragen kann.

{line-numbers=off,lang="text"}
    $ ls -Z /etc/fstab 
    system_u:object_r:etc_t:s0 /etc/fstab
    $ ps -Z
    LABEL                             PID TTY    TIME CMD
    unconfined_u:unconfined_r:unconfined_t:s0-s0:\
    c0.c1023 1215 pts/0 00:00:00 bash
    unconfined_u:unconfined_r:unconfined_t:s0-s0:\
    c0.c1023 1359 pts/0 00:00:00 ps
    $ id
    uid=1000(mathias) gid=1000(mathias) \
    Gruppen=1000(mathias),4(adm),24(cdrom),25(floppy),\
    27(sudo),29(audio),30(dip),44(video),46(plugdev) \
    Kontext=unconfined_u:unconfined_r:unconfined_t:\
    s0-s0:c0.c1023

Der Kontext ist unabhängig von der traditionellen UNIX-UID oder -GID.
Programme mit gesetztem SUID-Bit, `su` oder `sudo` ändern den Kontext
nicht:

{line-numbers=off,lang="text"}
    $ id
    uid=1000(mathias) gid=1000(mathias)
    ...
    Kontext=unconfined_u:unconfined_r:unconfined_t:s0-s0\
    :c0.c1023

    $ sudo id
    uid=0(root) gid=0(root) Gruppen=0(root)
    Kontext=unconfined_u:unconfined_r:unconfined_t:s0-s0\
    :c0.c1023

Der Kontext besteht aus den drei Teilen Benutzer, Rolle und Typ.
Den Typ nennt man bei Prozessen Domain.
Alle drei Teile sind nur Namen, die erst durch die Regeln einer
Richtlinie eine Bedeutung für SELinux bekommen.

Der Kontext von Dateien wird in den erweiterten Attributen gespeichert.
Mit `chcon` kann ich den Kontext einer Datei temporär ändern.
Für dauerhafte Änderungen verwende ich `setfiles`.

Auf Dateisystemen ohne erweiterte Attribute, wie VFAT, ISO, NFS oder Samba,
bekommen alle Dateien einen einheitlichen Kontext, entsprechend den Optionen
beim Einhängen mit `mount`.

#### Informationen zu verweigerten Zugriffen finden

Die wichtigste Eigenschaft von SELinux ist, dass es alle Aktionen
protokolliert, sowohl genehmigte als auch abgewiesene Aktionen.
Im laufenden Betrieb ist es in den meisten Fällen nicht notwendig, jede
einzelne Aktion zu protokollieren, die genehmigten sind meist uninteressant.
Mit `dontaudit` kann ich diese von der Protokollierung ausnehmen.

Wo ich die Protokolle von SELinux finde, hängt von der benutzten Distribution
ab, meist finde ich sie unterhalb von */var/log/*.
Läuft auf dem System der Linux Audit Dämon, finde ich die Protokolle in
*/var/log/audit/audit.log* oder */var/log/audit.log*.
Andernfalls suche ich nach einer Datei *avc.log*.

Beim Betrachten der Audit-Protokolle gilt es ein paar Dinge im Kopf zu
behalten:

1.  Nicht jede Ablehnung die ich in den Protokollen finde, stellt ein
    Problem dar.
    Einige sind nur kosmetischer Natur, sie treten auf, beeinflussen aber das
    Verhalten der Anwendung nicht.
    Diese Ablehnungen kann ich in den Regeln durch `dontaudit` Anweisungen
    von der Protokollierung ausnehmen.

2.  Ich werde jede Menge Ablehnungen sehen, von denen viele nichts
    mit dem Problem zu tun haben, das ich gerade untersuche.

3.  Wenn zu viele Ablehnungen hintereinander kommen, kann es vorkommen, dass
    der Linux-Kernel einige unterdrückt.
    Wenn das passiert taucht eine Nachricht auf, die angibt wie viele
    Meldungen unterdrückt wurden.
    Das heißt dann, dass ich im Log vielleicht nicht alles finde, was SELinux
    gemeldet hat.

#### Logeinträge untersuchen

In den SELinux-Tutorials im Gentoo Wiki findet sich eine ausführliche
[Anleitung zur Auswertung der SELinux Protokolle](https://wiki.gentoo.org/wiki/SELinux/Tutorials/Where_to_find_SELinux_permission_denial_details).

Betrachten wir eine Ablehnung im *audit.log* des Audit-Dämons,
die ich am Text `type=AVC` am Zeilenanfang erkenne:

{line-numbers=off,lang="text"}
    type=AVC \
    msg=audit(1384529907.797:27): \
    avc:  \
    denied  \
    { execute } \
    for pid=2347 \
    comm="hello" \
    path="/lib/i686/cmov/libc-2.11.3.so" \
    dev=sda1 ino=105872 \
    scontext=unconfined_u:unconfined_r:haifux_t:s0-s0\
    :c0.c1023 \
    tcontext=system_u:object_r:lib_t:s0 tclass=file

AVC steht für *Access Vector Cache*.

Die einzelnen Teile bedeuten:

*   `type=AVC`

    Der Protokolltyp.
    Diesen finde ich nur in der Datei *audit.log*.

*   `msg=audit(1384529907.797:27)`

    Der Zeitstempel in Sekunden seit *epoch*, also seit dem ersten Januar 1970.
    Diesen kann ich mit `date -d @1384529907` in ein besser lesbares Format
    umwandeln.

*   avc

    Nochmal der Protokolltyp, also ein AVC-Eintrag.

*   denied

    Wie SELinux entschieden hat, entweder *denied* oder *granted*.
    Im permissive Mode steht hier ein *denied*, auch wenn die Operation
    ausgeführt wurde.

*   `{ execute }`

    Die Operation, für die um Erlaubnis gefragt wurde.
    Das können auch mehrere Operationen sein.

*   for pid=2347

    Die ID des Prozesses, der die Aktion ausführen wollte.

*   comm="hello"

    Der Befehl (ohne Optionen und auf 15 Zeichen beschränkt), den der Prozess
    ausführt, dessen Operation abgewiesen wurde.

*   path="/lib/i686/cmov/libc-2.11.3.so"

    Die Zieldatei der Operation.
    Dazu muss ich wissen, dass
    */lib/i686/cmov/libc-2.11.3.so* die Standard-C-Bibliothek ist, die das
    Programm *hello* als eine der ersten öffnet und mit *mmap()* und dem
    Argument `PROT_EXEC` in seinen Speicherbereich einblenden will.

*   dev=sda1

    Das Gerät (Dateisystem), auf dem sich die Zieldatei der Operation befindet.

*   ino=105872

    Die Inodenummer auf dem Gerät.
    Um die entsprechende Datei zu finden, ermittle ich zunächst den Mountpoint
    des Gerätes und verwende dann `find`:

{line-numbers=off,lang="text"}
        # mntpnt="$(mount|grep sda1\ on|cut -f3 -d\ )"
        # find $mntpnt -xdev -inum 105872

*   scontext=unconfined_u:unconfined_r:haifux_t:s0-s0:c0.c1023

    Der Quellcontext (*source context*) des Prozesses, die Domain.

*   tcontext=system_u:object_r:lib_t:s0 tclass=file

    Der Zielkontext (*target context*) der Ressource, auf die zugegriffen
    werden soll, in diesem Fall die Datei.

#### Versteckte Ablehnungen

Ich hatte schon angedeutet, dass ich Ablehnungen, welche
das Verhalten einer Anwendung nicht beeinflussen, mit `dontaudit`
Anweisungen von der Protokollierung ausnehmen kann.

Sollte ich bei meiner Fehlersuche den Verdacht haben, dass eine dieser
versteckten Ablehnungen mein Problem verursacht, schaue ich als erstes nach,
wie viele es überhaupt gab:

{line-numbers=off,lang="text"}
    # seinfo --stats|grep audit
       Auditallow:         19    Dontaudit:        4601

Möchte ich die versteckten Ablehnungen im Protokoll sehen, dann kann ich mit
*semodule* die `dontaudit` Anweisungen deaktivieren:

{line-numbers=off,lang="text"}
    # semodule --disable_dontaudit --build

Habe ich genug davon, aktiviere ich sie wieder:

{line-numbers=off,lang="text"}
    # semodule --build

Damit habe ich einen Einstieg in die Fehlersuche bei Problemen mit SELinux.
Natürlich kann ich damit noch nicht alle Probleme lösen, doch hilft es
zumindest bei den ersten Schritten.


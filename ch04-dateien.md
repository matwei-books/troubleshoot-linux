
## Dateien und Verzeichnisse {#sec-linux-grundlagen-dateien}

Ein grundlegendes Konzept, dass man verinnerlicht haben muss, um weitere
Eigenheiten von Linux und UNIX zu verstehen, ist das Verhältnis von Dateien,
Inodes und Verzeichnissen.

Abstrakt betrachtet ist eine Datei ein Datenspeicher: ich kann hinein
schreiben und daraus lesen.
Diese Aussage erscheint zunächst wie ein Allgemeinplatz, aber dieser Makel
haftet fast allen grundsätzlichen Ideen an.
Der wesentliche Punkt ist, dass fast alles in einem Linux-System als Datei
betrachtet wird, in die man Daten schreiben beziehungsweise aus der man
Daten lesen kann.

Dementsprechend gibt es verschiedene Arten von Dateien, die für einfache
Lese- und Schreiboperationen oft austauschbar sind.
So kann ich zum Beispiel mit

{line-numbers=off,lang="text"}
    # dd if=/dev/hda of=/dev/hdb

eine bit-genaue Kopie der ersten Festplatte auf der zweiten anlegen, wenn
letztere groß genug ist.
Dagegen lege ich mit der Variante

{line-numbers=off,lang="text"}
    # dd if=/dev/hda of=/mnt/backup/hda.img

eine Sicherungskopie der ersten Festplatte als Datei im Verzeichnis
*/mnt/backup/* an.
Mit dem Befehl

{line-numbers=off,lang="text"}
    # dd if=/dev/hda \
      | ssh rechner2 dd of=rechner1-hda.img

schicke ich das Abbild der ersten Platte zu *rechner2* und lege es dort in der
Datei *rechner1-hda.img* ab.
In allen drei Fällen hat das Programm `dd` dieselbe Operation mit zwei Dateien
gemacht, das Ergebnis ist aber völlig verschieden.

Kommen wir zurück zu den verschieden Arten von Dateien.
Da gibt es zunächst die **regulären Dateien**, die noch am ehesten dem nahe
kommen, was ich mir unter einer Datei vorstelle.

Diese könnte ich auf einer Festplatte als Muster in der Magnetisierung, auf
einer CD-ROM als optisches Muster und in Flash-Speicher als Ladung in
Halbleitern lokalisieren.
Die Daten, die hinein geschrieben wurden, sind in codierter Form in dem
Bereich vorhanden, der die Datei ausmacht und können unverändert wieder
ausgelesen werden, solange nichts kaputt geht.

Um eine reguläre Datei anzulegen, kann ich den Befehl `touch` verwenden, in der
Shell die Standardausgabe umleiten oder mit einem der unzähligen Programme,
welche mit Dateien arbeiten, eine neue Datei anlegen.

Neben den regulären Dateien gibt es **Gerätedateien**.
Diese kann ich genau wie reguläre Dateien verwenden, die Daten gehen
jedoch an das mit der Datei verknüpfte Gerät.

Ich finde Gerätedateien üblicherweise unterhalb von */dev/*, sie belegen
außer dem Inode keinen weiteren Speicherplatz auf dem Datenträger.
Auf modernen Systemen gibt es spezielle Dateisysteme, wie *devfs*, in denen
der Kernel die Gerätedateien dynamisch zur Verfügung stellt, wenn die
entsprechende Hardware verfügbar ist.

Gerätedateien unterteilt man in *blockorientierte Geräte*, wie zum Beispiel
*/dev/hda* für die rohen Daten der ersten Festplatte im Rechner, und
*zeichenorientierte Geräte*, wie zum Beispiel */dev/ttyS0* für die erste
serielle Leitung.
Der wesentliche Unterschied zwischen beiden ist, dass ich bei
blockorientierten Geräten wahlfrei an beliebigen Stellen lesen und schreiben
kann, während ich bei zeichenorientierten Geräten immer nur ein Zeichen nach
dem anderen lesen oder schreiben kann.

Im Kernel werden die Gerätedateien mit Hauptnummern (major number) unterteilt,
die den Typ des Gerätes bestimmen, und Nebennummern (minor number),
die gleichartige Geräte untereinander differenzieren.
Gerätedateien kann ich mit dem Befehl `mknod` anlegen.

A> Es gibt eine Reihe virtueller Gerätedateien, die bestimmten Zwecken dienen:
A> 
A> /dev/null
A> : verwirft alle Eingaben und gibt nichts aus.
A> 
A> /dev/zero
A> : erzeugt einen Zeichenstrom aus Nullzeichen (`\0`)
A> 
A> /dev/random
A> : gibt echte Zufallszahlen oder kryptographisch starke
A>  Pseudozufallszahlen aus.
A>  Sollte nicht genügend Entropie angesammelt sein, blockiert der Kernel den
A>  Lesezugriff.
A>
A> /dev/urandom
A> : gibt Pseudozufallszahlen aus, ohne zu blockieren.

Die nächste Art von Dateien sind **FIFO** oder **Named Pipes**.
Diese sind Endpunkte für die Interprozesskommunikation (IPC).
Wenn ein Prozess etwas in eine FIFO schreibt, kann ein anderer das lesen.
Der Kernel speichert die geschriebenen Daten zwischen und blockiert den
schreibenden Prozess bis ein anderer Prozess die Daten gelesen hat.
Genauso blockiert er einen lesenden Prozess, bis ein anderer Prozess Daten in
die FIFO geschrieben hat.

Dieser Umstand wird unter anderem vom Init-Programm `systemd` verwendet, um
verschiedene parallel gestartete Dienste zu synchronisieren.
UNIX-Sockets sind in gewisser Weise den FIFOs ähnlich, der Hauptunterschied
ist, dass ein Prozess bei einem Socket sowohl lesen als auch schreiben kann.
Damit ist bidirektionale Kommunikation möglich, für die man sonst zwei FIFOs
benötigen würde.

Alle genannten Dateitypen befinden sich im Dateibaum, einer hierarchischen
Datenbank aller in einem System verfügbaren Dateien.
Der Dateibaum setzt sich aus mindestens einem, in der Regel aber mehreren,
oft unterschiedlichen Dateisystemen zusammen.
Neben den Dateisystemen, die auf Blockgeräten, wie Festplatten, angelegt
werden, gibt es verschiedene Spezial-Dateisysteme, wie *proc*, *sysfs*,
*tmpfs*, die der Kernel intern zur Verfügung stellt und Netzwerkdateisysteme,
bei denen die Daten auf anderen Rechnern liegen.

In den Dateisystemen finde ich eine weitere spezielle Art von Dateien, die
**Verzeichnisse**.
Diese werden zwar genauso wie reguläre Dateien im Dateisystem gespeichert,
jedoch kann ich nicht beliebige Daten hineinschreiben.
Verzeichnisse enthalten strukturierte Einträge, die jeweils den Namen einer
Datei und einen Verweis auf die Verwaltungseinheit, den Inode, umfassen.
In jedem Verzeichnis gibt es zwei Standardeinträge: "." verweist auf den Inode
des Verzeichnisses selbst und ".." verweist auf den Inode des übergeordneten
Verzeichnisses, in dem der Name dieses Verzeichnisses steht.
Lediglich im Wurzelverzeichnis eines Dateisystems verweist ".." auf den Inode
des Verzeichnisses selbst.
Da der Eintrag ".." immer auf das übergeordnete Verzeichnis verweisen muss,
ist es nicht möglich, mehrere namentliche Verweise auf ein Verzeichnis in
verschiedenen anderen Verzeichnissen anzulegen.
Dadurch kann ich anhand der Linkzahl im Inode eines Verzeichnisses sagen,
wie viele Unterverzeichnisse dieses enthält, denn jedes Unterverzeichnis
fügt mit seinem Eintrag ".." einen weiteren Link hinzu.
Verzeichnisse ohne Unterverzeichnis haben eine Linkzahl von 2.
Der Befehl `ls -l` zeigt in der zweiten Spalte die Linkzahl an.

Der Inode einer Datei enthält deren Verwaltungsinformationen, er beschreibt
den Typ und die Eigenschaften der Datei und notiert den Platz,
den die Datei auf dem Medium einnimmt.
Inodes sind fest mit einer Datei verknüpft, Verzeichniseinträge hingegen
nicht.

Ich kann mehrere Namen für dieselbe Datei, das heißt denselben Inode vergeben.
Diese Namen werden Links genannt.
Durch das Anlegen eines Links, also eines neuen Namens für eine Datei ändern
sich die Eigenschaften der Datei nicht.

Der letzte Satz stimmt nicht ganz für den Inode, da in diesem die Anzahl der
Links, die auf die Datei verweisen, mitgezählt wird.
Sobald diese Anzahl 0 wird, gibt der Kernel den Inode und den von der Datei
belegten Speicher frei.

Außer den Einträgen in Verzeichnissen des Dateisystems geht allerdings noch die
Anzahl der Prozesse, die eine Datei geöffnet halten in diese Linkzahl mit ein.
Dadurch ist es möglich, alle Verzeichniseinträge einer Datei
zu entfernen, ohne dass der Inode und der Speicherplatz freigegeben werden.
In diesem Fall spricht man von versteckten Dateien.
Erst wenn der letzte Prozess, der die Datei geöffnet hat, seinen
Dateideskriptor dafür schließt, wird auch
der Inode und Speicherplatz freigegeben.
Bis dahin kann ich die Datei zum Beispiel mit `lsof` wieder finden.

Um eine so gefundene Datei wiederherzustellen, muss ich auf
dateisystemspezifische Werkzeuge zurückgreifen.
Für *ext2*, *ext3* und *ext4* Dateisysteme verwende ich das Programm `debugfs`.

Schließlich gibt es neben den schon erwähnten Links, die immer nur innerhalb
eines Dateisystems gelten und auch Hardlinks genannt werden, noch symbolische
Links.
Das sind Verzeichniseinträge, die lediglich auf einen anderen Pfad verweisen
und sonst nichts mit der Datei, auf die der Pfad verweist, zu tun haben.
Da sie nicht auf Inodes verweisen, zählen sie auch nicht bei der
Linkzahl letzterer.
Es ist möglich, dass ein symbolischer Link auf einen nicht vorhandenen
Verzeichniseintrag verweist.
Dafür können symbolische Links über Dateisystemgrenzen und auch auf
Verzeichnisse verlinken, was wiederum nicht mit Hardlinks funktioniert.


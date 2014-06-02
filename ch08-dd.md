
## dd {#sec-lokal-werkzeuge-dd}

Ein eher unscheinbares, aber sehr nützliches Werkzeug ist `dd`.
Bei der Fehlersuche verwende ich es um

*   Daten und Dateien von einem anderen Rechner zu sichern,

*   Backups von Partitionstabellen zu machen, und

*   defekte Festplattensektoren zu "reparieren".

#### Dateien von einem anderen Rechner sichern

Um Dateien zwischen zwei Rechnern zu kopieren, verwende ich am
liebsten `scp` oder `rsync`.

In manchen Fällen, wenn beide Befehle nicht zur Verfügung stehen oder ich
Daten von einer Gerätedatei kopieren möchte, greife ich auf `dd` zurück.

Bei kleinen Linux-Routern, die von einer read-only eingehängten Flash-Disk
betrieben werden, sichere ich die Flash-Disk mit folgendem Befehl, von einem
anderen Rechner:

{line-numbers=off,lang="text"}
    $ ssh root@r-xyz dd if=/dev/sda | dd of=r-xyz.image

Mit SSH starte ich auf dem Router einen Prozess mit `dd`, der den Inhalt von
*/dev/sda*, der ersten Festplatte, zur Standardausgabe schreibt. Die
Standardausgabe dieses Prozesses leite ich via SSH und Pipe an einen lokalen
Prozess mit `dd`, der von Standardeingabe liest und in die Datei *r-xyz.image*
schreibt.

#### Partitionstabellen sichern und wiederherstellen

Partitionstabellen sichere ich, wenn ich mehrere Betriebssysteme
auf einer Festplatte installieren will und damit rechnen muß, dass das
Linux-System unbootbar wird, wenn ich ein anderes System installiere.
Aber auch, wenn ich die Partitionen manipuliere, weil sich beispielsweise die
Größe eines Festplattenimages geändert hat.
Ebenso ist die Sicherung vor der Installation eines Bootloaders in der
Partitionstabelle angezeigt.

{line-numbers=off,lang="text"}
    # dd if=/dev/sda of=sda.image bs=512 count=1

Damit sichere ich die Partionstabelle.

{line-numbers=off,lang="text"}
    # dd if=sda.image of=/dev/sda

Dieser Befehl stellt sie wieder her.
Natürlich muss ich die Image-Datei an einem sicheren und
erreichbaren Ort lagern.

#### Reparieren von Festplattensektoren

Der dritte Anwendungsfall ist das "Reparieren" von defekten
Festplattensektoren.

Moderne Festplatten haben ungenutzten Plattenplatz, mit denen sie
defekte Sektoren ersetzen können.
Allerdings nur, wenn auf diesen Sektor geschrieben wird.

{line-numbers=off,lang="text"}
    # dd if=/dev/null of=/dev/sda1 bs=$BLOCKSIZE \
         seek=$OFFSET count=1 oflag=direct,dsync

Mit diesem Befehl beschreibe ich gezielt einen Sektor der Festplatte.
Dabei ist `$BLOCKSIZE` die Größe eines Sektors der Festplatte und `$OFFSET` die
Differenz zwischen dem defekten Sektor und dem Anfang der Partition in
Sektoren.
Wenn die Plattenelektronik beim Schreiben bemerkt, dass der ursprüngliche
Block defekt ist, ersetzt sie diesen durch einen Reserveblock und die
Festplatte ist "repariert".

Wie ich herausbekomme, welchen Sektor ich beschreiben muss, ist im
[Bad Block Howto][badblockhowto] in Englisch und in einem
[Artikel auf Pro-Linux.de][prolinuxbadblocks] in deutscher Sprache beschrieben.

[badblockhowto]: http://smartmontools.sourceforge.net/BadBlockHowTo.txt 

[prolinuxbadblocks]: http://www.pro-linux.de/-01028c

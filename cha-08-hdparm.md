
## hdparm {#sec-lokal-werkzeuge-hdparm}

Mit hdparm kann ich die Schnittstelle zur Festplatte des Rechners beeinflussen.
Ich verwende das Programm zum Feintuning der Festplattenzugriffe,
aber auch zum Verifizieren und Beheben von Plattenfehlern.
Es arbeitet zusammen mit der Kernelschnittstelle des SATA-, PATA- und des
SAS-Subsystems.
Auch bei manchen USB-Festplatten kann ich Parameter mit hdparm verändern.
Für einige der Optionen benötige ich eine aktuelle Kernelversion.

Allgemein sieht der Aufruf von hdparm wie folgt aus:

{line-numbers=off,lang="text"}
    hdparm [optionen] [geraet ..]

Mit manchen Optionen kann ich Parameter sowohl abfragen als auch setzen
(get/set).
Bei diesen Optionen gilt, dass sie ohne zusätzliches Argument den Parameter
abfragen und mit Argument den Wert entsprechend setzen.

Rufe ich hdparm ganz ohne Parameter auf, verhält es sich,
als hätte ich die Optionen `-acdgkmur` angegeben.

Nachfolgend beschreibe ich die, aus meiner Sicht, wichtigsten Optionen.
Weitere Informationen gibt es, wie immer, in den Handbuchseiten.

*-a*
: (get/set) Anzahl der Sektoren für das Vorauslesen (read-ahead)
  im Dateisystem. Damit verbessert sich die Performance beim sequentiellen
  Lesen großer Dateien.

*-A*
: (get/set) Ein- oder Ausschalten der Vorauslesefunktion der Festplatte.
  Mit `-A0` wird es ausgeschaltet, mit `-A1`  eingeschaltet.

*-B*
: (get/set) Einstellen der Advanced Power Management (APM) Eigenschaften der
  Platte, soweit diese das unterstützt.
  Gültig sind Werte von 1, für die meiste Energieeinsparung, bis 254, für die
  höchste I/O-Performance, mit dem Wert 255 wird es ganz abgeschaltet.
  Werte von 1-127 erlauben einen Spin-Down der Festplatte, Werte von 128-254
  erlauben das nicht.

*-c*
: (get/set) 32-Bit-Support für (E)IDE ein- oder ausschalten.
  Mit 0 wird dieser ausgeschaltet, 1 schaltet ihn ein und 3 schaltet den
  32-bit-Support mit speziellem Sync ein.

  Es geht hierbei um den Transfer via PCI oder VLB zum Hostadapter. Das
  Kabel zur Festplatte hat immer 16 Bit.

*--fibmap dateiname*
: Liefert die Liste der Blockextents (Sektorbereiche),
  die die Datei auf der Platte belegt.

  Damit kann ich mir die Fragmentierung einer Datei auf der Platte
  ansehen, oder die Blöcke für Fehlertests bestimmen.

  Wenn diese Option verwendet wird, muss sie die einzige sein.

*-g*
: Zeigt die Laufwerksgeometrie (Zylinder, Köpfe, Sektoren), die
  Größe des Gerätes in Sektoren und den Startoffset von Beginn der Platte.

*-i*
: Zeigt Identifizierungsinformationen, die die Kerneltreiber
  während des Systemstarts und der Konfiguration gesammelt haben.

*-I*
: Zeigt die Identifizierungsinformationen, die das Laufwerk liefert.

*-m*
: (get/set) Die Anzahl der Sektoren für multiple Sektor I/O. Mit
  dem Wert 0 wird das abgeschaltet.
  Die meisten IDE-Festplatten erlauben die Übertragung von mehreren
  Sektoren pro Interrupt.
  Damit läßt sich der System Overhead für Disk I/O um 30 bis 50 Prozent
  reduzieren.
  Es kann allerdings in einigen Fällen zu massiven Dateisystemfehlern
  führen.

*--read-sector sektornummer*
: Liest den angegebenen Sektor und
  schreibt den Inhalt in Hex-Darstellung zum Standardausgang.
  Die Sektornummer wird als Dezimalzahl angegeben.
  Hdparm führt einen Low-Level-Read für diesen Sektor aus.
  Damit dient diese Funktion als definitiver Test für schlechte Sektoren.
  Um den Sektor durch die Plattenelektronik ersetzen zu lassen, kann ich
  die Option `--write-sector` verwenden.

*-t*
: Nimmt die Zeit von Lesezugriffen für Benchmarks und
  Vergleichsmessungen. Um brauchbare Werte zu erhalten, muss man diese
  Funktion mindestens zweimal bei einem ansonsten inaktiven System, das heißt
  keine anderen aktiven Prozesse, und genügend freiem Hauptspeicher ausführen. 
  Diese Funktion zeigt, wie schnell Daten ohne den Overhead des
  Dateisystems gelesen werden können.

*-T*
: Nimmt die Zeit von Cache-Read-Zugriffen. Auch diese Funktion
  sollte mindestens zweimal bei ansonsten inaktivem System wiederholt
  werden. Das zeigt den Durchsatz von Prozessor, Cache und RAM.

*--write-sector sektornummer*
: Schreibt Nullen in den Sektor.
  **Sehr gefährlich!**
  Irre ich mich in der Sektornummer, werden möglicherweise vitale
  Informationen des Dateisystems überschrieben.
  Die Sektornummer wird als Dezimalzahl angegeben.
  Diese Funktion kann ich zum Anstoßen der automatischen
  Reparatur des Sektors durch die Festplatte verwenden.
  Vorher vergewissere ich mich mit der Option `--read-sector`, dass ich es
  wirklich mit einem defekten Sektor zu tun habe.

*-W*
: (get/set) Zeigt beziehungsweise modifiziert das Write Caching
  des IDE/SATA Laufwerks. 1 bedeutet eingeschaltet.

*-z*
: Zwingt den Kernel, die Partitionstabelle neu zu lesen.

In der Datei /etc/hdparm.conf kann ich die Default-Konfiguration für hdparm
hinterlegen.
Diese Datei ist gut kommentiert, so dass ich mir weitere Erläuterungen dazu
spare.


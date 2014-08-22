
## Prozessmodell {#sec-unix-prozessmodell}

Das nächste wichtige Konzept ist das UNIX-Prozessmodell, das ich wenigstens in
groben Zügen verstehen muss, damit sich mir andere Konzepte, wie zum Beispiel
Zugriffsrechte, erschließen.

Bevor ich auf dieses eingehe, will ich kurz die Begriffe Programm und Prozess
erläutern, da diese im allgemeinen Sprachgebrauch oft vermischt werden.

Ein **Programm** ist nicht mehr als eine Reihe von Anweisungen für den
Prozessor eines Rechners, die so angeordnet sind, dass deren Abarbeitung mehr
oder weniger sinnvolles Verhalten des Rechners ermöglicht.
Das Programm im Sinne des hier besprochenen Prozessmodels ist immer auf den
ausführenden Prozessor zugeschnitten.
Zwar spricht man auch bei Shell-, Perl- oder sonstigen Skripten
von Programmen, im Sinne des UNIX-Prozessmodells sind jedoch die entsprechenden
Interpreter die Programme, welche von eben jenen Skripten nur gesteuert werden.

Ein **Prozess** demgegenüber ist ein komplexeres Konstrukt, das über spezielle
Datenstrukturen im Kernel identifiziert wird, Zugang zu bestimmten Dateien im
Dateisystem hat, Rechenzeit und Hauptspeicher zugeteilt bekommt und ein
Programm abarbeitet.
Ein Prozess wird immer durch eine PID identifiziert, über die
Benutzeridentität (UID) und zugeordnete Gruppen (GID) werden seine
Zugriffsrechte auf Ressourcen bestimmt.

Mitunter sind Prozesse unterteilt in Threads (Fäden), die nur Teile des
Programms abarbeiten, weniger Kontextinformationen enthalten und daher
schnelleres Umschalten erlauben und zum Teil auch parallel ausgeführt werden
können.
Für die Betrachtung des UNIX-Prozessmodells sind diese hier nicht relevant.

Wenn jemand sagt, Programm *xyz* startet, ist damit gemeint, ein Prozess führt
Programm *xyz* aus.
Bildlich kann man einen Prozess mit einem Lebewesen vergleichen und das
Programm mit seiner DNA.
Auch wenn das Programm im wesentlichen vorgibt, wozu ein Prozess in der Lage
ist, so bestimmt es doch nicht in allen Einzelheiten, was er tut.
Das Programm bestimmt, ob ein ein Prozess als Mailserver, Shell oder was weiß
ich arbeitet, so wie die DNA bestimmt, ob ein Lebewesen Fisch, Katze oder Baum
wird.
Wie gut oder schlecht ein Programm seine Aufgabe erfüllt, hängt zu einem Teil
vom Programm und darin enthaltenen Fehlern ab, genau wie bei der DNA eines
konkreten Lebewesens.
Zu einem weiteren Teil hängt der Prozess von seiner Umgebung ab, so wie ein
Lebewesen von seinen Lebensumständen.
Der dritte Teil, der das Verhalten eines Prozesses bestimmt, sind die Daten
die er verarbeitet, die ich mit den Interaktionen eines Lebewesens vergleiche.
Ein Prozess kann so lange "leben", bis er seine Aufgabe erfüllt hat oder
vorzeitig durch ein Signal wie *SIGTERM* oder *SIGKILL* beendet werden, so wie
ein Lebewesen durch Krankheit oder Unfall vorzeitig sterben kann.
Ich breche an dieser Stelle den Vergleich ab, da er nur das Verhältnis von
Prozess zu Programm illustrieren sollte.

Der Lebenszyklus eines Prozesses mit Ausnahme des allerersten, vom Kernel
gestarteten Prozesses beginnt immer mit dem `fork()` Systemaufruf.
Dieser Aufruf macht nichts anderes, als eine exakte Kopie des aufrufenden
Prozesses anzulegen.
Damit haben wir zwei vollkommen identische Prozesse, die sich erst nach
Rückkehr des `fork()` Systemaufruf unterscheiden, und zwar im Rückgabewert
desselben.
Beim aufrufenden Prozess, Parent oder Elternprozess genannt, gibt `fork()` die
PID des Klonprozesses zurück.
Beim geklonten Prozess liefert es `0`.
Das ist die einzige Möglichkeit für das abgearbeitete Programm, zwischen
diesen beiden Prozessen zu unterscheiden.

Je nachdem, welches Programm gerade an welcher Stelle ausgeführt wurde, werden
anschließend beide Prozesse das gleiche Programm ausführen, wie zum Beispiel
die Worker-Prozesse beim Apache HTTP-Dämon, oder ein Prozess beginnt ein
anderes Programm abzuarbeiten.

Das führt uns zum nächsten wichtigen Bestandteil, dem Laden eines Programmes
für die Abarbeitung.
Nachdem der Kernel einen neuen Prozess erzeugt hat, arbeitet dieser zunächst
das gleiche Programm wie sein Parent ab.
Um ein anderes Programm auszuführen, verwendet er den `exec()` Systemaufruf.
Dabei überlagert der Kernel den Teil des Hauptspeichers, welcher das
ausführbare Programm enthält, mit dem Abbild des neuen Programms. 
Das neue Programm wird anschließend ab einem definierten Eintrittspunkt
abgearbeitet.
Programmargumente und Umgebungsvariablen werden im Hauptspeicher übergeben.
Dateideskriptoren, also offene Dateien, bleiben über einen `exec()` Systemaufruf
unverändert.

Bleibt als letzter Teil im Lebenszyklus eines UNIX-Prozesses das Ende zu
besprechen.
Ein Prozess kann sich durch den `exit()` Systemaufruf selbst beenden oder vom
Kernel beendet werden, zum Beispiel mit SIGKILL oder bei Schutzverletzungen.
In jedem Fall bleibt die Prozessstruktur so lange im Kernel erhalten, bis der
Parent den Prozessstatus mit `wait()` abfragt.
Versäumt der Parent-Prozess die Abfrage mit `wait()`, ist das im
Prozesslisting mit `ps` als Zombieprozess sichtbar.
Wird ein Parent vor dem Child beendet, wie zum Beispiel bei Dämonprozessen,
die die Kontrolle sofort an die Shell zurückgeben, übernimmt der
erste vom Kernel gestartete Prozess die Funktion des Parent und fragt den
Child-Status mit `wait()` ab.

X> Suche im Internet zum Thema *unix process model* und schaue in den
X> Ergebnissen nach Beispiel-Code. Kompiliere diesen und beobachte, was beim
X> Start der Programme passiert.


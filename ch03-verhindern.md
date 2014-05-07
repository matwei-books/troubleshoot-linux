
## Probleme verhindern

Habe ich mich soweit mit dem System und diesem speziellen Fehler vertraut
gemacht, kann ich überlegen, wie ich das Auftreten dieses Fehlers hätte
vorhersehen und verhindern können.
Natürlich ohne dabei die Funktionalität des Gesamtsystems zu beeinträchtigen.
Falls möglich, schaffe ich die Voraussetzungen dafür.

Wie bereits im Abschnitt über das Vertiefen der Erkenntnis erwähnt, muss ich
hier eine Balance finden.

An einem Ende der Skala habe ich relativ chaotische Systeme mit mehr oder
weniger regelmäßig auftretenden kleinen Problemen, die ich üblicherweise im
Griff habe und auf die ich im Laufe der Zeit vorbereitet bin.
Zuverlässigkeit erreiche ich durch Redundanz auf höherer Ebene, im Extremfall
dadurch, dass die Benutzer wissen, wie sie im Fehlerfall weiter arbeiten
können.

Am anderen Ende sind Systeme, die bis ins kleinste durchdacht sind und
Störungen automatisch kompensieren oder gar korrigieren.
Diese Systeme sind wartungsarm und fallen erst - aber genau dann - aus,
wenn ein Problem auftritt an das der Architekt nicht gedacht hat.

Ich persönlich starte lieber mit einem chaotischen System vom Typ 1 und
entwickle dieses auf Grund der Erkenntnisse, die ich bei Fehlersuchen gewinne,
in Richtung geordnetes System vom Typ 2, dass am Ende genau auf die jeweilige
Situation zugeschnitten ist.
Im Laufe der vielen Fehlersuchen lerne ich, welche Vitalfunktionen
ich überwachen muss, um einen stabilen Betrieb zu gewährleisten.

Ein von Anfang an fertiges System hat demgegenüber den Vorteil der geringeren
Wartung.
Da habe ich weniger zu tun und kann meine Zeit für andere Sachen nutzen.
Diesen Vorteil bezahle ich mit einer höheren Abhängigkeit von demjenigen, der
sich mit dem System auskennt.
In der Regel ist das der Hersteller.
Zwar besteht die Möglichkeit, das System kennenzulernen, zum Beispiel über
gezielte Schulungen oder Workshops.
Meist ist die Motivation zum Lernen aber gering, wenn ich das Gelernte
anschließend nicht anwenden kann.
Damit wiege ich mich bei diesem System in einer trügerischen Sicherheit, bis
zu dem Tage, an dem es an seine Grenzen gelangt und ich auf Grund mangelnder
Kenntnis nicht angemessen reagieren kann.
Ich empfehle an dieser Stelle noch einmal ausdrücklich
[[Taleb2012](#bib-taleb2012)], der dieses Problem umfassend erörtert
und zudem noch kurzweilig zu lesen ist.

### Monitoring

Ich hatte bereits angesprochen, dass ich eine Balance finden muss,
zwischen zu geringem Monitoring, bei dem mich fast jedes Problem
unvorbereitet trifft und übermäßigem Monitoring, bei dem kaum noch
Ressourcen übrig sind für die eigentliche Aufgabe des Systems.

Gehe ich bei der Auswertung der Fehler gründlich und sorgfältig vor und
betrachte nicht jeden Fehler einzeln, sondern setze ihn in Beziehung zu
vorhergehenden Fehlern, dann stoße ich auf die Vitalfunktionen, die ich
beobachten muss, um mit einem Blick entscheiden zu können, ob ein Eingriff
notwendig ist.

Wenn ich den Weg vom chaotischen in Richtung stabiles System gehe,
bekomme ich diese Vitalfunktionen und vor allem ihre Parameter durch eigene
Erfahrung heraus.
Nutze ich ein fertiges, geschlossenes System, bin ich darauf angewiesen, dass
mir der Hersteller die zu überwachenden Funktionen und deren Parameter nennt
oder mich zumindest soweit schult, dass ich sie selbst bestimmen kann.

Die allgemeinen Vitalfunktionen sind diejenigen, nach denen ich bei Problemen
mit der Performance des Systems schaue.
Auf einem Server sind das Auslastung des Prozessors, Speichernutzung und
Eingabe-Ausgabe-Aktivität.
Im Netzwerk sind es Datendurchsatz an neuralgischen Punkten, die Latenz und
die Verfügbarkeit und Antwortzeit essentieller Dienste.

Um Probleme so früh wie möglich zu erkennen, reicht es nicht, den
aktuellen Wert dieser Variablen zu betrachten.
Damit erkenne ich ein Problem erst, wenn es aufgetreten ist.
Will ich vorher reagieren, muss ich die Trends beobachten.


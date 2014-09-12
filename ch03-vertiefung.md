
## Vertiefen der Erkenntnisse {#ch3-sec-5warum}

Um zu einem tieferen Verständnis des Systems zu kommen, kann ich die
5-W-Methode anwenden, bei der ich fünfmal *warum* frage.
Beim ersten Mal frage ich nach den unmittelbaren Ursachen des konkreten, soeben
gelösten Problems.
Dabei berücksichtige ich, dass ein Problem meist nur einen Auslöser aber oft
mehrere Ursachen hat.
Das zweite *warum* fragt nach den Ursachen der Ursachen, dann nach deren
Ursachen und so weiter.
Am Ende kenne ich die wesentlichen Aspekte des Systems, die zu
diesem Fehler geführt haben.

Ein einfaches Beispiel, dass ich Wikipedia entnommen habe, soll das Vorgehen
verdeutlichen.  

1.  Warum startet das Fahrzeug nicht?

    Die Starterbatterie ist leer.

2.  Warum ist die Starterbatterie leer?

    Die Lichtmaschine funktioniert nicht.

3.  Warum funktioniert die Lichtmaschine nicht?

    Der Treibriemen ist gerissen.

4.  Warum ist der Treibriemen gerissen?

    Der Treibriemen wurde nie ausgewechselt.

5.  Warum wurde der Treibriemen nie ausgewechselt?

    Das Fahrzeug wurde bisher nie gewartet.

Die Anzahl der Nachfragen muss nicht stur auf fünf beschränkt bleiben.
Manchmal ist bereits mit weniger Fragen die auslösende Ursache
ermittelt, manchmal braucht es mehr.

Am Ende kann ich meine Gedankenkette überprüfen, indem ich den
Kausalzusammenhang umkehre.
Das sieht für obiges Beispiel dann ungefähr so aus:

1.  Wenn das Fahrzeug nicht gewartet wird, wechselt niemand den Treibriemen.
2.  Wenn der Treibriemen nicht gewechselt wird, reißt er irgendwann.
3.  Wenn der Treibriemen reißt, funktioniert die Lichtmaschine nicht.
4.  Wenn die Lichtmaschine nicht funktioniert, wird die Starterbatterie nicht
    geladen und ist irgendwann leer.
5.  Wenn die Starterbatterie leer ist, startet das Fahrzeug nicht.

Es kann passieren, dass ich nicht wie in obigem Beispiel auf linearem
Wege von einer Ursache zur anderen komme, sondern herausfinde, dass erst das
Zusammentreffen verschiedener Ursachen zu diesem Problem führte.
In diesem Fall habe ich in der nächsten Runde statt einer einzigen
Frage, mehrere.

Lautet zum Beispiel in obigem Beispiel die Antwort auf Frage 4 wie folgt:

4.  Warum ist der Treibriemen gerissen?

    Der eingebaute Treibriemen der Sorte A hält nur 12.000 km,
    Sorte B hält 20.000 km, das Wartungsintervall beträgt 15.000 km.

Dann könnten die folgenden Fragen lauten

5.1. Warum wurde ein Treibriemen der Sorte A eingebaut?

5.2. Warum wurde das Wartungsintervall nicht reduziert?

Natürlich reicht es nicht, nur nach den Ursachen zu fragen.
Vielmehr muss ich in jeder Stufe überlegen, welche Möglichkeiten es gibt, die
entsprechende Ursache zu beseitigen.
Falls das nicht möglich ist, finde ich vielleicht ein paar Parameter,
im Fachjargon KPI (Key Performance Indicator) genannt,
die ich im Monitoring-System beobachten kann und die mir bei
der nächsten Fehlersuche behilflich sind.

Allerdings muss ich sowohl beim Beseitigen der Ursachen als auch beim
Monitoring darauf achten, dass mir die Pferde nicht durchgehen.

Recht einfach ist das beim Monitoring zu erkennen.
Geht mehr als 50% der Systemaktivität nur für das Monitoring drauf, dann wird
mir fast jeder zustimmen, dass ich über das Ziel hinausgeschossen bin.
Wo genau die Grenze ist, liegt im Ermessen des Einzelnen und
natürlich bei den Anforderungen an das System.
Auf jeden Fall ist relativ einfach zu erkennen, ob ein System nur noch damit
beschäftigt ist, sich selbst zu überwachen, oder ob es noch produktiv ist.

Schwerer ist beim Beseitigen erkannter Fehlerursachen einzuschätzen,
wo ich die Grenze ziehen muss.
Ich neige dazu, einem System dass "scheinbar"
fehlerfrei läuft, weniger Aufmerksamkeit zu widmen.
So lange alles gut eingestellt ist und nichts passiert, ist das in Ordnung.
Wenn sich aber unbemerkt über einen längeren Zeitraum kaum wahrnehmbare
Probleme addieren, deren Auswirkungen bis zu einem gewissen Grad automatisch
kompensiert werden, wird es mich unvermittelt und besonders heftig treffen,
wenn die automatische Korrektur nicht mehr ausreicht.
Das passiert meist im ungünstigsten Augenblick.
In [[Taleb2012](#bib-taleb2012)] ist das Problem sehr gut beschrieben.

Ich muss die Balance finden zwischen notwendigem und übermäßigem Monitoring
sowie zwischen anfälligen, pflegeintensiven Systemen, die ich aus dem Effeff
beherrsche und stabilen, wartungsarmen Systemen, die ich im Fehlerfalle erst
kennenlernen muss.

Wo ich den Schwerpunkt setze, hängt unter anderem vom Einsatzzweck, den
Kosten und der geforderten Ausfallsicherheit des Gesamtsystems ab.

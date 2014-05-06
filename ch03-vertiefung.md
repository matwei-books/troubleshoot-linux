
## Vertiefen der Erkenntnisse

Um zu einem tieferen Verständnis des Systems zu kommen, kann ich fünfmal
fragen: *warum*.
Beim ersten Mal frage ich nach den unmittelbaren Ursachen des konkreten, soeben
gelösten Problems.
Dabei berücksichtige ich, dass ein Problem meist nur einen Auslöser aber oft
mehrere Ursachen hat.
Das zweite *warum* fragt nach den Ursachen der Ursachen, dann nach deren
Ursachen und so weiter.
Am Ende kenne ich die wesentlichen Aspekte des Systems, die zu
diesem Fehler geführt haben.

Natürlich reicht es nicht, nur nach den Ursachen zu fragen.
Vielmehr muss ich in jeder Stufe überlegen, welche Möglichkeiten es gibt, die
entsprechende Ursache zu beseitigen.
Falls das nicht möglich ist, finde ich vielleicht ein paar
Parameter, die ich im Monitoring-System beobachten kann und die mir bei
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

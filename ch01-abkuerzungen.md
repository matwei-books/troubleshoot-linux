
## Abkürzungen und Umwege {#sec-heuristik-abkuerzung-umweg}

Im Laufe der Zeit, wenn ich Erfahrungen mit den Systemen gesammelt
habe, kann ich bei etlichen Fehlern intuitiv sagen, woran es liegt.
Das erspart mir erhebliche Zeit bei der Fehlersuche.
Ich muss jedoch immer im Auge behalten, ob meine Annahmen auf einer realen
Grundlage beruhen, oder ob mich meine Intuition hier in die Irre führt.

Das heißt, dass ich jedes Mal, wenn ich eine Abkürzung nehme, mich
vergewissern muss, dass die Voraussetzungen dafür stimmen.

### Abkürzungen

Eine Möglichkeit, die Fehlersuche abzukürzen, ist durch simple Korrelation.
Bei der Aufnahme des Fehlers frage ich, wann der Fehler das erste Mal bemerkt
wurde und wann es das letzte Mal funktioniert hatte.
Im Rahmen der Fehlersuche, schaue ich nach, was am System in diesem Zeitraum
geändert wurde und überlege für jede Änderung, ob diese den beschriebenen
Fehler hervorrufen könnte.
Dazu benötige ich natürlich eine aussagefähige Protokollierung der Änderungen
am System.
Und der Fehler sollte so schnell wie möglich gemeldet werden, damit der
Zeitraum, den ich in Betracht ziehe, nicht zu groß wird.

Eine weitere Abkürzung passiert implizit, wenn ich ähnliche Probleme bereits
hatte.
Dann konzentriere ich mich automatisch auf die Punkte, die beim letzten Mal
zur Lösung geführt hatten.
Natürlich muss ich mich fragen, ob die gleichen Voraussetzungen zutreffen.

### Umwege

Und damit bin ich schon bei den Umwegen, weil ich, anstatt sofort auf die
Lösung zuzustürmen, erst einmal die genauen Umstände prüfe.

Man sagt, Umwege verbessern die Ortskenntnis.
Ich interpretiere das so, dass ein Umweg eine Investition in die Zukunft ist,
wenn ich damit, neben dem eigentlichen Ergebnis, gleichzeitig eine Annahme über
das Gesamtsystem überprüfen kann.
Dann ist der Zeitverlust durch den Umweg der Preis für eine Erkenntnis über das
System.

#### Probe und Gegenprobe

Jeder Test, der erfolgreich ist, sollte durch eine geeignete Gegenprobe
evaluiert werden, die bestätigt, dass der Test auch versagen kann. Das gleiche
gilt für fehlgeschlagene Tests. Diese müssen evaluiert werden, ob sie
funktionieren können.

Ist ein Verbindungsversuch auf einem Rechner fehlgeschlagen, versuche ich den
gleichen Versuch auf einem anderen Rechner, um nachzuweisen, dass er hätte
funktionieren können. Das hat mich schon oft davor bewahrt, einen
Netzwerkfehler zu vermuten, wenn lediglich ein Paketfilter
die Verbindung unterbunden hatte.


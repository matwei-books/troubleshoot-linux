
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

### Umwege

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

Wenn ein Verbindungsversuch auf einem Rechner fehlschlägt, versuche ich den
gleichen Versuch von einem anderen Rechner aus um nachzuweisen, dass er hätte
funktionieren können. Das hat mich schon oft davor bewahrt, einen
Netzwerkfehler zu vermuten, wenn lediglich ein Paketfilter
die Verbindung unterbunden hatte.


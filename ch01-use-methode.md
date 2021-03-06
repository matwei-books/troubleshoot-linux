
## Performanceanalyse: USE-Methode

Gerade bei komplexen und verteilten Systemen ist es oft schwierig, die
richtige Stelle zu finden, die ich mir bei Performanceproblemen genauer
ansehen sollte.

Hin und wieder bekomme ich von Kollegen den Rat, bei einem Performanceproblem
an dieser oder jener Stelle genauer hinzuschauen, *ohne Erklärung warum*.
Das kann dann die richtige Stelle sein oder auch nicht.
Ist es die richtige Stelle, dann vermute ich ein strukturelles Problem, wenn
jemand "aus dem Bauch heraus" die Ursache für ein Performanceproblem benennen
kann.
Ist es die falsche Stelle, habe ich meine Zeit mit aufwendigen Messungen
vergeudet.

Habe ich keine a-priori-Informationen, wähle ich die neuralgischen Punkte
besser methodisch aus und verschwende dabei keine Zeit.

Dafür eignet sich die USE-Methode, die am besten gleich nach der
Problemaufnahme eingesetzt wird.
Brendan Gregg beschreibt diese Methode und andere in
[[Gregg2013](#bib-gregg2013)].
Der Kern dieser Methode ist, dass ich einige wenige Systemparameter an
allen in Frage kommenden Stellen kontrolliere.
In einem Satz zusammengefasst lautet die USE-Methode:
"Für jede Ressource kontrolliere Auslastung (Utilization), Sättigung
(Saturation) und Fehlerereignisse (Errors)".
Diese drei Parameter lassen sich relativ einfach bestimmen, der Knackpunkt
liegt bei "jede Ressource".

Jede Ressource heißt bei einem lokalen Performanceproblem alle physikalischen
Systemkomponenten wie CPU, Platten, Bus, Netzwerk und so weiter.
Bei  virtuellen Systemen muss ich auch das Hostsystem betrachten und bei
Netzwerkspeicher das zugehörige Netzwerk und das Speichersystem.
Bei Performanceproblemen im Netz muss ich auf allen beteiligten Switches,
Routern, Gateways sowie auf den beteiligten Rechnern nachsehen, aber auch auf
den Servern, die für diese Verbindung essentielle Dienste anbieten, wie DNS,
LDAP oder Datenbankserver.

Der erste Schritt bei der USE-Methode ist daher das Erfassen einer Liste aller
beteiligten Ressourcen oder eines Diagramms für die Systemfunktion, das alle
beteiligten Ressourcen enthält.

Beim Erfassen der Ressourcen notiere ich gleich die zugehörigen
Charakteristika, wie maximale Bandbreite, minimale Latenz.
Manchmal zeigt sich bereits beim Eintragen der Charakteristika in das
Funktionsdiagramm eine strukturelle Schwäche des Gesamtsystems.

Habe ich alle Ressourcen identifiziert, kontrolliere ich bei allen Auslastung,
Sättigung und Fehler.

Dabei meint Auslastung bei einigen Komponenten, wie CPU oder Netzverbindungen,
die Prozentzahl der Zeit, die die Ressource in einem gegebenen Intervall
verwendet wird und bei anderen, wie RAM oder Plattenplatz, den Anteil der
verwendeten Kapazität an der Gesamtkapazität.

Sättigung meint die Arbeit, die in Warteschlangen wartet, während die
Ressource zu 100 Prozent ausgelastet ist.
Bei der CPU ist das die Anzahl der Prozesse, die nicht blockiert sind und
keine Rechenzeit zugeteilt bekommen haben, wie sie der Befehl `uptime` anzeigt.
Bei RAM ist es der ausgelagerte Hauptspeicher.
Bei Routern und Gateways die Datagramme, die in Queues auf das Versenden
warten.

Fehler meint die Anzahl der Fehlerereignisse, auch wenn die Operation
wiederholt wird.
Bei RAM fallen darunter die Pagefaults, nach denen eine Speicherseite von der
Platte geladen wird.
Im Netz zählen dazu verworfene und fehlerhafte Datagramme, auch wenn das
Protokoll diese selbstständig wiederholt.

Wichtig ist, ein geeignetes Zeitintervall zu wählen, da kurze Lastspitzen
(Bursts) zu einer Sättigung und damit zu Performanceproblemen führen können,
die in einem zu großen Intervall durch die Mittelung untergehen.

### Wie interpretiere ich die ermittelten Werte?

Bei der Auslastung deuten 100 Prozent meist auf einen Flaschenhals hin.
Eine Ausnahme machen Systeme, die für den maximalen Durchsatz ausgelegt sind.

Eine Auslastung ab 60 Prozent kann zu einem Problem werden, weil kurze
Lastspitzen zur Sättigung führen können, die in der Mittelung untergeht und
weil manche länger dauernden Aktionen nicht unterbrochen werden können,
so dass Verzögerungen durch Warteschlangen häufiger werden.

Jeglicher Grad von Sättigung kann ein Problem sein.
Er kann als Länge der Warteschlange dargestellt werden oder als Zeit, die in
der Warteschlange verbracht wurde.

Gibt es Zähler, die Fehler anzeigen, sind diese es wert, untersucht zu werden.
Insbesondere, wenn sie im Laufe der Untersuchung wachsen.

Negative Fälle sind leicht zu erkennen: niedrige Last, keine Sättigung, keine
Fehler.
Diese kann ich von den weitergehenden Analysen vorerst ausnehmen.

Der Hauptvorteil der USE-Methode ist, dass ich mit relativ geringem Aufwand
herausbekomme, auf welche Punkte ich mich bei der Analyse eines
Performanceproblems konzentrieren sollte.


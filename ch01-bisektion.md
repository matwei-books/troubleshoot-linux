
## Bisektion {#sec-methoden-bisektion}

Die Bisektion, auch Intervallhalbierungsverfahren genannt, verwende ich um
eine Fehlerstelle, die in einem Intervall auftritt, schneller zu finden.
Das Intervall kann örtlich sein - zum Beispiel bei einer Datenübertragung
über mehrere Hops - oder zeitlich - zum Beispiel, wenn sich der Fehler in
Logfiles zeigt und ich den Zeitpunkt des ersten Auftretens über viele
Logdateien hinweg suche.

Das Verfahren selbst ist sehr einfach.
Anstatt das Intervall sequentiell in einer Richtung abzusuchen, halbiere ich
es und untersuche von den entstehenden Teilintervallen dasjenige,
dessen Grenzen sich unterscheiden.
Bei diesem fahre ich mit der Bisektion fort.

Wenn ich zum Beispiel einen Rechner in einem weit entfernten Netz zwar via
Ping erreichen kann, aber nicht mit Port 25, dann kann ich 
zunächst untersuchen, ob Datenpakete zu Port 25 beim Sender abgehen und
ob sie beim Empfänger ankommen.
Kann ich die Datenpakete beim Sender nachweisen, aber beim Empfänger nicht,
dann suche ich etwa auf der Hälfte der Strecke, ob diese Datenpakete
nachzuweisen sind.
Je nachdem, ob sie dort auftreten oder nicht, halbiere ich danach die Strecke
zum Empfänger oder zum Sender. 


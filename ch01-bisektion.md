
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

Stellen wir uns einen Stapel Papier vor, der auf dem Tisch liegt und auf den ein
Tropfen einer sehr aggressiven Flüssigkeit gefallen ist.
Um die guten von den beschädigten Blättern zu trennen, kann ich die
beschädigten Blätte oben entfernen.
Alternativ teile ich den Stapel in der Mitte auf und schaue nach, ob die
Blätter unten beschädigt sind.
Sind sie beschädigt, werfe ich alle abgehobenen Blätter weg und teile den
verbliebenen Stapel wieder bei der Hälfte.
Sind sie nicht beschädigt, sichere ich die untere Hälfte und teile die oberen
Blätter wieder bei der Hälfte.
So fahre ich fort, bis ich zum ersten unbeschädigten Blatt komme.
In den meisten Fällen ist dieses Verfahren schneller, als wenn ich von oben
nach unten durchgeblättert hätte.

Wenn ich zum Beispiel einen Rechner in einem weit entfernten Netz zwar via
Ping erreichen kann, aber nicht mit Port 25, dann kann ich 
zunächst untersuchen, ob Datenpakete zu Port 25 beim Sender abgehen und
ob sie beim Empfänger ankommen.
Kann ich die Datenpakete beim Sender nachweisen, aber beim Empfänger nicht,
dann suche ich etwa auf der Hälfte der Strecke, ob diese Datenpakete
nachzuweisen sind.
Je nachdem, ob sie dort auftreten oder nicht, halbiere ich danach die Strecke
zum Empfänger oder zum Sender. 

Die Bisektion ist nur dann langsamer als die sequentielle Suche, wenn die
gesuchte Stelle sich gleich am Anfang des Intervalls befindet.


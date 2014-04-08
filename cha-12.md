# Netzwerkperfomance {#cha-netz-performance}

Manchmal scheint alles in Ordnung zu sein und trotzdem sind die Kunden nicht
zufrieden. Performance ist ein heikles Thema, weil jeder seine eigene
Vorstellung davon hat, was ausreichende Performance ist.

Probleme mit der Performance des Netzwerkes sind ein heikles Thema.
So heikel, dass manche ihr Heil in immer "dickeren" Leitungen mit immer mehr
Bandbreite suchen, um sich nicht näher mit dem eigentlichen Problem
beschäftigen zu müssen.

Was die Sache so schwierig macht, ist, dass ein Performance Problem sehr viele
Aspekte haben kann.

Da gibt es mitunter eine Diskrepanz zwischen wahrgenommener Performance und
realer Performance.
Ein Kunde ruft an, weil "sein E-Mail-Programm nicht funktioniert".
Er schreibt die E-Mail, drückt auf Senden und dann friert das Programm ein.
Bei näherer Betrachtung stellt sich heraus, dass da ein Anhang von mehreren MB
an der E-Mail hängt und der Upload nur ein paar hundert kBit/s Bandbreite hat.
Ein kurzes Nachrechnen von verfügbarer Bandbreite und zu sendenden Daten
ergibt eine Dauer von mehreren Minuten bei alleiniger Nutzung der Leitung.

Aber auch reale Performanceprobleme können vielfältige Ursachen haben, die es
einzugrenzen gilt.
Oft genug sind Performanceprobleme intermittierend, dass heißt, in einem
Moment da und im nächsten weg.
Darum ist die Fehlersuche bei Performanceproblemen fast immer mit dem Sammeln
von Daten verbunden.

Wenn ich ein Performaceproblem untersuche, beginne ich zunächst die
Charakteristiken des Problems so genau wie möglich zu bestimmen.

Dann versuche ich das Problem grob zu klassifizieren:

*   Ist es ein normales Problem, weil zu viele Daten gesendet werden sollen?

*   Ist es vielleicht ein DNS-Problem (mit Verzögerung am Anfang)?

*   Gibt es Probleme mit dem Durchsatz (bei Downloads)?

*   Liegt das Problem eher an der Latenz (bei interaktiven Programmen)?

Auch die Art des verwendeten Protokolls kann Hinweise auf mögliche Probleme
geben.
So gehen bei datagrammorientierten Protokollen wie UDP Daten einfach verloren,
während bei datenflussorientierten Protokollen wie TCP Zeit verloren geht,
währen das Protokoll die Daten nochmals sendet.

Bei der Klassifizierung hilft mir, bereits bei der Aufnahme des Problems nach
Anzeichen für mögliche Ursachen Ausschau zu halten.

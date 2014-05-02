# Netzwerkperformance {#cha-netz-performance}

Manchmal scheint alles in Ordnung zu sein und trotzdem sind die Kunden nicht
zufrieden. Performance ist ein heikles Thema, weil jeder seine eigene
Vorstellung davon hat, was ausreichende Performance ist.
So heikel, dass mancher sein Heil in immer "dickeren" Leitungen mit immer
höherer Datenübertragungsrate sucht, um sich nicht näher mit dem eigentlichen
Problem beschäftigen zu müssen.

Was die Sache so schwierig macht, ist, dass ein Performance Problem sehr viele
Aspekte haben kann.

Da gibt es mitunter eine Diskrepanz zwischen wahrgenommener Performance und
realer Performance.
Ein Kunde ruft an, weil "sein E-Mail-Programm nicht funktioniert".
Er schreibt die E-Mail, drückt auf Senden und dann friert das Programm ein.
Bei genauer Betrachtung stellt sich heraus, dass da ein Anhang von mehreren MB
an der E-Mail hängt und die Leitung beim Upload nur eine maximale
Datenübertragungsrate von ein paar hundert kBit/s hat.
Ein kurzes Nachrechnen von verfügbarer Datenübertragungsrate und zu sendenden
Daten ergibt bereits eine Dauer von mehreren Minuten bei alleiniger Nutzung
der Leitung durch diesen Upload.

Aber auch reale Performance-Probleme können vielfältige Ursachen haben, die es
einzugrenzen gilt.
Oft genug sind diese Probleme intermittierend, dass heißt, in einem
Moment da und im nächsten weg.
Darum ist die Fehlersuche bei Problemen mit der Performance fast immer mit dem
Sammeln von Daten verbunden.

Wenn ich ein Performance-Problem untersuche, beginne ich zunächst die
Charakteristiken des Problems so genau wie möglich zu bestimmen.

Dann versuche ich das Problem grob zu klassifizieren:

*   Ist es ein normales Problem, weil zu viele Daten gesendet werden sollen?

*   Ist es vielleicht ein DNS-Problem mit Verzögerung am Anfang?

*   Gibt es Probleme mit dem Durchsatz bei längeren Downloads?

*   Liegt das Problem eher an der Latenz bei interaktiven Programmen?

Auch die Art des verwendeten Protokolls kann Hinweise auf mögliche Probleme
geben.
So gehen bei datagrammorientierten Protokollen wie UDP Daten einfach verloren,
während bei datenflussorientierten Protokollen wie TCP Zeit verloren geht,
während das Protokoll die Daten nochmals sendet.

Bei der Klassifizierung hilft es mir, wenn ich bereits bei der Aufnahme des
Problems nach Anzeichen für mögliche Ursachen Ausschau halte, um in der
betreffenden Richtung detaillierter nachzufragen.


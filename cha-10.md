# Totalausfall des Netzwerks {#cha-netz-totalausfall}

Habe ich an einem Rechner überhaupt keine Verbindung zum Netz, oder kann ich
ein ganzes Netzsegment nicht erreichen, spreche ich von einem Totalausfall.

Ich unterscheide zwei Arten von Totalausfall im Netz, je nachdem, von wo
ich diesen betrachte.
Untersuche ich es von einem Rechner, der überhaupt keine Verbindung hat,
dann sehe ich das Problem von innen, weil ich versuche, mit dem Rechner
innerhalb eines Segments eine Verbindung zu bekommen.
Ist ein ganzes Netzsegment nicht mehr erreichbar, dann betrachte ich das
Problem von außen, da ich mich in einem anderen Segment bewege und
andere Rechner erreichen kann, nur dieses Netzsegment und die Rechner darin
nicht.

Bei der Betrachtung von innen, überprüfe ich die Schichten des OSI-Modells von
unten nach oben.
Das heißt, ich fange bei der Kabelverbindung zum Switch an und arbeite mich zur
IP-Konfiguration hoch, bis ich Kontakt zu mindestens einem anderen Rechner
bekomme.

Bei der Betrachtung von außen muss ich die Topologie des Netzwerks kennen.
Dann überprüfe ich den Weg zum nicht erreichbaren Segment und kontrolliere
auf dem letzten erreichbaren Gateway dort hin die physikalische Verbindung
und die Routen.
Auf diese Weise arbeite ich mich bis zum ausgefallenen Netzsegment vor.

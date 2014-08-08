
## ethtool, mii-diag, mii-tools {#sec-netz-werkzeuge-ethtool}

Mit den Programmen `ethtool`, `mii-diag` beziehungsweise `mii-tool` kann ich
die Konfiguration der Ethernetschnittstellen anzeigen und manipulieren,
zumindest bei modernen Schnittstellen.

Dazu verwenden diese Programme teilweise das Media Independend Interface (MII),
von dem sich auch der Name ableitet.

Welches Programm installiert ist, hängt von der Linux-Distribution ab.
Ob ich es überhaupt verwenden kann, hängt von der Ethernetkarte ab.
Moderne Ethernetkarten und die Onboardschnittstellen neuerer Rechner
funktionieren üblicherweise gut mit diesen Programmen.

Unter anderem kann ich mit diesen Programmen

*   die Ethernet-Geschwindigkeit, das Duplexverhalten und das Aushandeln
    der Parameter mit dem Switch beziehungsweise der Gegenstelle einstellen
    oder abfragen

*   die Wake-On-Lan-Konfiguration bearbeiten

*   Selbsttests anstoßen

Gerade die Möglichkeit, Fehlanpassungen in der Geschwindigkeit oder beim
Duplexverhalten zu erkennen, kann sich als sehr wertvoll bei der Diagnose
von Performanceproblemen erweisen.

Bei einer LWL-Verbindung über mehrere Kilometer hatten wir ernste
Performanceprobleme, bei denen die Transferrate in einer Richtung auf wenige
KB/s beim beidseitigen Lasttest herunter ging.
Der erste Gedanke war eine schlechte Faser, da das Problem nur in einer
Richtung auftrat.
Mit den *mii-tools* konnten wir eine Fehlanpassung der Ethernetkarte mit dem
Medienwandler diagnostizieren.
Nachdem wir die Schnittstelle auf Full-Duplex eingestellt hatten, blieb die
verfügbare Datenübertragungsrate auch bei Volllast in beiden Richtungen im erwarteten
Rahmen.


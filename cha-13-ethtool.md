
## ethtool, mii-diag, mii-tools {#sec-netz-werkzeuge-ethtool}

Mit den Programmen ethtool, mii-diag beziehungsweise mii-tool kann ich die
Konfiguration der Ethernetschnittstellen anzeigen und manipulieren,
zumindest bei modernen Schnittstellen.

Dazu verwenden diese Programme meist das Media Independend Interface (MII),
von dem sich auch der Name ableitet.

Welches Programm installiert ist, hängt von der verwendeten
Linux-Distribution ab. Ob man es überhaupt verenden kann, hängt auch von der
verwendeten Ethernetkarte ab. Moderne Ethernetkarten und die
Onboardschnittstellen neuerer Rechner funktionieren üblicherweise gut mit
diesen Programmen.

Unter anderem kann man mit diesen Programmen

*   die Ethernet-Geschwindigkeit, das Duplexverhalten und das Aushandeln
    der Parameter mit dem Switch beziehungsweise der angeschlossenen
    Gegenstelle einstellen oder abfragen

*   die Wake-On-Lan-Konfiguration bearbeiten

*   Selbsttests anstoßen

Gerade die Möglichkeit, Fehlanpassungen in der Geschwindigkeit oder beim
Duplexverhalten zu erkennen, kann sich als sehr wertvoll bei der Diagnose
von Performanceproblemen erweisen.

Bei einer LWL-Verbindung über mehrere Kilometer hatten wir ernste
Performanceprobleme, bei denen die Transferrate in ener Richtung auf wenige
KB/s beim beidseitigen Lasttest herunterging. Der erste Gedanke war eine
schlechte Faser, da das Problem nur in einer Richtung auftrat. Mit den
mii-tools konnten wir eine Fehlanpassung der Ethernetkarte mit dem
Medienwandler diagnostizieren. Nachdem wir die Schnittstelle auf Full-Duplex
eingestellt hatten, blieb die verfügbare Bandbreite auch bei Volllast in
beiden Richtungen im erwarteten Rahmen.



## Routing-Algorithmen

Die heute eingesetzten Routing-Protokolle basieren auf einem von zwei
Algorithmen: dem *Distanzvektor-Algorithmus* und dem *Link-State-Algorithmus*.

Beide sind verteilte Algorithmen, bei denen jeder Router für sich selbst die
optimale Route zu einem Netzbereich ermittelt.
Demgegenüber steht der Ansatz von OpenFlow bei Routern und Switches der
erlaubt, die Routen zentral zu berechnen und dann an die verschiedenen Router
und/oder Switches zu verteilen.
Dieser Ansatz erlaubt auch experimentelle Routing-Algorithmen auszuprobieren,
ohne dass an der Hardware oder Routersoftware etwas geändert werden müsste.

Bei den beiden verteilten Algorithmen muss man einen Kompromiss finden
zwischen dem nötigen Netzverkehr für das Routingprotokoll und der
Rechenleistung für die Berechnung der Routen.
Bei Routingprotokollen mit Distanzvektor-Algorithmus steigt der Datenverkehr
für das Routingprotokoll sehr stark mit der Vergrößerung des Netzwerks, bei
den Routingprotokollen mit Link-State-Algorithmus steigt der Rechenaufwand
stärker.

### Distanzvektor-Algorithmus

Dieser Algorithmus zur Bestimmung der optimalen Route wird zum Beispiel bei
den Protokollen RIP und RIP2 verwendet.

Dabei informiert jeder Router alle direkten Nachbarn über alle ihm selbst
bekannten Routen nebst deren Metriken.
Jeder Router, der Informationen von seinen Nachbarn erhält, fügt neu
bekannt gewordene Routen zu seiner eigenen Routingtabelle hinzu und behält bei
bereits bekannten Routen diejenige mit der kleinsten Metrik.

Distanzvektor-Protokolle werden auch als Routing nach Gerücht bezeichnet.
Fehlerhafte Routinginformationen verbreiten sich genau so schnell wie gute.

### Link-State-Algorithmus

OSPF ist ein Protokoll, dass einen Link-State-Algorithmus verwendet.

Dieser Algorithmus arbeitet in zwei Schritten: zunächst erstellt jeder Router
anhand der Zustandsinformationen der Verbindungen seiner Nachbarn eine
topologische Karte (einen Graphen) des gesamten Netzwerks, im zweiten Schritt
errechnet er mit Hilfe des Dijkstra-Algorithmus den optimalen Pfad zu allen
bekannten Netzen.
Die Erläuterung des Dijkstra-Algorithmus erspare ich mir an dieser Stelle, sie
wird bei der Fehlersuche eher nicht benötigt.

Es ist leicht zu erkennen, dass bei diesem Algorithmus der Datenverkehr bei
Änderungen im Netz nicht so schnell wächst, wie der Aufwand zur
Erstellung des Graphen und der Berechnung der optimalen Route.

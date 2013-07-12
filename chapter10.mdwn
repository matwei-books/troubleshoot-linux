# Partieller Ausfall des Netzwerks {#cha-netz-teilausfall}

Wenn nur ein oder mehrere Dienste eines Servers nicht funktionieren, oder
ein Server in einem ansonsten gut erreichbaren Netzsegment, handelt es sich
um einen partiellen Ausfall im Netz.

Bemerke ich einen Teilausfall eines Netzes beziehungsweise bekomme diesen
mitgeteilt, interessiert mich als erstes, ob ich in dem betreffenden
Netzsegment bin oder aussen.
In dem Segment bin ich zum Beispiel, wenn der erste verfügbare Rechner an das
betreffende Segment angeschlossen ist.
In diesem Fall kann ich meist so vorgehen, prüfe ich als erstes, wie im
[Abschnitt über Netzwerktotalausfall](#sec-gar-kein-netz) beschrieben,
ob das problematische Netzsegment in sich funktioniert.
Habe ich mich von der Funktionisfähigkeit
des Netzsegmentes überzeugt oder es funktionsfähig gemacht, kommt als
nächstes die Verbindung zu anderen Netzen dran.

Außerhalb des betreffenden Netzsegmentes bin ich, wenn der nächste Rechner
in diesem so weit weg ist, dass ich zunächst auf alle Möglichen Arten
versuche über das Netzwerk an das Netzsegment heran zu kommen, bevor ich
mich auf den Weg mache. Nun wird ein Ausfall eines Netzsegmentes im
Allgemeinen dadurch gekennzeichnet, dass das Segment nicht via Netz
erreichbar ist. Was ich aber tun kann und sollte, ist, mich zu überzeugen,
dass das auch wirklich so ist und nicht nur so scheint. Das kann ich, indem
ich mir einen Überblick beschaffe, ob in den Routingprotokollen der Gateways
eine Übersicht über die bekannten Routen im Netzwerk verschaffe. Taucht die
Route zu dem Netz dort auf, habe ich eventuell gute Chancen, zumindest das
Gateway dort zu erreichen und von diesem aus das Netzsegment zu analysieren.
Taucht die Route dort nicht auf, ist das zwar ein schlechtes Zeichen, aber
ich kann immer noch versuchen, von einem Router zum nächsten zu hangeln um
so nah wie möglich an das Netz heranzukommen. Dazu brauche ich aber eine
genaue Kenntnis des Gesamtnetzwerkes. Dabei kann ich mir unterwegs die Sicht
jedes einzelnen Gateways auf das Gesamtnetz und seine Routen ansehen und
eventuell mögliche Routingprobleme finden. Das letzte erreichbare Gateway
vor dem ausgefallene Netz kann bereits Hinweise auf die Ursache des Ausfalls
liefern.

Habe ich mich über das Netzwerk bis zum Gateway an das ausgefallene Netzwerk
vorgearbeitet, dann prüfe ich mit diesem die grundlegende Funktionsweise des
Netzsegments, wie im [Abschnitt über Netzwerktotalausfall](#sec-gar-kein-netz)
beschrieben.
Funktioniert das Netzsegment grundsätzlich, arbeite ich mich  nach oben und
überprüfe die verschiedenen Netzdienste, wie DHCP, Namensauflösung,
Zeitserver, Netzanmeldung, soweit vorhanden und eingesetzt.

## Instabile Routen {#sec-instabile-routen}

### OSPF {#sec-netzausfall-ospf}

A> ## Beispiel: statische Route in OSPF
A> 
A> ### Das ist ein Beispiel für ein selbstgemachtes Problem.
A> 
A> % Hier Bild vom Netzwerk
A> 
A> In dem angedeuteten Netzwerk wurde der Router C umgeschwenkt vom direkten
A> Anschluß im Core-Netz auf einen Anschluß via Router D. Im Core-Netz wurde
A> OSPF für das Routing verwendet, zwischen D und C sowie zwischen B und D
A> wurde RIP verwendet.
A> 
A> Später wurde das Core-Netz erweitert und Router D in die Area mit
A> aufgenommen. D bekam die Route von C immer noch via RIP. Trotzdem hatte D
A> in seiner Routingtabelle B als Router zu C. B hingegen hatte gar keine
A> Route zu C.
A> 
A> Erst ein Blick in die OSPF Route Database (`show ip ospf database`)
A> zeigte, dass Router A eine statische Route zu C via B einspeiste.
A> Da die Übergabe der Route von RIP nach OSPF zunächst nicht
A> richtig funktionierte, wurde auf Router A eine statische Route zu C
A> eingespeist, die B als Router auswies. Das funktionierte, weil zu dem
A> Zeitpunkt B Borderrouter war und die externe Route über ihn ging. Mit dem
A> Ausweiten der Area war B aber nicht mehr Borderrouter und die Notlösung
A> mit der statischen Route verursachte den Fehler.
A> 
A> Insgesamt lassen sich folgende Ursachen, die in diesem Fall zusammen den
A> Fehler auftreten ließen, angeben:
A>
A> *   Das Einspeisen der statischen Route war per se ein Fehler. Besser
A>     wäre die genaue Diagnose des ursprünglichen Routingproblems. Dieses
A>     Problem wurde kaschiert, weil B Borderrouter war und die korrekte
A>     Route auf anderem Weg erfuhr. Erschwerend kam hinzu, dass die
A>     statische Route nicht auf dem Gateway selbst, sondern auf einem
A>     anderen Router (der als zentraler Punkt für das Einspeisen von
A>     statischen Routen gedacht war) erfolgte.
A>
A> *   Durch das Erweitern der OSPF-Area war B auf einmal kein
A>     Borderrouter mehr und konnte die korrekte Route durch den Wegfall von
A>     RIP auch nicht mehr auf anderem Weg lernen.
A>
A> *   Die OSPF-Route hatte auf D eine höhere Priorität als die
A>     RIP-Route. Darum stellte D sein Routing zu C in Richtung B um und
A>     konnte das Netz hinter C nicht mehr erreichen.
A>
A> Merke: Bei der Verwendung von Routingprotokollen, sollten statische Routen
A> nur in wohlbegründeten Ausnahmefällen eingespeist werden und vor allem -
A> wenn möglich - auf dem Router, der für die Route zuständig ist.

## Notizen

*    Exkursbox: Loopback-Adressen

*    Routersoftware Quagga:
     OSPF-BDR hatte falschen Neighbor (openbsd, GeNUScreen) -> Reboot
     Fehlende Rückroute

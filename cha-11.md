# Partieller Ausfall des Netzes {#cha-netz-teilausfall}

Ich spreche von einem Teilausfall im Netz, wenn wenigstens die Grundfunktionen
bis OSI-Schicht 4 funktionieren und ich alle Netzsegmente erreichen kann.
In diesem Fall kann ich das Netz selbst zur Fehlersuche einsetzen und
brauche mir nicht die Schuhsohlen ablaufen, um vor Ort nach dem Rechten zu
sehen oder via Telefon zu debuggen.

Was also kennzeichnet einen Teilausfall im Netz?

Da ist zunächst der Ausfall essentieller Dienste im Netz, wie DHCP, DNS, NTP,
Kerberos und weiterer.
Der Ausfall einiger dieser Dienste kann Auswirkungen haben, die die Kunden
als Totalausfall wahrnehmen.
Das muss ich bereits bei der Aufnahme des Problems berücksichtigen.
Für den Kunden macht es keinen Unterschied, ob er das Netz nicht nutzen kann,
weil ein Kabel unterbrochen ist, oder weil sein Rechner keine IP-Adresse
zugewiesen bekam.
Für mich, der ich den Fehler beseitigen will, ist der Unterschied durchaus von
Belang.

Weiterhin betrachte ich als Teilausfall, wenn ich einzelne Rechner oder
einzelne Dienste auf bestimmten Rechnern nicht erreichen kann.
Im Laufe der Untersuchung wird daraus vielleicht ein Total- oder
Teilausfall des Rechners; dann behandle ich das, wie in
Teil 2 dieses Buches beschrieben.

Als drittes zähle ich partielle Einschränkungen von funktionierenden
Diensten dazu.
Darunter verstehe ich zum Beispiel Mengenbeschränkungen beim Upload auf
Webserver oder beim Versand von E-Mail, Zugriffsbeschränkungen für einzelne
Netzsegmente und ähnliches.
Diese lassen sich in vielen Fällen auf die Konfiguration des betreffenden
Dienstes zurückführen.

Schließlich besteht die Möglichkeit, dass ein Dienst absichtlich gestört wird.
Angriffe von Dritten und deren Abwehr sind jedoch nicht Thema dieses Buches
und werden höchstens am Rande behandelt.

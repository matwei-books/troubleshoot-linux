# Totalausfall {#cha-lokal-totalausfall}

Ein Totalausfall bedeutet für mich zuallererst: der Rechner selbst ist keine
große Hilfe bei der Fehlersuche.
Das muss nicht heißen, dass der Rechner überhaupt nicht mehr reagiert, aber
auf jeden Fall stehen mir nicht alle Werkzeuge zur Verfügung, die ich sonst
zur Analyse einsetzen könnte.

Ich betrachte die folgenden Probleme als Totalausfall eines Rechners.

*  Hardwarefehler, der Rechner reagiert überhaupt nicht beim Einschalten.
   Abgesehen von dem Tipp, den Stromanschluss zu überprüfen, gehe ich darauf
   nicht weiter ein.

*  Boot-Probleme, zwar passiert etwas, die Hardware scheint größtenteils in
   Ordnung, aber das Betriebssystem wird nicht gestartet.
   Ich analysiere den Bootprozess Schritt für Schritt, beobachte, wie
   weit das System kommt und versuche die Ursache zu ermitteln.

*  Der Rechner war normal gestartet, hat eine Zeit lang gearbeitet, aber jetzt
   reagiert er nicht mehr.
   Ich versuche zunächst den Rechner mit Magic SysRequest geordnet neu zu
   starten und nachträglich zu analysieren.
   Falls möglich, werte ich die mit SysRequest gewonnenen Erkenntnisse aus.

*  Überlast, Swapping, Thrashing. Ich sehe oder höre, dass der Rechner
   intensiv arbeitet.
   Trotzdem reagiert er sehr langsam.
   Auf Grund von Timeouts kann ich mich nicht einmal mehr anmelden, in einer
   Shell bekomme ich kein Programm gestartet.
   Wenn ich die Last nicht auf anderem Weg vom Rechner nehmen kann, bleibt mir
   nur, den Rechner neu zu starten.
   Anschließend versuche ich zu ermitteln, was die Überlast ausgelöst hatte.

*  Ausfälle bei virtuellen Maschinen.
   Das sind die gleichen Fehler wie bei "echten" Maschinen aus Blech.
   Hinzu kommen Probleme mit der Virtualisierungsschicht.
   Im Gegenzug bekomme ich mehr Diagnosemöglichkeiten an die Hand.

   Neben dem Totalausfall des Gastsystems gibt es noch die Möglichkeit,
   das das Wirtssystem ausgefallen ist. Diesen Fehler behandle ich, wie oben
   beschrieben.

   Bei den Gastsystemen sind meine Optionen abhängig von der verwendeten
   Virtualisierungslösung und deren Werkzeugen zur Diagnose.
   Manchmal kann ich einfach die Festplattenpartitionen des Gastsystems im
   Hostsystem oder einem anderen Gastsystem einhängen und dann dort untersuchen.
   Damit stehen mir zusätzliche Werkzeuge zur Verfügung.


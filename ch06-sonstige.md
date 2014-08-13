
## Sonstige Probleme

### Zeitfehler

Ich hatte bereits erwähnt, dass einige Programme empfindlich auf eine falsche
Systemzeit reagieren.

Das betrifft vor allem Systeme, die über mehrere Rechner synchron gehalten
werden müssen, wie zum Beispiel Failoversysteme, oder kryptographische
Protokolle, die die Systemzeit verwenden um Replay-Attacken zu vermeiden.

Neben diesen gibt es Programme, die auf eine monoton ansteigende Zeit
angewiesen sind. Zum Beispiel, weil sie die Systemzeit zur Sortierung von
Ereignissen verwenden oder zur Bestimmung von Dateinamen.

Einige dieser Systeme überwachen die Systemzeit und beenden sich, sobald
sie bemerken, dass diese rückwärts läuft.
Das muss ich beachten, wenn ich die Systemzeit von Hand auf einen älteren
Zeitpunkt zurücksetzen will.

In einem Fall beendete sich ein Mailserver-Prozess, weil die Systemzeit
einen größeren Sprung rückwärts machte.
Ich hatte beim Setzen der Zeit nicht daran gedacht und bekam das erst durch
das Monitoring mit.

Bei virtuellen Systemen muss ich im Hinterkopf behalten, dass die
Systemzeit auch vom Hostsystem zu den Gastsystemen übernommen werden kann.
Setze ich unbedacht die Systemzeit des Hostsystems zurück, kann ich unter
Umständen sehr schnell einige Gastsysteme unbrauchbar machen.

Ein Grund mehr, die Systemzeit aller Rechner im Netz synchron zu halten.


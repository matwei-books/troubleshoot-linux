
## Sonstige Probleme

### Zeitfehler

Ich hatte bereits erwähnt, dass einige Programme empfindlich auf eine falsche
Systemzeit reagieren.

Das betrifft vor allem Systeme, die über mehrere Rechner synchron gehalten
werden müssen, wie zum Beispiel Failoversyseme, oder kryptographische
Protokolle, die die Systemzeit verwenden um Replay-Attacken zu vermeiden.

Neben diesen gibt es Programme, die auf eine monoton ansteigende Zeit
angewiesen sind. Zum Beispiel, weil sie die Systemzeit zur Sortierung von
Ereignissen verwenden oder zur Bestimmung von Dateinamen.

Einige dieser Systeme überwachen aus diesem Grund die Systemzeit und beenden
sich, wenn sie bemerken, dass die Systemzeit rückwärts läuft.
Das muss ich beachten, wenn ich die Systemzeit von Hand auf einen älteren
Zeitpunkt zurücksetze.

In einem konkreten Fall beendete sich ein Mailserver-Prozess (Dovecot), weil
die Systemzeit einen größeren Sprung rückwärts machte.
Ich hatte beim Setzen der Zeit nicht daran gedacht und bekam das erst durch
das Monitoring mit.

Bei virtuellen Systemen muss ich auch im Hinterkopf behalten, dass die
Systemzeit auch vom Hostsystem zu den Gastsystemen übernommen werden kann.
Setze ich unbedacht die Systemzeit des Hostsystems zurück, kann ich unter
Umständen sehr schnell einige Gastsysteme unbrauchbar machen.

Ein Grund mehr, die Systemzeit aller Rechner synchron zu halten.


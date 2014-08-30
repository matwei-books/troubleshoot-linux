
## Sonstige Probleme

### Umlaute

Es erscheint vielleicht anachronistisch, dass ich heutzutage, wo es möglich
ist, mehrsprachige Texte am Computer zu verarbeiten, von Umlauten als Problem
spreche.

Darum muss ich an dieser Stelle differenzieren.
Umlaute und sprachspezifische Sonderzeichen in Texten stellen in den
allermeisten Fällen kein Problem dar, wenn die Kodierung bekannt und
konsistent ist.

Problematisch werden Umlaute genau dann, wenn das nicht der Fall ist.
Das heißt, wenn die Kodierung nicht bekannt oder nicht konsistent ist.

Das ist oft der Fall, wenn es um IDs geht, die über mehrere heterogene Systeme
verwendet werden oder deren Kodierung nicht bekannt ist.

Was meine ich hier mit IDs?

Das sind zum Beispiel Loginnamen.
Zwar gibt es in der Passwortdatenbank eine numerische UID und einen
alphanumerischen Benutzernamen.
Da letzterer zur Anmeldung am System verwendet wird, stellt er ebenfalls eine
ID dar.
Daher haben Umlaute hier nichts zu suchen.

O.K. Welcher UNIX-Administrator, der etwas auf sich hält, würde hier Umlaute
verwenden?

Heutzutage kommen die alphanumerischen Benutzer-IDs aber nicht nur aus der
traditionellen Passwortdatenbank */etc/passwd*.
Schon wenn die Anmeldeinformationen aus einem Directory, zum Beispiel via LDAP
kommen, habe ich darauf mitunter keinen Einfluss mehr.
Nun, die Anzahl der Personen, die neue Benutzer-IDs vergeben dürfen, ist meist
überschaubar und hier greifen erzieherische Maßnahmen.

Aber es gibt noch andere IDs, bei denen Umlaute zu Problemen führen können.

Dateinamen sind IDs.
Auch wenn man mir zeigt, wie sich eine Datei mit Umlauten im Namen anlegen und
problemlos weiter verwenden läßt, ist das kein Beweis des Gegenteils.

Ich sagte eingangs, dass Umlaute problemlos sind, wenn die Kodierung bekannt
und konsistent ist.
Das ist auf einem einzelnen System immer gegeben, innerhalb eines Netzes
homogener Systeme ebenfalls.

Erst bei heterogenen Systemen wird es problematisch.
Heterogen ist zum Beispiel ein Webserver, der seine Seiten in einer Kodierung
ausgibt, dessen Dateisystem aber eine andere Kodierung verwendet.
Dann kann ich vielleicht eine verlinkte Datei mit Umlaut im Namen im
Directorylisting des Webservers sehen und mit `ls` den gleichen Namen im
Dateisystem.
Trotzdem bekomme ich einen Fehler, wenn ich die Datei im Browser laden will.

Und, wo wir gerade bei Webservern sind: auch die Namen auf einfachen
Formularbuttons sind IDs und Umlaute können den Button unbenutzbar machen.
Zum Beispiel, wenn ein Proxy zwischen Webserver und Browser liegt, der die
ausgelieferten Webseiten umkodiert.

Ich hatte auch den Fall, dass ein Benutzer Datenbanktabellen mit Umlauten im
Tabellen oder Spaltennamen angelegt hatte und sich wunderte, dass er auf einem
System damit arbeiten konnte und auf einem anderen nicht.
Auch das sind IDs und das Problem lag an der unterschiedlichen Kodierung der
Umlaute.

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


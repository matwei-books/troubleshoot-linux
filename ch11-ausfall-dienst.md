
## Ausfall einzelner Dienste

Ohne Monitoring bemerke ich den Ausfall eines Dienstes oft erst dann, wenn
jemand ihn benutzen will.
Das kann sehr lange nach dem Ausfall sein, so dass mir die Korrelation
von Ereignissen bei der Suche nach der Ursache wenig hilft.
Ein Grund mehr, möglichst alle Dienste automatisch in geeigneten Zeitabständen
zu überprüfen.
Wird der Ausfall ohne Monitoring schließlich bemerkt, ist die Problemlösung
oft dringend, wenn jemand diesen Dienst jetzt benutzen will.

Genug der Vorrede, wie gehe ich vor, wenn ich einen ausgefallenen
Netzwerkdienst wieder in Gang bringen will?
Dazu muss ich zwei Fragen beantworten:

1.  Bekomme ich Kontakt zu dem Dienst?

2.  Antwortet der Dienst, wie erwartet?

Für die erste Frage benötige ich, falls ich keinen Kontakt bekomme, genaue
Kenntnis der Netztopologie und der Protokolle, insbesondere der verwendeten
TCP- oder UDP-Ports.
Ich versuche zunächst Kontakt zu den vom Protokoll verwendeten Ports zu
bekommen, funktioniert das nicht, dann zu anderen Ports - 22/tcp für SSH zum
Beispiel - oder via PING.
Im Fehlerfall versuche ich den Kontakt von verschiedenen Stellen im Netz aus,
um den Einfluss von Firewalls oder Routingproblemen auszuschließen.
Kann ich den betreffenden Rechner überhaupt nicht erreichen, behandle ich das
Problem, wie bei einem Totalausfall des Netzwerks an einem Rechner, und zwar an
dem Rechner, auf dem der Dienst laufen soll.
Ist der Rechner zu erreichen, aber nicht die Ports, die der
ausgefallene Dienst benutzt, melde ich mich am Rechner an und behandle das
Problem, wie in Teil 2 beschrieben, als partiellen lokalen Ausfall.

Wenn ich Kontakt zu dem Dienst bekomme, hängt mein weiteres Vorgehen von dem
Dienst und den verwendeten Protokollen ab.
Erlaubt das Clientprogramm erweiterte Möglichkeiten zum Debugging, nutze ich
diese.
Bei Plain-Text-Protokollen, wie HTTP, SMTP und ähnlichen, kann ich
mit `telnet` oder `nc` den Server direkt ansprechen und die Antwort auswerten.
Viele Protokolle sind in RFC beschrieben, die ich bei der IETF finden kann,
wie zum Beispiel [RFC 5321](http://tools.ietf.org/html/rfc5321) für SMTP.
Für die verschlüsselten Pendants dieser Protokolle kann ich mit OpenSSL eine
Verbindung aufbauen:

{line-numbers=off,lang="text"}
    $ openssl s_client -connect www.example.com:443

Für binär kodierte Protokolle, wie DNS, LDAP oder NTP, greife ich auf
geeignete Client-Programme zurück.
Oft kann ich für Tests auch Monitor-Plugins von Nagios verwenden.
In hartnäckigen Fällen hilft mir manchmal ein Perl-Skript, wenn ich ein
spezielles Problem untersuchen will.
Auf CPAN finde ich meist ein passendes Modul für das verwendete Protokoll.
Bei diesen Tests kann ich mit `tcpdump` oder `wireshark` den Datenverkehr
beobachten.

Zusätzlich zu den Verbindungstests melde ich mich am Server, auf dem der
Dienst läuft, an und beobachte die Lognachrichten des Dienstes.
Dabei beachte ich auch die Umgebung auf dem Server, wie im Abschnitt
über die [ersten Minuten auf dem Server](#sec-local-erste-minute) beschrieben.

Bei intermittierenden Problemen beachte ich zusätzlich das Verhalten des
gesamten Verkehrs im Netzwerk, wenn ich dazu verlässliche Zahlen habe.
Außerdem hilft in manchen Fällen, das Timing des Protokolls genauer anzusehen.

Schließlich beziehe ich den Hersteller-Support ein, wenn ich solchen für
den betreffenden Dienst zur Verfügung habe.
Dabei hilft mir, wenn ich meine bisherigen Analysen für Nachfragen seitens der
Supportmitarbeiter gut geordnet habe.

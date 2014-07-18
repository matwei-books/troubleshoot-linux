
## Ausfall nicht-essentieller Dienste

Ohne Monitoring bemerke ich den Ausfall eines Dienstes oft erst dann, wenn
jemand ihn benutzen will.
Das kann sehr lange nach dem Ausfall sein, so dass mir die Korrelation
von Ereignissen bei der Suche nach der Ursache wenig hilft.
Ein Grund mehr, möglichst alle Dienste automatisch in geeigneten Zeitabständen
zu überprüfen.

Doch genug der Vorrede, wie gehe ich vor, wenn ich einen ausgefallenen
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
Kann ich den Rechner erreichen, aber nicht die Ports, die der
ausgefallene Dienst benutzt, melde ich mich am Rechner an und behandle das
Problem, wie in Teil 2 beschrieben, als partiellen lokalen Ausfall.

Bekomme ich Kontakt zu dem Dienst, hängt mein weiteres Vorgehen von dem
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
    $ openssl s_client -connect www.example.com:443 -crlf

Für binär kodierte Protokolle, wie DNS, LDAP oder NTP, greife ich auf
geeignete Client-Programme zurück.
Oft kann ich für Tests auch Monitor-Plugins von Nagios verwenden.
In hartnäckigen Fällen hilft mir manchmal ein Perl-Skript, wenn ich ein
spezielles Problem untersuchen will.
Auf CPAN finde ich meist ein passendes Modul für das verwendete Protokoll.

Zusätzlich zu den Verbindungstests melde ich mich am Server, auf dem der
Dienst läuft, an und beobachte die Lognachrichten des Dienstes.
Dabei beachte ich auch die Umgebung auf dem Server, wie im Abschnitt
über die [ersten Minuten auf dem Server](#sec-local-erste-minute) in Kapitel
sechs beschrieben.

Bei intermittierenden Problemen beachte ich zusätzlich das Verhalten des
gesamten Verkehrs im Netzwerk, wenn ich dazu verlässliche Zahlen habe.
Außerdem hilft in manchen Fällen, das Timing des Protokolls genauer anzusehen.

Schließlich beziehe ich den Hersteller-Support ein, wenn ich solchen für
den betroffenen Dienst zur Verfügung habe.
Dabei hilft mir, wenn ich meine bisherigen Analysen für Nachfragen seitens der
Supportmitarbeiter gut geordnet habe.

### Hinweise zu einigen Plaintext-Protokollen

Obwohl Plaintext-Protokolle scheinbar wertvolle Bandbreite verschwenden,
haben sie doch einige unbestreitbare Vorteile.

Neben der einfach zu beschreibenden Darstellung des Protokolls erlaubt die
Verwendung von Plaintext die Emulierung und Beobachtung des Protokolls
mit simplen Hilfsmitteln wie `telnet`, `nc` oder dem Menüpunkt
*Follow TCP-Stream* bei `wireshark`.
Außerdem ist die Entwicklung von Programmen dafür wesentlich einfacher, weil
man die Ausgaben einfach in eine Textdatei schreiben und in Ruhe mit jedem
beliebigen Editor analysieren kann.

Bei der Fehlersuche kann ich dasselbe Werkzeug für die Analyse der
unterschiedlichsten Protokolle verwenden und muss nicht erst die Bedienung und
die Optionen für Spezialwerkzeuge lernen, die ich dann nur für genau ein
Protokoll verwenden kann.

In den folgenden Abschnitten zeige ich auf, wie ich einige der gängigsten
Plaintext-Protokolle bei der Fehlersuche verwende und welche Informationen ich
dabei gewinnen kann.

#### HTTP

Das Hypertext Transfer Protocol ist nahezu überall anzutreffen.
Version 1.1 ist in RFC 2616 beschrieben und Version 1.0 in RFC 1945.
Für die Fehlersuche kann ich die beiden meist gleich behandeln.
Ich kontaktiere den Server mit `nc` und der Option `-C`, damit `nc` als
Zeilenende die Kombination CRLF über das Netz sendet.

Ich sende, nachdem die TCP-Verbindung etabliert ist,
einen Befehl (Request genannt) einen URI, der angibt, was ich haben will
und die Versionsnummer des Protokolls in der ersten Zeile.
Darauf können weitere Kopfzeilen folgen, die mit einer Leerzeile abgeschlossen
werden.
Ich verwende meist nur *Host:*, um zu überprüfen, dass der Server die
richtigen Seiten ausliefert, wenn er mehrere virtuelle Webserver anbietet.
Als letztes folgt eine leere Zeile, die anzeigt, dass keine weitere Kopfzeilen
folgen.

{line-numbers=off,lang="text"}
    $ nc -C localhost 80
    GET / HTTP/1.0
    Host: localhost
    

Daraufhin sendet der Server seine Antwort.
Diese enthält in der ersten Zeile die Version des Protokolls
und den Status, dann ebenfalls wieder einige Kopfzeilen und nach einer Leerzeile
die eigentlichen Daten, deren Typ durch die Kopfzeile `Content-Type:` bestimmt
ist.

{line-numbers=off,lang="text"}
    HTTP/1.0 200 OK
    ...
    Content-Type: text/html
    Last-Modified: Wed, 11 Jun 2014 08:49:03 GMT
    Date: Fri, 18 Jul 2014 07:35:36 GMT
    
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    ...

Die möglichen Requests sind in den genannten RFC beschrieben.
Ich verwende für meine Tests meist nur GET und HEAD.

Muss ich einen Proxy-Server für HTTP oder HTTPS verwenden, gehe ich genauso
vor, ich muß lediglich beim URI die volle URL, also mit Protokoll und Host
angeben.

{line-numbers=off,lang="text"}
    $ nc -C localhost 3128
    GET http://www.example.org/ HTTP/1.0
    Host: www.example.org
    

Für verschlüsselte Verbindungen kann ich `openssl s_client` verwenden.

{line-numbers=off,lang="text"}
    $ openssl s_client -connect www.example.com:443 -crlf
    GET / HTTP/1.0
    Host: www.example.com
    

#### IMAP

Das *Internet Message Access Protocol* ist in RFC 3520 beschrieben.
Meist will ich nur prüfen, ob der Server läuft, ob ich mich anmelden kann und
ob der Server auf die Dateien und Verzeichnisse zugreifen kann.
Dazu reicht der folgende kleine Test.

{line-numbers=on,lang="text"}
    $ nc -C imap.example.org 143
    * OK [CAPABILITY ... STARTTLS] Courier-IMAP ...
    a1 login $user $pass
    a1 OK LOGIN Ok.
    a2 list "" INBOX
    * LIST (\Marked \HasChildren) "." "INBOX"
    a2 OK LIST completed
    a3 logout
    * BYE Courier-IMAP server shutting down
    a3 OK LOGOUT completed

Generell stelle ich jedem Befehl einen eindeutigen Bezeichner voran.
Die Antworten des Servers beginnen mit `*` oder mit diesem Bezeichner,
wenn sie sich auf meinen Befehl beziehen.

Im Beispiel habe ich mich mit `$user` und `$pass` angemeldet (Zeile 3),
anschließend eine Liste im aktuellen Kontext (`""`) der Mailbox *INBOX*
abgefragt (Zeile 5) und mich schließlich abgemeldet (Zeile 8).

Für verschlüsselte Verbindung verwende ich wieder `openssl s_client`.
Dieses kann mit Option `-starttls imap` auch das Umschalten von Plaintext
in die verschlüsselte Verbindung übernehmen.

{line-numbers=off,lang="text"}
    $ openssl s_client -connect imap.example.org:143 \
                       -starttls imap -quiet
    depth=0 CN = imap.example.org
    verify error:num=18:self signed certificate
    verify return:1
    depth=0 CN = imap.example.org
    verify return:1
    . OK CAPABILITY completed
    a1 login $user $pass
    a1 OK LOGIN Ok.
    a2 logout
    * BYE Courier-IMAP server shutting down
    a2 OK LOGOUT completed

Mit `wireshark` oder `tcpdump` kann ich mich überzeugen, dass die Verbindung
verschlüsselt ist.

#### POP3

Das *Post Office Protocol - Version 3* ist in RFC 1939 beschrieben.
Es ist noch einfacher zu testen als IMAP.
Ich verwende es meist um neu eingerichtete Postfächer zu kontrollieren, wenn
der Server sowohl IMAP als auch POP3 beherrscht.

{line-numbers=on,lang="text"}
    $ nc pop3.example.org 110
    +OK Dovecot ready.
    user $user
    +OK
    pass $pass
    +OK Logged in.
    list
    +OK 1 messages:
    1 1686
    .
    quit
    +OK Logging out.

Ich melde mich an mit Nutzernamen (Zeile 3) und Kennwort (Zeile 5).
Anschließend lasse ich alle E-Mails im Postfach auflisten (Zeile 7) und melde
mich wieder ab (Zeile 11).

Auch hier kann ich das gleiche wieder verschlüsselt mit `openssl s_client`
erledigen.

#### SMTP

Das aktuelle RFC für das *Simple Mail Transfer Protocol* ist 5321.
Damit kann ich einen Mailserver wie folgt testen.

{line-numbers=on,lang="text"}
    $ nc -C smtp 25
    220 smtp ESMTP Postfix (Debian/GNU)
    helo $myhostname
    250 smtp
    mail from: $sender
    250 2.1.0 Ok
    rcpt to: $recipient
    250 2.1.5 Ok
    data
    354 End data with <CR><LF>.<CR><LF>
    Subject: Test
    
    Nicht mehr als ein Test.
    .
    250 2.0.0 Ok: queued as 82C3D440A5
    quit
    221 2.0.0 Bye

In Zeile 3 gebe ich den Hostnamen des Rechners an, von dem aus ich teste,
In Zeile 5 die Absenderadresse, die im Envelope der E-Mail verwendet wird,
also zwischen den Mailservern.
Bei der E-Mail taucht diese als `Return-Path:` in den Kopfzeilen auf.
In Zeile 7 habe ich den Adressaten angegeben und ab Zeile 11 den eigentlichen
Text der E-Mail. Da die Eingabe mit einen einzelnen `.` in einer Zeile endet,
muss ich so etwas in der E-Mail selbst durch Voranstellen eines weiteren `.`
maskieren.
In Zeile 16 beende ich die Sitzung.

Durch Variieren von `$myhostname`, `$sender` und `$recipient` kann ich
einfache Tests machen, ob der Mailserver als SPAM-Relay missbraucht werden
könnte.

Auch hier kann ich mit `openssl s_client` eine verschlüsselte Verbindung
aufbauen.

Ich kann eine SMTP-Sitzung an beinahe jeder Stelle mit `QUIT` abbrechen.
Will ich nur wissen, ob sich der Server überhaupt meldet und wie schnell, kann
ich es gleich nach der ersten Meldung des Servers eingeben.
Solange ich nicht mit `DATA` die Übertragung der eigentlichen Nachricht
eingeleitet habe, wird der Server nicht mehr als ein paar Logzeilen
generieren.

Alle meine Eingaben quittiert der Server mit einer dreistelligen Zahl und
etwas erläuterndem Text.
Dabei besagt die erste Ziffer, ob die Antwort in Ordnung geht.
Insbesondere sind folgende Codes für die Antwort des Servers im RFC
festgelegt:

2yz
: positive Ausführung, alles in Ordnung soweit

3yz
: Zwischenmeldung zur positiven Ausführung

4yz
: vorübergehender Fehler, der Client kann es später noch einmal versuchen

5yz
: dauerhafte Nichtausführung, der Client braucht die gleiche Anfrage nicht
  noch einmal versuchen.

Die erste Ziffer interessiert mich bei den Tests von Mailservern am
häufigsten.
Die zweite Ziffer sagt etwas über die Kategorie der Antwort vom Server und die
dritte unterteilt die Bedeutung noch weiter.
Falls ich deren Bedeutung wirklich einmal brauche, schlage ich sie im RFC
nach.

Mailserver, die im Internet erreichbar sind, werden heutzutage von Skripts
automatisch getestet, ob sie sich potentiell zur Versendung von SPAM eignen.
Dabei wird eine SMTP-Verbindung von einem fremden Netz aus aufgebaut und
versucht eine E-Mail an eine Adresse zu versenden, für die der Server definitiv
nicht zuständig ist.
Kommt diese E-Mail an, dann wird - je nach dem, wer getestet hat - anschließend
SPAM über diesen Server versendet oder er landet gleich auf einer Blacklist.
Beides erschwert es hinterher, reguläre E-Mail über diesen Server zu
versenden.

X> Die meisten SMTP-Server treffen bereits anhand von IP-Adresse des Senders,
X> Absender- und Zieladresse eine Vorentscheidung, ob sie eine E-Mail annehmen
X> oder nicht.
X> Wenn Du einen Mailserver betreibst, versuche mit `telnet` oder `nc` von
X> verschiedenen IP-Adressen aus, E-Mail mit verschiedenen Absender- und
X> Zieladressen zu versenden.
X> Nach dem `RCPT TO:` kannst Du die SMTP-Sitzung mit `QUIT` beenden.
X>
X> Wie verhält sich der SMTP-Server bei verschiedenen IP-Adressen,
X> verschiedenen Absenderadressen und verschiedenen Zieladressen?


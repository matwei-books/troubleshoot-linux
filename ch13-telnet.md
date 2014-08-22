
## telnet {#sec-netz-werkzeuge-telnet}

Neben `ssh` ist `telnet` für mich ein wichtiges Programm für die Fehlersuche im
Netz. Zum einen verwende ich es für den Zugriff auf ältere Router und
Switches, die das SSH-Protokoll nicht anbieten oder für den Zugriff auf die
interaktive Shell der Quagga-Protokolldämonen. Zum anderen setze ich es für
Tests von Anwendungsprotokollen wie SMTP, POP, IMAP, FTP oder HTTP
ein, die mit Plaintext via TCP arbeiten.

Zwar ist beim Testen der Plaintextprotokolle `netcat` praktischer, aber
gerade auf älteren Rechnern finde ich häufiger `telnet` als `netcat`.

Der Vorteil von `telnet` liegt eindeutig bei den interaktiven Shells, weil
es die Kennworte nicht auf der Konsole ausgibt, so dass sie nicht
durch einfaches Schultersurfen abgeschaut werden können. Außerdem
funktionieren die Cursortasten mit `telnet` besser.

Ein Nachteil von `telnet` gegenüber `netcat` beim Testen der Plaintextprotokolle
ist, dass das Abbrechen einer Verbindung insbesondere mit einer deutschen
Tastatur eher unbequem ist.
Die Escape-Sequenz, mit der ich in den Kommandomodus umschalte, ist hier
ungünstig belegt, so dass ich meist darauf setze, dass die Gegenstelle die
Verbindung abbaut.
Alternativ kann ich beim Aufruf von
`telnet` mit der Option `-e <irgendwas>` ein anderes Zeichen für das
Umschalten in den Kommandomodus mitgeben, muss dann aber ein Zeichen
auswählen, dass im Protokoll nicht vorkommt und trotzdem leicht zu erreichen
ist.


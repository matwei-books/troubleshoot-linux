
## telnet {#sec-netz-werkzeuge-telnet}

Neben SSH ist Telnet ein sehr wichtiges Programm für die Fehlersuche im
Netz. Zum Einen verwende ich es für den Zugriff auf ältere Router und
Switches, die das SSH-Protokoll nicht anbieten oder für den Zugriff auf die
interaktive Shell der Quagga-Protokolldämonen. Zum Anderen setze ich es für
kurze Tests von Anwendungsprotokollen wie SMTP, POP, IMAP, FTP oder HTTP
ein, die mit Plaintext via TCP arbeiten.

Zwar ist beim Testen der Plaintextprotokolle netcat etwas praktischer, aber
gerade auf älteren Rechnern findet man häufiger telnet als netcat.

Der Vorteil von telnet liegt eindeutig bei den interaktiven Shells, weil
hier Kennworte nicht auf der Konsole ausgegeben werden, so dass sie nicht
durch einfaches Schultersurfen abgeschaut werden können. Außerdem
funktionieren die Cursortasten mit telnet besser.

Ein Nachteil von telnet gegenüber netcat beim Testen der Plaintextprotokolle
ist, dass das Abbrechen einer Verbindung insbesondere mit einer deutschen
Tastatur eher unbequem ist, da die Escape-Sequenz um in den Kommandomodus zu
kommen hier ungünstig belegt ist und ich dann meist darauf setze, dass die
Gegenstelle die Verbindung abbaut. Alternativ kann ich beim Aufruf von
telnet mit der Option `-e <irgendwas>` ein anderes Zeichen für das
Umschalten in den Kommandomodus mitgeben, muss dann aber ein Zeichen
auswählen, dass im Protokoll nicht vorkommt und trotzdem leicht zu erreichen
ist.


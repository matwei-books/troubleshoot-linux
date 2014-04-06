
## netcat {#sec-netz-werkzeuge-netcat}

Ein weiteres Werkzeug um schnell eine Netzwerkverbindung herzustellen,
ähnlich wie telnet doch weitaus flexibler, ist netcat. Damit kann ich nicht
nur TCP-, UDP- oder UNIX-Socket-Verbindungen sehr einfach aufbauen, sondern
außerdem ganz schnell mal eben einen Socket-Server für die genannten
Protokolle einrichten.

Netcat ist sehr gut in Skripten einsetzbar und kann auch ein rudimentäres
Port-Scanning für TCP-Ports. Und, was in manchen Umgebungen wichtig sein
kann: netcat kann mit Proxy-Servern umgehen und darüber Verbindungen
herstellen.

### Aufruf

Der grundlegende Aufruf ist

    $ netcat [ optionen ] host port

wenn ich eine Verbindung via TCP oder UDP aufbauen will,

    $ netcat [ optionen ] port

wenn ich auf TCP- oder UDP-Verbindungen warten will, und

    $ netcat [ optionen ] socketpath

wenn ich mit UNIX-Domain-Sockets arbeiten will.

Wenn ich einen Portscan mit Option `-z` starten will, kann ich statt
eines Ports auch einen Bereich (`port1-port2`) angeben.

### Optionen

Einige der wichtigsten Optionen sind:

-k
: In Verbindung mit der Option `-l` wartet netcat auf weitere
  Verbindungen, wenn die erste beendet ist. Ohne diese Option beendet sich
  netcat nach der ersten Verbindung.

-l
: Netcat wartet auf eine ankommende Verbindung anstatt selbst eine
  Verbindung zu öffnen.

-s addr
: Setzt die Absenderadresse auf `addr`. Das ist
  insbesondere nützlich, wenn der Rechner mehrere Adressen hat.

-U
: verwendet UNIX-Domain-Sockets

-u
: verwendet UDP statt TCP

-X proto
: verwendet Proxyprotokoll `proto`. Mögliche Werte sind
  `4` für SOCKS Version 4, `5` für SOCKS Version 5 und
  `connect` für die CONNECT-Methode bei HTTP-Proxies.

-x addr:port
: spezifiziert die Adresse und den Port des Proxieservers.

-z
: weist netcat an, keine Verbindung aufzubauen, sondern nur
  nachzuschauen, ob der Port oder Portbereich offen ist. Diese Option
  kombiniert man sinnvollerweise mit `-v`.

Weitere Optionen finden sich in den Handbuchseiten.

### Beispiele

Die folgenden Beispiele sind der Handbuchseite von netcat entnommen.

#### Client/Server

Für eine einfache Client-Server-Verbindung gebe ich folgendes auf der
Serverseite ein:

    $ netcat -l 1234

Auf der Clientseite dann das folgende:

    $ netcat host.example.net 1234

um mich mit dem Server zu verbinden.

Mit Option `-u` verwende ich UDP statt TCP zur Übertragung.

Mit Option `-U` geht es stattdessen (auf demselben Rechner) über
UNIX-Domain-Sockets. Dann lasse ich auf Clientseite den Rechnernamen weg und
verwende statt der Portnummer den Pfadnamen zur Socketdatei. Diese darf bei
Aufruf der Serverseite noch nicht existieren.

#### Datentransfer

Um schnell mal eine Datei zu übertragen erweitere ich das Client/Server
Beispiel auf Serverseite wie folgt:

    $ netcat -l 1234 > file.out

Und auf Clientseite:

    $ netcat host.example.net 1234 < file.in

Die Verbindung widr nach erfolgter Datenübertragung automatisch geschlossen.
Vertausche ich die spitzen Klammern, wird die Datei vom Server zum Client
übertragen.

#### Einen Server testen

Wenn ich das Plaintextprotokoll des Servers kenne, kann ich mit netcat auch
differenziertere Protokolle bedienen oder testen:

    $ netcat -C mail.example.net 25 <<EOT
    HELO host.example.net
    MAIL FROM:<user@host.example.net>
    RCPT TO:<user2@host.example.net>
    DATA
    Subject: Testmail
    
    Body of email.
    .
    QUIT
    EOT

Damit kann ich eine E-Mail einspeisen, um einen Mailserver zu testen. Das
gleiche könnte ich auch interaktiv (von Hand) eingeben. Oder zum Beispiel an
einem POP3-Server nachsehen, ob eine bestimmte E-Mail angekommen ist.

#### Portscanning

Um festzustellen, welche Ports an einem Rechner erreichbar sind, kann ich
netcat wie folgt aufrufen:

    $ nc -z -v smtp.example.net 22-25
    Connection to smtp.example.net 22 port [tcp/ssh] succeeded!
    nc: connect to smtp.example.net port 23 (tcp) failed: Connection refused
    nc: connect to smtp.example.net port 24 (tcp) failed: Connection refused
    Connection to smtp.example.net 25 port [tcp/smtp] succeeded!


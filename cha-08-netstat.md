
## netstat {#sec-lokal-werkzeuge-netstat}

Netstat ist ein Werkzeug, das sowohl bei der lokalen, als auch bei der
Fehlersuche im Netzwerk behilflich ist.
Auf den Aspekt Netzwerkfehlersuche gehe ich im Abschnitt über 
`netstat` im dritten Teil des Buches näher ein.
Hier konzentriere ich mich auf die Fehlersuche bei lokalen Problemen.

Dafür verwende ich vor allem die Optionen `--protocol=unix`
(alternativ: `-A unix`) oder `--unix` (`-x`) um mir die
UNIX-Sockets ausgeben zu lassen.

Mit `--program` (`-p`) erhalte ich die PID und den Namen des
Prozesses, der den Socket benutzt.
Dafür benötige ich die Privilegien von *root*.
Mit der PID kann ich dann zum Beispiel den Prozess mit `strace` näher
betrachten.

Normalerweise zeigt `netstat` nur aktive, das heißt verbundene Sockets an. Mit
der Option `--listening` (`-l`) kann ich dagegen nur die Sockets
ausgeben lassen, die auf eine Verbindung warten oder mit `--all`
(`-a`) alle.

Mehr Informationen kann ich bekommen, wenn ich zusätzlich die Optionen
`--verbose` (`-v`) oder `--extend` (`-e`) angebe.

Die Ausgabe von netstat kommt als Tabelle, deren Spalten die folgende
Bedeutung haben:

**RefCnt**
: Zeigt die Anzahl der Prozesse, die sich mit dem Socket verbunden haben.

**Flags**
: geben zusätzliche Informationen zum Zustand des Sockets:

  **ACC**
  : - der Socket wartet auf eine Verbindung

  **W**
  : - der Socket wartet auf Daten

  **N**
  : - der Socket hat im Moment nicht genug Platz zum Schreiben

**Typ**
: kann stehen für

  **DGRAM**
  : verbindungslose Sockets

  **STREAM**
  : verbundene Sockets

  **RAW**
  : ungefilterte (Raw-)Sockets

  **RDM**
  : zuverlässig ausgelieferte Nachrichten (Reliable
    Delivered Messages)

**State**
: kann für einen der folgenden Zustände des Sockets stehen:

  **Free**
  : nicht benutzte Sockets

  **Listening**
  : nicht verbundene Sockets

  **Connecting, Connected, Disconnected**
  : die Phasen einer Socketverbindung

  **(empty)**
  : für unverbundene Sockets

**PID**
: enthält die Prozess-ID und den Namen des Prozesses

**Path**
: zeigt den Pfad zum Socket an


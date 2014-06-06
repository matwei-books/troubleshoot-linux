
## netstat {#sec-lokal-werkzeuge-netstat}

Netstat ist ein Werkzeug, das mir sowohl bei der lokalen, als auch bei der
Fehlersuche im Netzwerk hilft.
Auf den Aspekt Netzwerkfehlersuche gehe ich im dritten Teil des Buches
näher ein.
Hier konzentriere ich mich auf die Fehlersuche bei lokalen Problemen.

Dafür verwende ich meist die Optionen `--protocol=unix`
(alternativ: `-A unix`) oder `--unix` (`-x`) um mir die
UNIX-Sockets ausgeben zu lassen.

Mit `--program` (`-p`) erhalte ich die PID und den Namen des
Prozesses, der den Socket benutzt.
Mit der PID kann ich dann zum Beispiel den Prozess mit `strace` oder
`ltrace` näher betrachten.
Für einige Informationen zu Prozessen anderer Benutzer benötige ich die
Privilegien von *root* oder die Capability *CAP_DAC_READ_SEARCH*.
Diese kann ich, wie in [Kapitel 6](#ch06-rechte-posix-cap) beschrieben,
vergeben.

Normalerweise zeigt `netstat` nur aktive, das heißt verbundene Sockets an.
Mit der Option `--listening` (`-l`) kann ich dagegen die Ausgabe auf Sockets
einschränken, die auf eine Verbindung warten, oder mit `--all` (`-a`)
alle ausgeben.

Mehr Informationen bekomme ich, wenn ich zusätzlich die Optionen
`--verbose` (`-v`) oder `--extend` (`-e`) angebe.

Die Ausgabe von netstat kommt als Tabelle, deren Spalten die folgende
Bedeutung haben:

**RefCnt**
: Zeigt die Anzahl der Prozesse, die sich mit dem Socket verbunden haben.

**Flags**
: geben weitere Informationen zum Zustand des Sockets:

  **ACC**
  : der Socket wartet auf eine Verbindung

  **W**
  : der Socket wartet auf Daten

  **N**
  : der Socket hat im Moment nicht genug Platz zum Schreiben

**Typ**
: kann stehen für

  **DGRAM**
  : verbindungslose Sockets

  **STREAM**
  : verbundene Sockets

  **RAW**
  : ungefilterte Sockets

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


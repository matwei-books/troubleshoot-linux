
## lsof {#sec-lokal-werkzeuge-lsof}

Ein Werkzeug, dass in meinem Werkzeugkasten für die lokale Fehlersuche nicht
fehlen darf, ist `lsof`.
Das Programm zeigt Informationen zu Dateien, die
von gerade laufenden Prozessen geöffnet wurden.

Ich habe dieses Programm erfolgreich beim Untersuchen von Mount-Problemen
eingesetzt.
Auch beim Aufspüren und Untersuchen von Sicherheitsproblemen leistet es
wertvolle Dienste.

Außer für Linux gibt es das Programm auch für andere UNIX-Derivate, bei
denen einige Optionen eine andere Bedeutung haben. Aus diesem Grund und weil
ich hier nicht alle Optionen erläutern werde, ist ein Blick in die
Handbuchseite unumgänglich.

Offene Dateien, die `lsof` auflistet, können

*   reguläre Dateien,

*   Verzeichnisse,

*   block- oder zeichenorientierte Spezialdateien,

*   Verweise auf ausführbaren Code,

*   Bibliotheken,

*   UNIX- oder Netzwerksockets sein.

In einigen Aspekten überschneidet sich die Funktionialität von `lsof` mit der
von `netstat`, welches ich an anderer Stelle beschreibe.
Meist entscheide ich je nach vorliegendem Problem, zu welchem
der Programme ich greife.

Es ist möglich, von `lsof` statt einer einmaligen Ausgabe, automatisch in
bestimmten Abständen neue Schnappschüsse der angeforderten Informationen zu
erhalten und die Ausgabe dazu so umzuformen, dass sie von einem Skript
überwacht werden kann.

Rufe ich lsof ohne Optionen und Argumente auf, bekomme ich eine Liste aller
Dateien, die alle laufenden Prozesse im Moment geöffnet haben. Bin ich nur
an wenigen Dateien interessiert, gebe ich diese als Argumente auf der
Kommandozeile an. Bin ich nur an bestimmten Aspekten oder an Dateien
interessiert, die ich nicht genau kenne, so spezifiziere ich das mit Optionen.
  
Selektiere ich mit einer Option eine definierte Menge von
Dateien, dann zeigt `lsof` nur die Dateien, die dieser Selektion genügen.
Gebe ich mehrere Selektoren an, dann werden alle Dateien
angezeigt, die irgendeinem dieser Selektoren entsprechen.
Das heißt, die Menge der angezeigten Dateien entspricht der
ODER-Verknüpfung der einzelnen Selektoren.
Dazu gibt es folgende Ausnahme: wenn ich mit einer Option
bestimmte Dateien deselektiere (zum Beispiel durch vorangestelltes `^`
bei Auswahllisten), dann werden diese Dateien auch nicht angezeigt, wenn sie
durch einen anderen Selektor ausgewählt wären.
Außerdem kann ich die Verknüpfung
der Selektionskriterien mit der Option `-a` von ODER auf UND umstellen.
Gebe ich mehrmals die gleiche Option mit verschiedenen Selektoren an, so
werden diese vor der ODER- beziehungsweise UND-Verknüpfung zu einem Selektor
zusammengefasst.

Wenn ich zum Beispiel nur an allen Internetsockets interessiert bin, die von
Prozessen mit UID xyz geöffnet sind, dann schreibe ich:

{line-numbers=off,lang="text"}
    lsof -a -i -u xyz

### Optionen

Mit Option `-c name` selektiere ich Prozesse, deren Name mit `name`
beginnt. Fängt `name` selbst mit `^` an, dann werden genau diese
Prozesse ignoriert. Beginnt und endet `name` mit einem Schrägstrich
(`/`), dann wird er als regulärer Ausdruck interpretiert.

Mit der Option `+d s` bekomme ich alle geöffneten Dateien direkt im
Verzeichnis `s`. Demgegenüber liefert `+D s` auch die Dateien und
Verzeichnisse in den Unterverzeichnissen von `s`, die von Prozessen
geöffnet sind. Beide Optionen kann ich mit `-x` kombinieren, damit `lsof`
symbolischen Links folgt und Mountpoints überquert, was es ansonsten
nicht machen würde.

Die Option `-d s` erwartet eine Liste von Dateideskriptoren (diese
stehen in der Ausgabe in Spalte FD), die ich einschließen, oder mit `^`
ausschließen kann. Möchte ich zwar das Arbeitsverzeichnis, aber nicht die
Standardeingabe, -ausgabe und -fehlerausgabe von Prozessen wissen, dann
drücke ich das so aus:

{line-numbers=off,lang="text"}
    lsof -d cwd,^0,^1,^2


Mit der Option `-i [m]` bekomme ich Internetsockets und zwar speziell
für TCP oder UDP angezeigt. Optional kann ich diese mit dem Muster `m`
genauer spezifizieren.
Dazu gebe ich `m` in der folgenden Form

{line-numbers=off,lang="text"}
    [46][protocol][@hostname|hostaddr][:service|port]
    
an. Hierbei steht

*4*
: für die Beschränkung auf IPv4

*6*
: für die Beschränkung auf IPv6

*protocol*
: für den Protokollnamen TCP oder UDP

*hostname*
: für einen Internet-Hostnamen oder alternativ

*hostaddr*
: für eine numerische Adresse

*service*
: für einen Servicenamen aus /etc/services oder alternativ

*port*
: für die Portnummer

Demgegenüber kann ich mit `-U` UNIX-Domain-Sockets auswählen.

Die Option `-n` unterdrückt die Umwandlung von Netzadressen in Namen,
`-P` die Umwandlung von Portnummern in Servicenamen und schließlich
`-l` die Umwandlung von UID in Benutzernamen. Diese Optionen verwende
ich, wenn ich mehr Klarheit haben will, oder wenn diese Umwandlung
ihrerseits die Ausführung von lsof verzögert, weil DNS- oder NIS-Anfragen
für die Auflösung notwendig sind.

Mit der Option `-u s` lassen sich die Prozesse nach UID oder
Benutzernamen auswählen, während ich mit `-p s` die Prozesse direkt
nach PID auswählen kann.

Starte ich lsof mit Option `-r [t]`, so liefert es die Informationen
wiederholt in dem mit `t` spezifizierten Zeitabstand (ohne Angabe 15
Sekunden). Diese Option kann ich mit `-F f` kombinieren um die Ausgabe
für die einfachere Verarbeitung in einem Skript zu modifizieren.


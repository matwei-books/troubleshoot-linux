
## Ein Dienst startet nicht

Der Rechner fährt hoch, ich kann mich anmelden, auf den ersten
Blick scheint alles in Ordnung.
Bis mich Nagios oder ein Kunde darauf aufmerksam macht, dass
mindestens ein Dienst nicht funktioniert.

Also noch einmal anmelden und den Dienst von Hand starten.
Wie das genau geht, hängt vom `init` Dämon ab,
darauf bin ich im vorigen Abschnitt eingegangen.

A> Es gab eine Zeit in der es unter Administratoren als
A> verdienstvoll galt, eine hohe Systemlaufzeit zu erreichen.
A> Laufzeiten von **x** mal hundert Betriebstagen waren keine Seltenheit.
A> Ich gebe zu, das ich mich daran beteiligt habe.
A> Für Einzelsysteme, die ständig benötigte Dienste anbieten, halte ich das
A> noch heute für sinnvoll.
A> 
A> Die Gewichte verschieben sich jedoch, sobald ich eine größere Anzahl
A> von Systemen betreuen muss, und genügend Redundanz im Netz vorhanden ist,
A> dass es auf das einzelne System nicht mehr so sehr ankommt.
A> Dann ist wichtiger, dass das System schnell startet und vor allem
A> vollständig, das heißt, mit allen definierten Diensten.
A> Aus diesem Grund habe ich mir angewöhnt, Server häufiger zu starten
A> und anschließend zu kontrollieren, ob alle Dienste verfügbar sind.
A> 
A> Bei dieser Gelegenheit kann ich auch sehen, welchen Einfluss der Ausfall
A> dieses Servers auf das Gesamtsystem hat.

### Dienst läßt sich von Hand starten

Funktioniert der Dienst jetzt, ist zunächst alles in Ordnung, die Kunden
können arbeiten.
Es bleibt jedoch die Ungewissheit, warum der Dienst nicht automatisch
startete.

Wenn ich keinen offensichtlichen Grund finde, warum ein Dienst nicht lief,
also keine Hinweise in den Logs finde und auch niemand den Dienst
abgeschaltet hatte, muss ich den Startvorgang des Dienstes beim
Systemstart untersuchen.

Lässt sich der Dienst problemlos von Hand starten, kommen folgende Gründe
in Frage:

*   ein anderer benötigter Dienst war noch nicht gestartet;

*   eine benötigte Ressource war belegt;

*   Suchpfade für ausführbare Programme stimmen nicht;

*   es gab ein Rechteproblem.

Bei einem Problem mit einem fehlenden anderen Dienst experimentiere ich mit
der Reihenfolge.

Als erstes schalte ich die Protokollierung des Bootvorgangs ein.
Bei Systemen, die auf Debian basieren und SysVInit verwenden kann ich
dafür in der Datei */etc/default/rcS* die Variable `VERBOSE=yes` setzen.

Oft kann ich dann an Hand der Reihenfolge, in der die Dienste starten,
schon sehen, was nicht in Ordnung ist.
Wie ich die Reihenfolge anpasse, steht bei der Beschreibung der `init`
Programme.

Rechteprobleme bei Startskripten sind eher selten, da `init` diese mit
`UID=0` startet, genauso, wie ich sie von Hand aufrufe.
Denkbar sind Probleme mit Mandatory Access Control Systemen, wie SELinux,
wenn die Skripts in unterschiedlichem Kontext laufen, je nachdem, ob ich
sie von Hand starte oder `init` sie startet.

Manchmal startet ein Dienst nicht, weil eine benötigte Ressource belegt ist.
Das kann ein TCP- oder UDP-Socket an einem bestimmten Port sein, der von
einem anderen Prozess belegt ist oder eine Geräteschnittstelle, die von
einem anderen Programm benutzt wird und über eine Datei in */var/lock/*
gesperrt wird.
Wenn ich Glück habe, finde ich einen Hinweis darauf in den
Systemprotokollen.
Andernfalls kann ich das mit `strace` entdecken.

A> Bei Debian gibt es in einigen Versionen ein Problem, wenn *ntp* (der
A> Zeit-Dämon) und *ntpdate* (das Programm zum Setzen der Systemzeit)
A> zusammen installiert sind.
A> Dann kann es vorkommen, dass `ntpd` nach dem Systemstart nicht läuft, sich
A> aber problemlos von Hand starten lässt.
A> In den Logs findet sich beim Rechnerstart eine Notiz, dass `ntpd` nicht
A> startet, weil er keinen UDP-Socket für Port 123 bekommen kann.
A> Diesen Socket verwendet in diesem Moment gerade `ntpdate` um die
A> Systemzeit zu setzen.
A> 
A> In diesem Fall habe ich die Möglichkeit, `ntpdate` zu entfernen.
A> Wenn der Rechner eine batteriegestützte Uhr hat, ist das sinnvoll.
A> 
A> Alternativ lasse ich `ntpdate` mit der Option `-u` starten, so dass er
A> einen unprivilegierten Port nimmt und Port 123 für `ntpd` verfügbar
A> bleibt.

### Dienst läßt sich nicht von Hand starten

Startet ein Dienst auch nicht, wenn ich ihn von Hand starte, dann schaue ich
als erstes in die Systemprotokolle.
Gegenüber dem Systemstart muss ich viel weniger Zeilen auswerten,
um die gesuchten zu finden.
Ich kann den Startzeitpunkt selbst festlegen und muss nur einen
begrenzten Zeitabschnitt untersuchen.

Finde ich trotzdem nichts, so greife ich auf die Shell und auf `strace`
als Werkzeuge zurück.

Die Shell, mit der Option `-x` gestartet, zeigt jeden aufgerufenen Befehl, 
und jede gesetzte Variable an.
In den meisten Fällen sehe ich dann schon, was den Fehler verursacht.

Reicht auch das nicht und ich weiß nur, welches Binärprogramm nicht
richtig arbeitet, aber nicht warum, dann setze ich `strace` ein.
Damit finde ich auch in schwierigen Fällen oft die Ursache eines Problems.
In vielen Fällen ist es eine Datei, die sich nicht am erwarteten
Platz befindet oder ein Problem mit Zugriffsrechten.

Statt `strace` kann ich `ltrace` verwenden, das außer Systemaufrufen
auch Bibliotheksaufrufe protokolliert und somit den Prozess noch
detaillierter beobachtet.
Dafür muss ich dann mehr Protokollzeilen auswerten, was
das Finden der relevanten Zeilen nicht einfacher macht.


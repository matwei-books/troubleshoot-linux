{frontmatter}

# Vorwort {#vorwort}

Johannes Loxen sagte in seiner Keynote zum Frühjahrsfachgespräch 2012 der GUUG
über den Unterschied von Closed-Source und Open-Source Software:

> "Wenn es nicht funktioniert, hörst Du bei Closed-Source auf zu denken und
> rufst den Hersteller-Support an. Bei Open-Source fängt das Denken dann erst
> richtig an".

Dieses Buch ist für alle, die nicht nur intensiv sondern vor allem auch
strukturiert nachdenken wollen.

Ich habe bereits viel Zeit mit Fehlersuche verbracht.
Schon als Kind beim Basteln, wenn etwas nicht funktionierte.
Dann in meinem ersten Beruf, bei der Reparatur von Telefonen und
Telefonanlagen, die damals noch mit Relais funktionierten, so dass ich ihnen
im wahrsten Sinne des Wortes bei der Arbeit zusehen konnte.
Nach dem Studium, als Softwareentwickler, beim Debuggen meiner oder fremder
Programme.
Später dann als Systemadministrator für UNIX und Netzwerke.

Dabei war ich vor allem auf drei Dinge angewiesen um zum Erfolg zu kommen.
Das erste und wichtigste ist ein grundlegendes Verständnis der
Materie und die Fähigkeit und Möglichkeit, weitere nötige Kenntnisse zu
erwerben.
  
Das zweite ist eine einigermaßen strukturierte Vorgehensweise, die
mich in den meisten Fällen schneller zum Ziel führt als andere
Vorgehensweisen.

Die dritte Voraussetzung ist die eigene Einstellung zum Problem.
Ich musste sehr oft und werde vermutlich noch oft die Erfahrung machen, dass
ich mir selbst bei der Lösung eines Problems im Weg stehe:

*   Sei es, dass ich mir bereits vor Kenntnis aller relevanten Tatsachen
    eine, eventuell falsche, Meinung bilde.
*   Sei es, dass ich durch Druck von außen oder selbst erzeugten Druck
    besonders schnell sein will und dann beim oberflächlichen Hinsehen
    wichtige Details übersehe.
*   Sei es, dass ich angebotene Hilfe nicht annehme, weil ich es selbst
    schaffen will oder so sehr im Problem gefangen bin, dass ich das
    Hilfsangebot nicht wahrnehme.
*   Sei es, dass ich kurz vor dem Ziel aufgebe und einfach nicht den
    letzten Meter gehe.

Allein diese Hindernisse zu überwinden ist eine Aufgabe für ein ganzes Leben.

In diesem Buch bereite ich meine in mehr als zwanzig Jahren gesammelten
Erfahrungen mit der Fehlersuche bei Linux-Servern und in IP-Netzwerken auf.

Ich habe diese beiden Themen kombiniert, weil einerseits Linux-Server fast
immer über IP-Netzwerke angesprochen werden und daher auf ein gut
funktionierendes Netzwerk angewiesen sind, andererseits Linux-Rechner
für mich ideal zur Analyse von Problemen im Netzwerk geeignet sind.

Zwar benutze ich fast täglich Linux auf dem Desktop, allerdings verwende ich
auch hier am häufigsten Terminal und Webbrowser, die in den meisten Fällen
vorzüglich funktionieren, so dass ich kaum Gelegenheit hatte, Erfahrungen bei
der Fehlersuche am Linux-Desktop zu sammeln.
Aus diesem Grund lasse ich diesen Bereich außen vor.

Das gleiche gilt für IPv6 und WLAN, die ich zwar privat einsetze, aber
noch nicht im beruflichen Umfeld, so dass meine Erfahrungen damit nicht
ausreichen für eine fundierte und strukturierte Darstellung.

In der Keynote von Johannes Loxen ging es so weiter:

> "Manchmal wünscht man sich von den Closed-Source-Admins, dass Sie
> versuchen, weiter zu denken, indem sie sich der typischen Mittel der
> Open-Source-Welt bedienen, also Netzwerk-Sniffer oder Debuggern.
> Allerdings wünscht man sich auch umgekehrt manchmal, dass
> Open-Source-Admins nicht weiter denken - vor allem, wenn dies Zeit und
> Geld verbrennt und die entstehenden Kosten in keinem Verhältnis zum Wert
> des Problems stehen".

Hier gilt es eine Balance zu finden.
Bei Problemen, die weit über meinen Horizont gehen, habe ich kein Problem
damit, mir sofort Hilfe zu suchen.
Einfache Probleme sind in der Regel im Nu geklärt.
Anders ist es bei Problemen, die nur wenig schwieriger sind, als mein
bisheriger Kenntnisstand.
Das sind die Probleme, die am meisten Spaß machen, bei denen ich den
Flow-Zustand erreiche, viel dabei lerne, besser werde und die Zeit vergesse.
Ich nutze in diesem Fall gern Timeboxing, stelle einen Kurzzeitwecker auf eine
knappe halbe Stunde und nutze die Unterbrechung, um ein wenig Bewegung zu
bekommen und mich zu überzeugen, dass ich noch auf dem richtigen Weg bin.

## Für wen ist dieses Buch

Die Zielgruppe sind angehende und gestandene Systemadministratoren für
Linux und/oder IP-Netzwerke.

Ich setze grundlegende Kenntnisse der Kommandozeile voraus und dass der Leser
weiß, wie er sie erreicht.
Zum Teil setze ich für die Analyse von Problemen spezielle Software ein, die
nicht auf jedem System installiert ist.
Ich gehe davon aus, dass der Leser weiß, wie er Software auf seinem Rechner
installiert.

Dieses Buch soll Anfängern in der Systemadministration über die ersten Hürden
bei der Fehlersuche helfen und sie bei ihren ersten Schritten begleiten.
Gestandene Administratoren werden vielleicht die eine oder andere Anregung
entnehmen können.

## Wie ist das Buch aufgebaut

Dieses Buch ist besteht aus drei Hauptteilen.

**Teil eins** beschäftigt sich mit allgemeinen Themen der Fehlersuche, die
auch in anderen Bereichen nützlich sein können.

Im ersten Kapitel geht es um Methoden, Heuristiken und Modelle, also um
strukturelle Hilfsmittel, die mir bei bestimmten Problemen der Fehlersuche
weiterhelfen.

Im zweiten Kapitel geht es um die Herangehensweise an ein Problem.
Wann und wie setze ich die Hilfsmittel aus dem vorigen Kapitel ein?
Wie bereite ich mich auf die Fehlersuche vor?
Wie kann ich generell besser bei der Fehlersuche werden?

Das dritte Kapitel geht auf die Nachbearbeitung eines Problems ein, die
immer auch eine Vorbereitung auf das nächste Problem ist.
Welche Erkenntnisse kann ich aus der letzten Fehlersuche ziehen?
Kann ich diesen oder ähnliche Fehler in Zukunft vermeiden?

Die beiden folgenden Teile des Buches sind ähnlich strukturiert.
Zuerst führe ich in Grundlagen ein, die als Hintergrundwissen für die
folgenden Kapitel benötigt werden.
Als nächstes widme ich mich dem Totalausfall, dann Teilausfällen und was ich
darunter verstehe und schließlich Problemen mit der Performance.
Am Schluß der Teile zwei und drei stelle ich jeweils einige Programme vor,
die ich bei der Fehlersuche häufig einsetze.

**Teil zwei** beschäftigt sich mit lokalen Problemen einzelner Linux-Server.

Das erste Kapitel dieses Teiles stellt Grundlagenwissen für die lokale
Fehlersuche auf Linux-Systemen vor.

Im nächsten Kapitel geht es um Totalausfälle.
Das können Hardwarefehler sein, Bootprobleme, ein Rechner der scheinbar oder
wirklich nicht mehr reagiert oder ein Rechner, der durch Überlast so langsam
geworden ist, dass ich nicht einmal mehr eine Shell zur Diagnose bekommen kann.

Das folgende Kapitel behandelt Teilausfälle bei Linux-Servern.
Diese äußern sich meistens darin, dass Dienste nicht starten oder
nicht korrekt arbeiten, oder dass Dateien nicht gespeichert werden können.

Im anschließenden Kapitel geht es um die Performance von Linux-Servern.
Alles funktioniert, aber richtig schnell ist es nicht.
Hier geht es darum, herauszufinden, was der Rechner macht, wenn es so lange
dauert und wie man das beschleunigen kann.

Das letzte Kapitel des zweiten Teils schließlich stellt Werkzeuge
vor, die ich häufig einsetze.
Zusätzlich zu den wichtigsten Optionen zeige ich einige Anwendungsfälle
oder verweise auf Kapitel, in denen das Programm verwendet wird.

Der **dritte Teil** des Buches behandelt die Fehlersuche im IP-Netzwerk.

Das erste Kapitel dieses Teiles geht auf Totalausfälle im Netz ein.
Ein Totalausfall im Netzwerk ist für mich gegeben, wenn ein Rechner überhaupt
keinen Kontakt zum Netzwerk bekommt oder, wenn in einem Netzsegment die
Basisdienste so weit ausgefallen sind, dass die Rechner
ihren Netzanschluß nicht produktiv nutzen können.

Im nächsten Kapitel gehe ich auf Teilausfälle im Netzwerk ein.
Dabei unterscheide ich, ob ganze Netzsegmente nicht erreichbar sind oder
nur einzelne Dienste.

Danach geht es um Performance-Probleme im Netzwerk.
Wie analysiere ich diese?
Welche möglichen Abhilfen gibt es?

Und im letzten Kapitel stelle ich wiederum Werkzeuge vor, die mir bei der
Fehlersuche im Netz helfen.

### Übungen

Ich habe mir in diesem Buch große Mühe gegeben, eine Hilfe bei der Fehlersuche
zu bieten.
Dennoch kann es keine eigene Erfahrungen ersetzen.
Insbesondere, wenn man vor einem schwierigen neuen Problem steht, ist es
hilfreich, wenn die aus diesem Buch gewonnenen Erkenntnisse und die eigenen
Erfahrungen abrufbereit sind.
Aus diesem Grund habe ich einige Übungen im Buch eingestreut.
Bei diesen kommt es nicht immer auf das konkrete Ergebnis an, sondern
dass man sie in einer freien Minute ausführt und beobachtet, was passiert.

X> Übungen sind mit diesem Symbol gekennzeichnet.

### Zur Schreibweise

Für Programmbeispiele und Eingaben auf der Kommandozeile verwende ich eine
`dicktengleiche Schrift`, diese nehme ich auch im Fließtext, wenn ich Optionen
oder Befehle wortgetreu verwende.
Bei Kommandozeilen stehen Begriffe, die mit `$` eingeleitet werden, wie zum
Beispiel `$gateway`, für variable Angaben, die je nach Kontext ersetzt werden
müssen.

Ansonsten verwende ich einen *kursiven Font* für Hervorhebungen.

## Danksagung

Ohne die vielen Autoren der freien Software, die ich in meiner täglichen Arbeit
nutze, wäre dieses Buch nicht möglich gewesen. Ich würde meine Arbeit auch
nicht so ausüben können, wie ich es heute tue.

Auch der Gemeinschaft, die das Internet möglich gemacht hat und die es täglich
aufs Neue mit Ideen, Anregungen und Problemlösungen füllt, die es nur zur
rechten Zeit zu finden gilt, hätte ich viele der hier vorgestellten Kenntnisse
selbst nicht erwerben können.

Mein besonderer Dank gebührt Denise Betzendörfer und Stefan Naumann, die mir
etliche Hinweise zu diesem Buch gaben und mich auf Dinge aufmerksam machten,
die ich im Laufe der langen Beschäftigung mit dem Text gar nicht mehr
wahrgenommen hatte.
Auch Knut Schmädt, hat sich die Mühe gemacht, eine frühe
Version dieses Buches zu lesen und gab mir Feedback dazu.

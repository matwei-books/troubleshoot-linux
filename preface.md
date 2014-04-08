{frontmatter}

# Vorwort {#vorwort}

Ich habe bereits viele Jahre mit Fehlersuche verbracht.
Sei es als Kind beim Basteln, wenn etwas nicht so funktionierte, wie ich
dachte.
In meinem ersten Beruf bei der Reparatur von Telefonen und
Telefonanlagen, die damals noch mit Relais funktionierten, so dass man ihnen
im wahrsten Sinne des Wortes bei der Arbeit zusehen konnte.
Nach dem Studium, als Softwareentwickler, beim Debuggen meiner oder fremder
Programme.
Oder später dann als Systemadministrator für UNIX und Netzwerke.

Dabei war ich vor allem auf drei Dinge angewiesen um zum Erfolg zu kommen.
Das erste und wichtigste ist ein zumindest grundlegendes Verständnis der
Materie und die Fähigkeit und Möglichkeit, weitere nötige Kenntnisse zu
erwerben.
  
Das zweite ist eine einigermaßen strukturierte Vorgehensweise, die
mich zumindest in den meisten Fällen schneller zum Ziel führt als andere
Vorgehensweisen.

Die dritte Voraussetzung ist die entsprechende geistige Einstellung.
Ich musste sehr oft und werde vermutlich noch oft die Erfahrung machen, dass
ich mir selbst bei der Lösung eines Problems im Weg stehe:

*   Sei es, dass ich mir vor der Kenntnis aller relevanten Tatsachen
    bereits eine (dann eventuell falsche) Meinung bilde.
*   Sei es, dass ich durch Druck von außen oder selbst erzeugten Druck
    besonders schnell sein will und dann beim oberflächlichen Hinsehen
    wichtige Details übersehe.
*   Sei es, dass ich angebotene Hilfe nicht annehme, weil ich es selbst
    schaffen will oder so sehr im Problem gefangen bin, dass ich das
    Hilfsangebot nicht wahrnehme.
*   Sei es, dass ich kurz vor dem Ziel aufgebe und einfach nicht den
    letzten Meter gehe.

In diesem Buch lege ich meine über die Jahre gesammelten Erfahrungen mit
der Fehlersuche bei Linux-Servern und in IP-Netzwerken nieder.

Ich habe diese beiden Themen kombiniert, weil zum einen Linux-Server fast
immer über IP-Netzwerke angesprochen werden und daher auf ein gut
funktionierendes Netzwerk angewiesen sind und zum anderen Linux-Rechner
(da gehen auch Arbeitsstationen) für mich ideal zur Analyse von
Netzwerkproblemen geeignet sind.

Zwar benutze ich fast täglich Linux auf dem Desktop, allerdings verwende ich
hier am häufigsten ein Terminal und einen Webbrowser, die
in den meisten Fällen vorzüglich funktionieren, so dass ich kaum Gelegenheit
habe Erfahrungen mit der Fehlersuche am Linux-Desktop zu sammeln.
Aus diesem Grund lasse ich diesen Bereich aussen vor.

## Für wen ist dieses Buch

Die Zielgruppe sind angehende und gestandene Systemadministratoren für
Linux und/oder IP-Netzwerke.

Ich setze grundlegende Kenntnisse der Kommandozeile voraus und dass der Leser
weiss, wie er sie erreicht.

Dieses Buch soll Anfängern über die ersten Hürden bei der Fehlersuche helfen
und sie bei ihren ersten Schritten begleiten.
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
Wann und wie setze ich die Hilfmittel aus dem vorigen Kapitel ein?
Wie bereite ich mich auf die Fehlersuche vor?
Wie kann ich generell besser bei der Fehlersuche werden?

Das dritte Kapitel geht auf die Nachbearbeitung eines Problems ein, die
immer auch eine Vorbereitung auf das nächste Problem ist.
Welche Erkenntnisse kann ich aus der letzen Fehlersuche ziehen?
Kann ich diesen oder ähnliche Fehler in Zukunft vermeiden?

Die beiden folgenden Teile des Buches sind ähnlich strukturiert.
Zunächst führe ich in einige Grundlagen ein, die als Hintergrundwissen für die
folgenden Kapitel benötigt werden.
Als nächstes widme ich mich dem Totalausfall (wenn gar nichts mehr geht),
dann Teilausfällen und was ich darunter verstehe und schließlich Problemen mit
der Performance.
Am Schluß der beiden Teile stelle ich jeweils einige Programme vor, die ich
bei der Fehlersuche häufig einsetze.

**Teil zwei** beschäftigt sich mit lokalen Problemen einzelner Linux-Server.

Das erste Kapitel dieses Teiles stellt als Grundlagenwissen für die lokale
Fehlersuche auf Linux-Systemen vor.

In nächsten Kapitel geht es um Totalausfälle.
Das können Hardwarefehler sein, Bootprobleme, ein Rechner der scheinbar oder
wirklich nicht mehr reagiert oder ein Rechner, der durch Überlast so langsam
geworden ist, dass ich nicht einmal mehr eine Shell zur Diagnose bekommen kann.

Das folgende Kapitel behandelt Teilausfälle bei Linux-Servern.
Diese äußern sich meitens darin, dass bestimmte Dienste nicht starten oder
nicht korrekt arbeiten, oder dass Dateien nicht gespeichert werden können.

Im anschließenden Kapitel geht es um die Performance von Linux-Servern.
Alles funktioniert, aber so richtig schnell ist es nicht.
Hier geht es darum, herauszufinden, was der Rechner macht, wenn es so lange
dauert und wie man es eventuell beschleunigen kann.

Das letzte Kapitel des zweiten Teils schließlich stellt einige der Werkzeuge
vor, die ich am häufigsten einsetze.
Zusätzlich zu den wichtigsten Optionen zeige ich einige Anwendungsfälle auf
oder verweise auf Kapitel, in denen das Programm eingesetzt wird.

Der **dritte Teil** des Buches behandelt die Fehlersuche im IP-Netzwerk.

Das erste Kapitel dieses Teiles geht auf Totalausfälle im Netz ein.
Ein Totalausfall im Netzwerk ist für mich gegeben, wenn ein Rechner überhaupt
keinen Kontakt zum Netzwerk bekommt oder, wenn in einem Netzsegment die
Basisdienste so weit ausgefallen sind, dass die Rechner in diesem Segment
ihren Netzanschluß nicht produktiv nutzen können.

Im nächsten Kapitel gehe ich auf Teilausfälle im Netzwerk ein.
Dabei unterscheide ich die Nichterreichbarkeit einzelner Netzsegmente von der
Nichterreichbarkeit einzelner Dienste.

Das darauf folgende Kapitel behandelt Performance-Probleme im Netzwerk.
Wie analysiere ich diese?
Welche möglichen Abhilfen gibt es?

Und im letzten Kapitel stelle ich wiederum Werkzeuge vor, die mir bei der
Fehlersuche im Netz helfen.

Ich habe mir in diesem Buch große Mühe gegeben, eine Hilfe bei der Fehlersuche
zu bieten.
Dennoch kann es keine eigene Erfahrung ersetzen.
Insbesondere, wenn man vor einem schwierigen neuen Problem steht, ist es
hilfreich, wenn die aus diesem Buch gewonnenen Erkenntnisse und die eigenen
Erfahrungen abrufbereit sind.
Aus diesem Grund habe ich einige Übungen im Buch eingestreut.
Bei diesen Übungen kommt es nicht immer auf das konkrete Ergebnis an, sondern
dass man diese in einer freien Minute ausführt und beobachtet, was passiert.

### Zur Schreibweise

Für Programmbeispiele und Eingaben auf der Kommandozeile verwende ich eine
`dicktengleiche Schrift`, diese nehme ich auch im Fließtext, wenn ich Optionen
oder Befehle wortgetreu verwende.
Bei Kommandozeilen stehen Begriffe, die mit `$` eingeleitet werden, wie zum
Beispiel `$gateway`, für variable Angaben, die je nach Kontext ersetzt werden
müssen.

Ansonsten verwende ich einen *kursiven Font* für Hervorhebungen.

X> Übungen sind mit diesem Symbol gekennzeichnet.

## Danksagung

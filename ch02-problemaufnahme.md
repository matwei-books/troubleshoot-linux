
## Problemaufnahme {#sec-02-problemaufnahme}

Bei der Aufnahme eines Problems entscheide ich oft schon, wie ich damit
umgehen werde.
Um ein Problem zu lösen, muss ich es zuallererst verstehen.
Dabei hilft mir der Entscheidungsbaum, an der
richtigen Stelle die richtigen Fragen zu stellen:

*   Besteht das Problem genau jetzt, unter bestimmten Bedingungen oder nur
    sporadisch?

*   Funktioniert überhaupt noch etwas, wenn es auftritt?

*   Funktioniert das gleiche bei anderen noch, wenn es hier nicht mehr geht?

Diese und ähnliche Fragen stelle ich, wenn mir ein Kunde einen Ausfall
meldet.

Performanceprobleme werden subjektiv oft verschieden wahrgenommen, bei diesen
frage ich leicht modifiziert:

*   Wie kommen Sie darauf, dass da ein Performanceproblem vorliegt?

*   Hat dieses System früher performant funktioniert?

*   Was hat sich in der letzten Zeit geändert?

*   Kann die Performanceverschlechterung in Form von Latenz oder Laufzeiten
    ausgedrückt werden?[^latenzlaufzeit]

*   Betrifft das Problem auch andere Leute oder andere Anwendungen?

[^latenzlaufzeit]: Die Begriffe Latenz und Laufzeit werden die meisten Kunden
    vermutlich verwirren. Stattdessen kann ich fragen, wie schnell das System
    auf Tastatureingaben reagiert oder wie lange eine Datenübertragung dauert
    und wie groß die Datei ist.

Die nachfolgenden Fragen muss ich meist allein beantworten.

*   Wie sieht die Umgebung aus? Was muss alles zusammen spielen?

*   Welche Software und Hardware wird verwendet? Welche Versionen? Welche
    Konfiguration?

*   Wie schnell soll es laut SLA sein?

*   Wie kriege ich das alles heraus?

Manche Probleme lassen sich bereits bei der Problemaufnahme lösen, weil das
Stellen der richtigen Fragen mitunter direkt zur passenden Antwort und damit
zur Lösung des Problems führt.
In allen anderen Fällen hilft eine umfangreiche Problemaufnahme, dass wichtige
Details bei der Lösungssuche nicht übersehen werden.

Wenn ich ein Problem selbst feststelle, kann ich die Fragen in meinem
Rhythmus beantworten, mit der nötigen Sorgfalt.

Problematisch kann es werden, wenn andere ihr Problem an mich herantragen.
Sei es ein Kunde, der mich anruft, weil ich gerade Telefondienst habe.
Sei es ein Kollege, der mal eben sein Problem herüber trägt, oder der Chef,
der irgendetwas schnell erledigt haben will.
Diese Arten von Problemaufnahmen haben eins gemeinsam: da ist jemand, der
seine ganz eigene Vorstellung von der Wichtigkeit, Dringlichkeit und mitunter
auch von der Lösung des Problems hat.
Die kann richtig sein oder falsch.

Schwierig wird es, wenn ich mich auf eine falsche Fährte
schicken lasse oder wenn ich nicht mehr klar denken kann, durch den
im Gespräch aufgebauten Druck.

Hier helfen mir vier Kraftprinzipien, die ich aus der Kampfkunst
kenne und für Problemlösungen einsetze, um den Kopf frei zu bekommen.
Diese lauten:

*  Mach dich frei von deiner eigenen Kraft.

*  Mach dich frei von der Kraft deines Gegners.

*  Nutze die Kraft des Gegners.

*  Füge deine eigene Kraft hinzu.

Nun ist das hier kein Buch über Kampfkunst, und ich bin auch nicht berufen
über dieses Thema zu schreiben.
Was mache ich also mit diesen Prinzipien?
Wie setze ich sie ein?

Der Schlüssel liegt darin, das Wort *Kraft* durch *Gedanken*, *Ideen* oder
*Vorurteile* zu ersetzen.

Wie mache ich mich frei von meinen eigenen Vorurteilen?
Dazu ein Beispiel.
Ich bin auf Arbeit oft einer der letzten, der geht, weil ich dann
noch die eine oder andere Änderung vornehmen kann, ohne damit rechnen zu
müssen, unterbrochen zu werden oder jemand zu beeinträchtigen.
Am Ende kontrolliere ich, ob alles funktioniert, und mache Feierabend.
An einem Morgen komme ich zur Arbeit und werde vom Kollegen am
Telefondienst, einem Administrator wie ich,
mit leicht hektischer und etwas vorwurfsvoller Stimme empfangen:

> "Im Rathaus geht das INTERNET nicht!"

Mehr sagt er dazu nicht, allein Stimme und Tonfall sollen mir klar machen,
dass es wichtig und dringend ist.

Natürlich weiß ich noch, was ich am Vorabend gemacht habe, aber das tut
nichts zur Sache, ich will erst herauskriegen, was nicht funktioniert.
Ich mache mich frei von meinen Gedanken an den vorigen Tag,
konzentriere mich auf das Problem von heute und antworte in neutralem Ton:

> "Das ist aber schade."

Je nach dem, wer gerade da ist, höre ich dann oft:

> "Das wusste ich, dass er das jetzt sagt."

Ich habe mich von den Gedanken meines Kollegen und von dem Druck, den er
bewusst oder unbewusst aufbauen wollte, befreit und ihm den Wind aus den
Segeln genommen.

Es gibt auch andere Wege, den aufgebauten Druck abzuleiten.
Zum Beispiel, in dem ich sage, dass ich mich gleich darum kümmere, wenn
ich an meinem Platz bin.
Das ist in vielen Fällen auch der beste Weg, wenn derjenige
nicht in der Lage ist, sich selbst zu helfen.
Aber in diesem Fall handelte es sich um einen Administrator, der nicht
einmal die einfachsten Fragen gestellt hatte, um das Problem einzugrenzen.
Dann einfach zu sagen, *ich kümmere mich drum*, hätte solches Verhalten nur
zementiert, mit dem Effekt, dass selbst simpelste Sachen unreflektiert an
Level 2 Support weitergereicht werden.

A> Bei uns ist es üblich, dass reihum alle Mitarbeiter ein paar Stunden
A> Telefonsupport machen und damit die Probleme der Kunden direkt mitbekommen.
A> Das halte ich für eine gute Idee, weil es den Horizont erweitert für die
A> Probleme der Kollegen.
A> Außerdem ist es ein Qualitätstest für die Dokumentation der
A> "Routineaufgaben", die für den nächsten Kollegen ganz und gar keine
A> Routine sind.
A> 
A> Beim Telefondienst sind alle gehalten, möglichst nicht mehr als 5 Minuten
A> mit einem Anruf zu verbringen und dann das Problem zu eskalieren, wenn es
A> noch nicht gelöst ist.
A> In 5 Minuten kann man nicht sehr viel herausbekommen, wenn man nicht mit
A> dem Problemkreis vertraut ist, aber etwas schon.
A> 
A> Wenn an einer Hotline nur Kundenmeldungen unreflektiert weiter gereicht
A> werden, dann verzögert sie nur die Hilfe für die Kunden und stapelt die
A> Arbeit für die, die sie erledigen.
A> Das mag kurzzeitig angehen, wenn der aufnehmende Kollege überhaupt keine
A> Ahnung von der Materie hat.
A> Langfristig ist es sinnvoll, den Mitarbeiter für die Hotline zu schulen
A> und gegebenenfalls die Dokumentation der Routineaufgaben zu überarbeiten.

Nachdem ich den Druck abgebaut hatte, konnte ich mich daran machen,
die Gedanken meines Kollegen, also das, was er über das Problem wusste,
zu nutzen.
Anhand des Entscheidungsbaumes fragte ich als nächstes, ob alle Webserver
nicht erreichbar sind oder nur externe oder gar nur bestimmte, und
was sie alles ausprobiert hätten.

An diesem Tag musste ich keine eigenen Gedanken mehr hinzufügen, weil noch
während der ersten Fragen klar wurde, dass nur einzelne Webserver im
Internet betroffen waren und das Problem nicht durch uns gelöst werden
konnte.
Der Kollege am Telefondienst wäre in diesem Fall gut beraten gewesen,
selbst fundiert zurückzufragen.



## Statistische Verfahren, Korrelation {#sec-heuristik-korrelation}

Statistische Verfahren liefern keine Belege für Ursache-Wirkung-Beziehungen.
Sie können mir nur helfen, Ansatzpunkte für Hypothesen zu finden, die ich
mit gezielten Tests bestätigen oder widerlegen kann.
Dabei muss ich mir vorher im klaren sein, ob ein bestimmter Test darauf
angelegt ist, eine Hypothese zu widerlegen und damit von der weiteren
Betrachtung auszuschließen oder die Hypothese zu bestätigen, so dass ich davon
meine weiteren Handlungen leiten lassen kann.

Ein statistisches Verfahren ist die Korrelation.
Mit dieser kann ich eine Beziehung zwischen zwei oder mehreren
Merkmalen, Ereignissen oder Zuständen beschreiben.
Dabei muss ich immer beachten, dass diese Beziehung kausal sein kann aber
nicht muss.
Im mathematischen Sinne beschreibt die Korrelation einen statistischen
Zusammenhang im Gegensatz zur Proportionalität, die einen festes Verhältnis
beschreibt.

Oft will ich Vierfelder-Korrelationskoeffizient für ein Merkmal und den Fehler
ermitteln.
Um diesen zu berechnen stelle ich eine Kontingenztafel auf, in der ich die
gemeinsame Häufigkeit der Merkmale eintrage.

|                         | kein Fehler | Fehler |
|-------------------------|-------------|--------|
| Merkmal trifft zu       |     A       |    B   |
|-------------------------|-------------|--------|
| Merkmal trifft nicht zu |     C       |    D   |

A, B, C, D stehen für die Anzahl der Ereignisse, bei den der Fehler auftrat
beziehungsweise nicht auftrat und das Merkmal zutraf oder nicht.
Als Werte für A, B, C und D kann ich Zeiträume summieren, oder zu regelmäßigen
Zeitpunkten ermitteln, welcher Fall zutrifft und die entsprechende Variable
hochzählen.

Der Phi-Koeffizient ermittelt sich dann aus:

{$$}
\phi = \frac{A D - B C}{\sqrt{(A+B) (C+D) (A+C) (B+D)}}
{/$$}

Im einfachsten Fall kann ich eine Korrelation selbst sehen, zum Beispiel, wenn
immer die Verbindung zum Netz A wegfällt, sobald ich die Verbindung zum Netz B
umschalte.
Das sagt zwar nichts aus über die Ursache, es gibt mir aber die Möglichkeit,
das Problem kurzfristig temporär aus dem Weg zu schaffen und, wenn die Zeit
geeignet ist, das Problem hervorzurufen, um es gründlich zu studieren.

Eine andere Klasse von Problemen, bei denen mir Korrelationen weiterhelfen
können, sind intermittierende Probleme, die sich dem andersartigen Zugang
entziehen.
Bei diesen Problem hilft mir am Anfang nur, so viele Daten wie möglich über
das betroffene Gesamtsystem zu sammeln.
Bei der Analyse dieser Daten hilft mir dann die Kovarianzanalyse, das heisst,
ich vergleiche jeweils paarweise verschiedene beobachtete Systemvariablen und
ermittle den Korrelationskoeffizienten.

Wichtig dabei ist, dass ich immer die zusammengehörigen Daten in Beziehung
setze.
Da ich den Zusammenhang meist über die Uhrzeit hergestelle, sorge ich also
entweder im Vorfeld für gleichlaufende Uhren, oder ich muss den Zeitoffset
bestimmen und rausrechnen.

Ein Programm, das sehr hilfreich für die Kovarianzanalyse ist, wurde in
[WSA2011](#bib-wsa2011) beschrieben.

Wichtig bei allen Korrelationsanalysen ist, sich vor Augen zu halten, dass
unabhängige Merkmale immer eine Kovarianz nahe 0 haben.



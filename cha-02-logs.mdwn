
## Logs auswerten

Die Systemprotokolle sind bei nicht trivialen Problemen das erste, was ich
mir ansehe.
Zum einen geben diese oft schon über eine zeitliche Korrelation einen Hinweis
über die Art des Problems.
Zum zweiten finde ich darin die besten Suchworte für eine Internetsuche.

Natürlich müssen dafür die Programme so eingestellt sein, dass ich eine Balance
finde, die mir notwendige Nachrichten anzeigt und unnötige weglässt.
Ein Programm, welches eine bequeme Filterung und Abfrage der Logs ermöglicht,
ist da von Vorteil.
In vielen Fällen habe ich aber nur das lokale Systemlog und die Bordmittel wie
*grep*, *less* oder *more*.

A> Ein Beispiel für diese Balance sind die Lognachrichten des SNMP-Dämons.
A> In bestimmten Situationen will ich, neben den eigentlichen
A> SNMP-Informationen wissen, welcher Rechner wann SNMP-Anfragen gestellt hat.
A> Auf einem kleinen System mit begrenztem Platz für Lognachrichten würde
A> das andere wichtige Nachrichten aus dem Puffer drängen, so dass ich
A> dafür sorge, dass nur berechtigte Systeme SNMP-Anfragen stellen können, und
A> nicht jede Anfrage protokolliert wird.

Noch komplexer wird es, wenn erst mehrere Lognachrichten zusammen eine Aussage
zu einem Problem machen können, wie zum Beispiel beim Durchlaufen einer E-Mail
durch den Server oder beim Anmelden eines VPN-Clients.
Für solche komplexen Auswertungen habe ich ein Grundgerüst für ein
Perl-Skript zur Logauswertung, in das ich die spezifischen Auswertungen im
konkreten Fall einfüge.


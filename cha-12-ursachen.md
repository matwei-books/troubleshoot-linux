
## Ursachen für Performanceprobleme im Netz

Um gezielt nach der aktuellen Ursache für Performanceprobleme suchen zu
können, muss ich wissen, welche Ursachen prinzipiell in Frage kommen und
welche Charakteristika diese haben.
Nachfolgend gebe ich einen Überblick über mögliche Ursachen für
Netzperformanceprobleme.

### Paketverluste

Eine offensichtliche Ursache für Performanceprobleme sind massive
Paketverluste.
Die Betonung liegt hierbei auf massive, da zum Beispiel beim TCP-Protokoll
Paketverluste gezielt zur dynamischen Anpassung der
Übertragungsgeschwindigkeit verwendet werden.
Details dazu finden sich im Kapitel 9.
Diese erwünschten Paketverluste treten überwiegend bei lange laufenden
Verbindungen auf, die sehr viele Daten übertragen, wie zum Beispiel der
Download einer größeren Datei.

In den meisten anderen Fällen deuten Paketverluste auf ein Problem oder eine
Beschränkung hin.
Dann versuche ich die Ursache für den Paketverlust zu finden.
In den meisten Fällen lässt sich dieser auf eine der folgenden Ursachen
zurückführen:

*   Eine überlastete Leitung: es wird versucht mehr Daten pro Zeiteinheit zu
    senden, als bestimmungsgemäß über den betreffenden Leitungsabschnitt
    möglich ist.

*   Eine schlechte Leitung: es ist nicht möglich, die volle Bandbreite zu
    nutzen, die überr einen Leitungsabschnitt zur Verfügung stehen sollte.

*   Ein überlastetes Gateway: dieses benötigt zu viel Zeit, um Daten zwischen
    den Interfaces zu bewegen.

### DNS-Probleme

Ein anderes Problem, dass mitunter als Performanceproblem im Netz angesehen
wird, ist ein Teilausfall im DNS.
Meist wird das beim Browsen im Internet wahrgenommen.
Die erste Beschreibung lautet oft pauschal "das Internet ist heute wieder
schnarchlangsam".
Auf Nachfragen heißt es dann, wenn eine Seite angewählt wird, passiert erstmal
nichts.
Irgendwann geht es los und dann kommt die Seite eigentlich recht schnell.
In diesem Fall würde ich zunächst die DNS-Einstellungen überprüfen
beziehungsweise den DNS-Verkehr mit beobachten.

### Latenz

Eine weitere mögliche Ursache für Performanceprobleme liegt in der Latenz der
Datenpaket, also der Zeit die benötigt wird, um ein Datenpaket vom Sender zum
Empfänger zu bewegen.
Diese Zeit kann ich zum Beispiel mit dem Programm `ping` abschätzen.
Die Latenz ist ungefähr die Hälfte der Round-Trip-Time (RTT).

Üblicherweise wirkt sich eine hohe Latenz vor allem auf interaktive
Verbindungen und kurze Übertragungen spürbar aus.
Ab eine bestimmten Dauer behindern die Verzögerungen zwischen gesendeten und
empfangenen Daten spürbar den Arbeitsfluss.
Langlaufende TCP-Downloads sind eher selten von großer Latenz betroffen, wenn
Sender und Empfänger genügend große Puffer haben.
Zumindest wenn es sich um die natürliche Latenz auf Grund der
Leitungseigenschaften handelt, die sich nicht im Laufe der Übertragung zum
Beispiel durch Überlast erhöht.

### Bufferbloat

Ein Problem, dass in der Fachliteratur als Bufferbloat bezeichnet wird, ist
die künstliche Erhöhung der Latzen durch Puffer in den Gateways.
Diese kommt zustande, wenn bei einem Gateway mehr Daten ankommen, als gesendet
werden können.
Im Laufe der Zeit wurden Gateways mit immer mehr Puffer ausgestattet, damit
bei kurzfristiger Überlast, sogenannten Bursts, keine Datenpakete verloren
gehen und die Leitungen besser ausgelastet werden können.
Die Datenpakete werden im Gateway kurz zwischengespeichert und dann gesendet.
Die Latenz erhöht sich zwar, aber das Datenpaket kommt an.

Problematisch sind diese Puffer genau dann, wenn es zu chronischer Überlast
kommt und die Puffer längerer Zeit gefüllt sind.
Dann gehen neu ankommende Pakete trotzdem verloren und zusätzlich haben wir
eine hohe Latenz, weil zuerst die gepufferten Pakete gesendet werden und dann
neu angekommene.

Wenn die Überlast durch ungeregelte Datenströme hervorgerufen wird, wie VoIP
oder Videostreams, dann hilft nur die Bandbreite zu erhöhen, oder den
Datenstrom umzuleiten oder gezielt zu reduzieren.

Geregelte Datenströme, wie TCP, regulieren normalerweise ihre
Sendegeschwindigkeit so, dass die zu Verfügung stehende Bandbreite möglichst
optimal genutzt wird.
Nur funktioniert genau diese Regelung bei Bufferbloat nicht mehr auf Grund der
durch den Puffer eingeführten zusätzlichen Latenz.
Da TCP die Sendegeschwindigkeit erst bei Paketverlusten herunter regelt,
diese aber erst auftreten, wenn der Puffer voll ist, ist es bereits zu spät.

Natürlich tritt das Problem mit Bufferbloat nur an den Stellen auf, wo Daten
an einem Gateway nicht so schnell abfließen können, wie sie ankommen.
Das heisst an Gateways mit unterschiedlichen Schnittstellengeschwindigkeiten
oder, wenn an eine Schnittstelle Daten gesendet werden, die an mehreren
Schnittstellen angekommen sind.

Kenne ich das Netz, dann weiss ich, wo die neuralgischen Punkte sind und
schaue mir dort die Schnittstellenauslastung an.
Dabei hilft mir ein Monitoring der Datenübertragungsraten an den
Schnittstellen.
Ein konkreter Hinweis auf Bufferbloat ist eine stark erhöhte Latenz zusammen
mit einer unter Vollast betriebenen Leitung.

### Unnötiger Datenverkehr

Schließlich liegt eine mögliche Ursache für Performanceprobleme im Netz in
unnötigem Datenverkehr, der die Leitungen zusätzlich zum regulären
Datenverkehr belastet.

Hierbei ist es nicht einfach, zu entscheiden, welcher Datenverkehr unnötig ist
und welcher nicht.
Zudem ist es auch nicht trivial die Auslastung anteilig einzelnen Datenströmen
zuzuordnen.
Mit Netflow lässt sich dass zumindest ansatzweise einschätzen.

In diesem Fall ist zu überlegen, ob durch geschicktere Platzierung von
Servern und Arbeitsstationen der Bedarf an Bandbreite reduziert werden kann.
Das ist aber ein Thema für die Netzwerksplanung und nicht für die
Fehlerbeseitigung.

Kurzfristig hilft vielleicht eine Priorisierung des Datenverkehrs.

### Überlast des Servers

Manchmal erweist sich das Netzperformanceproblem auch einfach als
Performanceproblem des Servers oder Client-Rechners.
Wenn sich aus allen beobachteten Netzwerkparametern kein Hinweis ergibt,
sollte ich auch dieses als mögliche Ursache nicht aus den Augen verlieren.
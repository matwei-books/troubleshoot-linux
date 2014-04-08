
## ping {#sec-netz-werkzeuge-ping}

Eines der grundlegenden und vielseitigsten Werkzeuge für das
Netzwerk-Troubleshooting ist Ping. Mit diesem Programm kann ich:

*   testen, ob eine Maschine überhaupt erreichbar ist,

*   sehen, wie lange ein Paketaustausch dauert,

*   analysieren, welche Bandbreite die Verbindung zu einem Rechner hat,

*   die Performance meines Rechners und Netzwerkes einschätzen,

*   eine hohe Netzlast für andere Tests erzeugen.

Natürlich sind alle mit Ping gewonnen Erkenntnisse mit einer Prise Salz zu
nehmen, aber das trifft schließlich auf jedes Werkzeug zu.

In [[Sloan2001](#bib-sloan2001)] sind die Anwendungen von Ping beim
Netzwerk-Troubleshooting sehr gut und ausführlich beschrieben.

Die wichtigsten Kommandozeilenoptionen von `ping` sind:

-c count
: um die Anzahl der gesendeten Datenpakete zu begrenzen,

-i interval
: um den zeitlichen Abstand in Sekunden zwischen den
  einzelnen Paketen vorzugeben (Voreinstellung ist eine Sekunde)

-s size
: um die Größe der Datenpakete in Bytes vorzugeben
  (Voreinstellung ist 56, hinzu kommen immer noch 8 Byte für den
  ICMP-Header)

-n
: um die Auflösung von Hostnamen abzuschalten

-q
: um die Ausgabe der einzelnen Zeiten abzuschalten (die
  Statistikinformationen am Ende werden trotzdem ausgegeben)

-f
: um die Ping-Pakete mit maximaler Geschwindigkeit zu senden und
  dadurch eine möglichst hohe Netzlast zu erzeugen (diese Option sowie die
  Option `-i` mit Zeiten unter 0,2 Sekunden benötigen Superuserrechte)

  Daneben gibt es sehr viele weitere Optionen, die seltener benötigt werden
  und deren genaue Auswirkungen aus den Handbuchseiten erschlossen werden
  können.

### Verbindungstest

Das ist der einfachste Test, den ich mit Ping ausführen kann. Ich gebe

    $ ping rechnername

ein und bekomme heraus, ob die betreffende Maschine erreichbar ist. Das
heißt, ob Antwortpakete von dort zurück kommen. Ältere Versionen des
Programms begnügten sich auch schon mit der Ausgabe:

    rechnername is alive

Moderne Versionen zeigen nach Beendigung des Programms (nötigenfalls durch
Abbruch mit `<CTRL>-C`) die Paketlaufzeiten und einige Statistiken an.

Ein Problem, das das Testen der Verbindung mit Ping verhindern kan, sind zu
restriktive Firewalleinstellungen. Bei etlichen Rechnern habe ich erlebt,
dass diese nach der Installation zwar am Netzverkehr teilnehmen konnten,
aber selbst nicht auf ICMP-Hello-Pakete (Ping) antworteten. Das ist, aus
meiner Sicht, eine Überreaktion auf die Tatsache, das einige DoS-Angriffe
das ICMP-Protokoll und insbesondere ICMP-Hello (Ping) verwendet haben. Man
kann schlecht jedem vorschreiben, was er in seinem Netzwerk erlaubt und was
nicht. Auf jeden Fall möchte ich jeden bitten, sachlich einen möglichen oder
eingebildeten Gewinn an Sicherheit gegenüber der Erschwernis der
Netzwerkdiagnose abzuwägen.

### Netzwerkperformancemessungen

Ein weiteres Anwendungsgebiet sind Performancemessungen im Netzwerk. Am
einfachsten geht die Bestimmung der Paketlaufzeit zu einem entfernten
Rechner und zurück, denn diese gibt Ping selbst aus. Bin ich an der reinen
Laufzeit interessiert, muss ich mir einen Zeitpunkt suchen, zu dem sehr
wenig im Netz los ist. Aber auch die Bandbreite kann ich mit Ping bestimmen
sowie Netzwerklast für Lastmessungen erzeugen.

### Probleme mit Ping

Ein paar Sachen gibt es zu beachten, wenn ich Ping beim Troubleshooting
verwende.

Zunächst arbeitet Ping nicht im luftleeren Raum, snondern hängt vom
Funktionieren anderer Netzwerkelemente ab. Arbeite ich mit Hostnamen statt
IP-Adressen, dann muss DNS fuktionieren, oder die Namen via /etc/hosts
auflösbar sein.

Dann muss die Ethernet-Adresse des Zielrechners oder Routers aufgelöst
werden können. Dazu muss ich sicherstellen, dass das ARP-Protokoll
funktioniert oder statische ARP-Einträge verwenden (und zwar auf beiden
Seiten). Üblicherweise wird die erste RTT bei einer Messung mit Ping durch
das ARP-Protokoll verfälscht. Diesem Problem kann ich begegnen, indem ich
grundsätzlich mehrere Ping-Pakete sende und die erste Zeit ignoriere.

Bei der Bestimmung der Bandbreite eines Links verwende ich ohnehin die
niedrigste Zeit, da ist dieses Problem bereits berücksichtigt. Ich muss
lediglich daran denken, immer mehrere gleichartige Ping-Pakete zu senden.

Ein weiteres mögliches Problem ist, das das korrekte Funktionieren des
Netzwerkes von Faktoren abhängen kann, die Ping nicht beeinflussen. So kann
zum Beispiel ein kleines Ping-Paket problemlos hindurch gelangen, während
größere Datenpakete der Anwendungsprotokolle verworfen werden.

Andererseits kann ICMP administrativ geblockt sein, während
Anwendungsprotokolle von der Firewall durchgelassen werden, was zu einem
False Negative führen kann. Gerade diese Konstellation trifft man häufig in
Netzen, die von paranoiden Administratoren konfiguriert werden oder in
solchen, deren Administration die Auswirkungen der betreffenden Sperren
nicht in vollem Maße abschätzen können. Trotzdem halte ich es für sinnvoll,
die Argumente für und wieder diese Sperren im Einzelfall zu klären und zu
dokumentieren, damit es an dieser Stelle nicht immer wieder zu Diskussionen
kommt, weil die Sicherheitseinstellungen das Troubleshooting erschweren. Für
eine entsprechende Argumentation ist es notwendig, die möglichen
Sicherheitsprobleme und gegebenenfalls alternative Gegenmaßnahmen genau zu
kennen.

Mögliche Argumente für ein Sperren von ICMP sind:

Smurf Attacks
: Ein ICMP-Paket mit gefälschter Absenderadresse wird
  an die Broadcast-Adresse eines Netzes gesendet. Der Rechner, dem die
  gefälschte Absenderadresse gehört, bekommt von allen Rechnern des
  Netzsegments eine Antwort.
  Zur Abhilfe kann man Pakete an Netz-Broadcast-Adressen am Router
  ausfiltern. Damit schränkt man diesen Angriff auf das lokale Netz ein.
  In diesem sollte es relativ einfach möglich sein, den Verursacher zu
  ermitteln.

Ping of Death
: Es gibt (ältere) Betriebssysteme, die mit übergroßen
  ICMP-Paketen nicht umgehen können und damit außer Betrieb genommen
  werden können. Dieses Problem sollte mit allen aktuellen
  Betriebssystemen behoben sein.

Auskundschaften des Netzes
: Mit ICMP ist es möglich, die Adressen
  der Rechner in einem IPv4-Netz zu ermitteln. Hier ist zu bedenken, ob
  das wirklich ein Problem darstellt.

Unerwünschter Traffic
: Durch ICMP (insbesondere Floodping) kann
  unnötiger unerwünschter Traffic erzeugt werden, der legitimen
  Datenverkehr behindert. Hier kann man das Problem, soweit es geht mit
  Rate-Limiting am Router eindämmen.

Wenn Ping nicht komplett blockiert wird, ist immerhin noch möglich, dass das
Protokoll eine sehr niedrige Priorität am Router bekommt und allein dadurch,
insbesondere bei gut ausgelateten Routern unter den Tisch fällt oder
zumindest die RTT stark verfälscht wird.

Bei manchen Routern kann es vorkommen, dass im Fall von NAT die
ICMP-Echo-Antwort nicht zum anfragenden Host zurückgeschickt wird.

Interessanterweise kann man trotz unterdrücktem ICMP zumindest im lokalen
Netzsegment herausbekommen, ob eine bestimmte IP-Adresse verwendet wird.
Dazu löscht man den ARP-Cache und schickt dann ein Ping-Paket zur
entsprechenden Adresse. Ist danach ein korrekter ARP-Eintrag vorhanden, ist
der Host angeschlossen und unterdrückt das ICMP-Echo.

Eines muss man bei Ping-Tests immer im Hinterkopf behalten: Ping testet nur
die Erreichbarkeit einer bestimmten IP-Adresse. Ob die angebotenen Dienste
funktionieren und ob überhaupt der richtige Rechner diese Adresse verwendet,
muss ich auf anderem Wege herausbekommen.

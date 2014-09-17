
## Sonstige Probleme

### Falsche Absenderadresse

Die Diskriminierung von Rechnern anhand ihrer IP-Adresse hat den Vorteil, dass
ich Ressourcen spare, weil bestimmte Verbindungen, die ich nicht haben will,
gar nicht erst zustande kommen.
Ich spare

*   Rechenzeit, weil der Prozess, der den teilweise gesperrten Dienst
    anbietet, nichts tun muss,
*   Datenverkehr, weil der Server nicht erst die Verbindung annimmt und
    dann irgendwann wieder schließt,
*   Plattenplatz, weil ich keine Einträge im Log bekomme,
*   Zeit, wenn ich die Logs durchsuchen muss.

Alles in allem also eine gute Sache, wenn es richtig funktioniert.

Schief gehen kann das aus den unterschiedlichsten Gründen.
Hier betrachte ich den Fall, dass ein Rechner, der eine zugelassene
Adresse besitzt, nicht durchkommt, weil er eine andere IP-Adresse benutzt.

Allein das zu erkennen dauert manchmal schon sehr lange, weil es oft nur ein
winziger Unterschied in der Absenderadresse ist.
Und wenn es scheinbar von einem auf den anderen Tag kommt, rechne ich auch
nicht gleich mit so etwas.

Wenn ich mehrere IP-Adressen aus einem Segment auf dieselbe Schnittstelle lege
und die Schnittstelle zusätzlich via Hot Plug konfiguriert wird, kann ich
nicht vorhersagen, welche IP-Adresse zur primären wird und welche zur
sekundären.

Bei vielen Programmen kann ich die Absenderadresse in der Konfiguration
oder beim Aufruf des Programmes vorgeben.
Bei `netcat` zum Beispiel mit der Option `-s $absenderadresse`.

Wenn das Programm keine Vorgaben zulässt oder ich aus anderen Gründen keine
geben will, muss ich auf anderem Weg dafür sorgen, dass der Rechner die
richtige Adresse verwendet.

Eine Möglichkeit ist, die gewünschte Adresse zur primären Adresse zu machen.
Wie das geht hängt von der Linux-Distribution ab und wie bei dieser die
Schnittstellen konfiguriert werden.
Das Programm `ip` von *iproute* kennt Argumente, mit denen ich das einstellen
kann.
Es ist jedoch mühsam und fehleranfällig.
Ich muss das unter verschiedenen Konstellationen
testen, bevor ich mich darauf verlassen kann.

Eine andere, flexiblere Möglichkeit besteht darin, die Absenderadresse mit
`iptables` zu modifizieren.
Solange ich es mit keinem Protokoll zu tun habe, das explizit auf die
IP-Adressen Bezug nimmt (IPSEC ist ein Beispiel dafür), macht diese Lösung
keine Probleme und erlaubt sogar, dass ich zu verschiedenen IP-Adressen oder
Ports Kontakt mit unterschiedlichen Absenderadressen aufnehmen kann.

Der Aufruf von `iptables` lautet:

{line-numbers=off,lang="text"}
    iptables -t nat -I POSTROUTING \
             -o $dev               \
             -d $server            \
             ! -s $wanted_ip       \
             -j SNAT               \
             --to-source $wanted_ip

Hierbei ist `$dev` die Schnittstelle, über die das Datagramm gesendet wird,
`$server` die IP-Adresse des Servers, zu dem es geht und `$wanted_ip` ist die
gewünschte Absenderadresse.
Die Regel greift bei allen Absenderadressen, die von der gewünschten
abweichen.
Mit weiteren Selektoren kann ich die Regel noch weiter einschränken, zum
Beispiel auf den Port oder nur auf TCP.

Diese Lösung ist flexibel und macht mich unabhängig von der aktuell
eingestellten primären IP-Adresse.

Der Nachteil ist die komplexere Konfiguration der Firewall und ein
erhöhter Aufwand im Kernel, weil die Adresse in jedem Datagramm, das zur
Regel passt, umgeschrieben werden muss.

### Mehrere Router im Netzsegment

Dieses Problem hat dazu geführt, dass ich in Netzsegmenten mit Endgeräten,
die nicht von mir betreut werden, möglichst vermeide,
mehrere Router zu verschiedenen Netzen einzusetzen.

Üblicherweise kennen Arbeitsstationen und Server, die sich nicht an den
Routingprotokollen beteiligen, nur ein Gateway in andere Netze. Alle
Datagramme, die nicht für das lokale Netzsegment bestimmt sind, werden an
dieses Gateway geschickt und von diesem weitergeleitet.

Oft genug habe ich erlebt, dass mal eben ein weiteres Netz über ein
zusätzliches Gateway in diesem Netzsegment angeschlossen wird.
Abgesehen von möglichen Sicherheitsproblemen schicken die Clients ihre
Datagramme für dieses Netz zum Standardgateway.

Das ist an und für sich kein Beinbruch, da das Standardgateway die Datagramme
an das richtige Gateway weiterleitet und dem Sender eine ICMP-Nachricht
schickt, dass dieser das andere Gateway für dieses Netz verwenden soll.

Dieses Verfahren hat nur einen geringen Overhead und funktioniert in vielen
Fällen problemlos.
Außer, wenn es nicht funktioniert.

Alle mir bekannten Fälle, in denen dieses Verfahren nicht funktioniert hat,
betrafen Rechner mit Microsoft Windows als Betriebssystem.
Wobei das Verhalten abhängig war von der Version des Betriebssystems und den
Einstellungen des Rechners.
Mit moderneren Versionen des Betriebssystems traten häufiger Probleme auf, als
mit älteren.
Manchmal funktionierte die Verbindung im selben Segment bei einigen
Arbeitsstationen und bei anderen nicht, ohne dass der zuständige Administrator
herausfinden konnte, warum.

Die genaue Ursache ist mir nicht bekannt, ich vermute, dass die
Windows-Firewall die Antwortpakete mit der MAC-Adresse des anderen
Gateways nicht akzeptiert.
In allen Fällen, bei denen ich dieses Verhalten feststellen konnte,
funktionierte die Verbindung zum betreffenden Netz sofort, wenn temporär die
Windows-Firewall deaktiviert wurde.

Je nachdem, wie gut der Administrator der betroffenen Rechner ist, und wie
dringend die Windows-Firewall in dem Netz benötigt wird, bleibt
in manchen Fällen nur, den zweiten Router in einem anderen Netzsegment
anzuschließen, so dass alle Datagramme wieder über das Standardgateway
gesendet werden können.

### Path-MTU

Ein Problem, das zunächst oft falsch interpretiert wird, tritt auf, wenn die
[automatische Bestimmung der Path-MTU](#sec-path-mtu) nicht funktioniert.
Das kann durch Firewall-Regeln passieren, durch NAT oder durch Probleme beim
Routing.
In Kombination mit einer reduzierten Path-MTU, zum Beispiel bei VPN- oder
PPPoE-Verbindungen (DSL) ergeben sich sehr subtile Fehler.

Ich kann dann Plaintext-Protokolle, wie im vorigen Abschnitt beschrieben,
testen und zum Beispiel einen SMTP-Server als völlig in Ordnung identifizieren.
Trotzdem kann ein anderer SMTP-Server diesem einige E-Mail nicht zustellen,
obwohl mein Test vom selben Rechner aus kein Problem anzeigte.

Beim manuellen Testen des Protokolls entstehen meist nur kleine Datenpakete,
die in einem Stück durch alle Netzsegmente gesendet werden können.
Das gleiche passiert bei kleinen E-Mails von wenigen hundert Bytes.

Sobald die zu versendende Nachricht jedoch größer ist als die Path-MTU,
sendet der Server mindestens ein zu großes Datagramm.
Da die ICMP-Unreachable-Nachricht nicht bis zu ihm durchdringt, weiß der
Sender nicht, dass das Datagramm nicht ankommt.
Auch das Wiederholen des Datagramms hilft hier nicht.
Der Empfänger hat alle vorherigen Datagramme bestätigt und nun keine
Veranlassung seinerseits etwas zu unternehmen, so dass die Verbindung zum
Stillstand kommt.
Irgendwann beendet einer der Beteiligten die TCP-Sitzung auf Grund
eines Timeouts.

Wenn ich nicht von selbst an dieses mögliche Problem denke, kann ich
sehr lange an den falschen Stellen suchen.

Mit `ping` kann ich testen, ob die Path-MTU geringer ist, als die MTU des
ersten Segments:

![ping -n -c1 -Mdo -s 1472 172.17.1.2](images/ch12-ping-Mdo-s1472.png)

Das Beispiel zeigt die Ausgabe, wenn ich versuche über eine PPPoE-Verbindung
ein anderes Netz zu erreichen.
Mein PING-Datagramm ist 1500 Byte groß, es gehen aber nur 1492 Byte über den
nächsten Hop.
Wenn ich es 8 Byte kleiner mache, funktioniert es:

![ping -n -c1 -Mdo -s 1464 172.17.1.2](images/ch12-ping-Mdo-s1464.png)

Bei gestörter Path-MTU-Discovery werde ich die Fehlermeldung beim ersten Test
nicht sehen, sondern einfach keine Antwort bekommen.
Dann muss ich dem Datenpfad folgen und sehen, wie weit meine Datagramme
kommen.

Habe ich ein Problem mit der Path-MTU-Discovery festgestellt, ist
die nächste Frage, wie ich das abstelle.

Die schnellste Lösung ist, die MTU des Senders zu reduzieren.
Damit verringere ich die nutzbare Bandbreite, weil auf Grund der kleineren
Datenpakete das Verhältnis von Nutzdaten zu Protokolldaten ungünstiger wird.
Darum ziehe ich das im Allgemeinen nur als temporäre Lösung in Betracht.

Für TCP habe ich auf den Gateways oft die Möglichkeit, die MSS-Option beim
Verbindungsaufbau zu modifizieren, so dass alle TCP-Verbindungen über den
entsprechenden Weg automatisch mit einer geringeren maximalen Größe der
Datagramme arbeiten.
Das Stichwort, wonach ich in der Dokumentation suche, lautet MSS-Clamping.
Das ist insbesondere dadurch vorteilhaft, weil es nur die TCP-Verbindungen
betrifft, die über den problematischen Abschnitt laufen.
Außerdem muss ich nichts an den Endpunkten der Verbindung einstellen.

A> Einige TCP-Stacks reduzieren automatisch die MTU, wenn die
A> Gegenstelle auf das erste große TCP-Datagramm nicht antwortet.
A> Dann kommt es lediglich zu einem kurzen Timeout und die Übertragung geht
A> mit relativ kleinen Datagrammen weiter.
A> Manchmal kommt man überhaupt nicht
A> auf die Idee, dass hier ein Problem mit der Path-MTU-Discovery vorliegen
A> könnte.
A> 
A> In einem konkreten Fall hatte ich einen WAN-Router, den ich zwar über das
A> Webinterface konfigurieren konnte, bei dem die Verbindung aber sofort
A> einfror, wenn ich einen VPN-Schlüssel übertragen wollte.
A> Als ich beim Herstellersupport anrief, fragte dieser nur, ob ich das Gerät
A> von einem Ubuntu-Rechner (10.04) aus konfiguriert hatte.
A> 
A> Ich hatte.
A> Sein Rat lautete, eine andere Linux-Distribution oder MS Windows zu
A> verwenden.
A> Damit funktionierte das Übertragen der Schlüssel.
A> 
A> Natürlich war meine Neugierde geweckt, mit Wireshark beobachtete ich die
A> Übertragung und konnte sehen, dass MS Windows einige Sekunden nachdem es das
A> erste große Datagramm gesendet hatte, den ersten Teil derselben Daten in
A> einem kleineren Datagramm von ca 700 Bytes sendete.
A> Dieses kleinere Datagramm wurde beantwortet und in Folge sendete der Rechner
A> alles mit dieser reduzierten MTU.
A> Der Ubuntu-Rechner machte das nicht und seine Verbindung blieb folglich beim
A> ersten großen Datagramm stecken.
A> Nachdem ich temporär die MTU um wenige Bytes reduziert hatte, konnte auch
A> er größere Dateien mit dem WAN-Router austauschen.

### Falsche Absenderadresse

Dieser Fehler ist subtil und kommt nur vor, wenn ein Rechner mehrere
IP-Adressen hat und ein anderer anhand der IP-Adresse diskriminiert.

Zugriffsbeschränkungen anhand der IP-Adresse sind sehr verbreitet.
Manchmal werden sie durch Paketfilterregeln durchgesetzt, manchmal mittels
Wietse Venemas `tcpd` und einige Programme erlauben es direkt in ihrer
Konfiguration.

Das ist für sich genommen sehr nützlich, weil ich so einschränken kann, welche
Rechner einen Dienst überhaupt erreichen können und welche nicht.

Gründe, einem Rechner mehrere IP-Adressen zu vergeben gibt es viele, darüber
will ich an dieser Stelle nicht spekulieren.

Zum Problem kann es werden, wenn ein Rechner, der eine zugelassene IP-Adresse
hat und zusätzlich andere, keinen Zugang zu einem Dienst bekommt, weil er sich
mit der falschen Absenderadresse an den Dienst wendet.

Bei vielen Programmen, die über das Netz Verbindungen aufbauen, kann ich die
Absenderadresse angeben.
Ich muss allerdings daran denken, die entsprechenden Optionen mit anzugeben
oder falls es eine Konfigurationsdatei gibt, das in dieser einzutragen.

Gebe ich keine Absenderadresse an, nimmt der Rechner die primäre IP-Adresse.
Welche das ist, kann ich mit dem Programm `ip` ermitteln:

{line-numbers=off,lang="text"}
    $ ip route get 192.168.1.1
    192.168.1.1 dev eth0  src 192.168.1.3 
        cache 

Stelle ich auf diese Weise fest, dass der Rechner die falsche IP-Adresse
verwendet, so gibt es verschiedene Möglichkeiten, die richtige einzustellen.

*   mit dem Programm `ip`
*   mit iptables

**FIXME** (wie)


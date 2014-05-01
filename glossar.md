
# Glossar

ARP
: Das *Address Resolution Protocol* ermittelt die zu einer IP-Adresse
  gehörende Adresse der Netzzugangsschicht, in den meisten Fällen Ethernet.
  Das Protokoll wird in RFC 826 beschrieben.

BIOS
: Das BIOS, von *Basic Input/Output System* ist die
  [Firmware](#glossar-firmware) der PCs, die auf den IBM-PC zurückgehen.

Bitübertragungsschicht (OSI-Modell)
: Die Bitübertragungsschicht ist die unterste Schicht des OSI-Modells für
  Netzwerkprotokolle.
  Sie stellt Hilfsmittel zur Verfügung, um Bits über physische Verbindungen
  zu übertragen. Das können zum Beispiel elektrische oder optische Signale,
  elektromagnetische Wellen oder Schall sein.

Bootstrapping
: Von der englischen Redewendung *"pull oneself up by one’s bootstraps"*
  abgeleitet, bezeichnet man mit Bootstrapping einen Prozess, bei dem aus
  einem einfachen System heraus ein komplizierteres aktiviert wird, wie zum
  Beispiel beim Start des Betriebssystems.

BPF
: *Der Berkeley Packet Filter* bietet auf UNIX-ähnlichen Systemen eine
  Software-Schnittstelle zu Netzwerkgeräten und erlaubt darüber Datagramme der
  Sicherungsschicht (link layer) zu empfangen und zu senden.
  Das Programm `tcpdump` nutzt beispielsweise BPF für den Zugriff auf die
  Datagramme der Netzschnittstellen. Seine Handbuchseite enthält eine
  umfangreiche Beschreibung der Filterausdrücke, mit denen die
  interessierenden Datagramme ausgewählt werden können.

Broadcast
: Eine Broadcast-Nachricht ist eine Nachricht, die an alle Teilnehmer des
  Netzes gesendet wird.
  Siehe auch *Unicast* und *Multicast*.

Bufferbloat
: Damit bezeichnet man das Phänomen in paketvermittelten Netzwerken wie dem
  Internet, dass exzessives Puffern von Datenpaketen in Gateways zu hoher
  Latenz und Variationen in der Übertragungszeit von Datenpaketen führt und
  auch den Gesamtdurchsatz des Netzes verringern kann.

CIDR
: *Classless Inter Domain Routing* (CIDR) beschreibt ein Verfahren, um bei
  IPv4 den IP-Adressraum effizienter auszunutzen.
  Mit CIDR entfällt die feste Zuordnung einer IPv4-Adresse zu einer
  Netzklasse, aus welcher die Präfixlänge hervorging.
  Durch die zusätzliche Angabe einer Netzmaske wird jetzt die IP-Adresse in
  den Netzwerk- und Hostteil aufgeteilt.
  Weitere Informationen zu CIDR finden sich in den RFCs 1518, 1519 und 4632.

CPU
: Die *Central Processing Unit*, ist der Baustein des Computers, der die
  Maschinenbefehle der Programme abarbeitet und die restliche Elektronik
  steuert.
  Der Begriff ist nicht eindeutig abgrenzbar, weil einerseits in manchem
  Kontext die ganze Platine mit dem Prozessorbaustein und eventuell
  Hauptspeicher als CPU bezeichnet wird und andererseits manche
  Prozessorbausteine selbst mehrere unabhängige CPU enthalten, die
  gleichzeitig verschiedene Programme abarbeiten können.

Crypto-PAn
: *Cryptography-based  Prefix-preserving Anonymization* ist ein Verfahren, um
  die IP-Adressen in Netzwerk-Mitschnitten zu anonymisieren.
  Dabei werden die IP-Adressen einzeln umgesetzt, Netzwerk-Präfixe bleiben
  erhalten.
  Das Verfahren nutzt kryptographische Pseudo-Zufallszahlen, die mit einem
  Schlüssel initialisiert werden, und erlaubt dadurch die Umsetzungen
  konsistent über verschiedene Mitschnitte zu halten.

{#glossar-dac}
DAC, Discretionary Access Control
: Bei der Discretionary Access Control (deutsch: Benutzerbestimmbare
  Zugriffskontrolle) wird die Entscheidung, ob auf eine Ressource zugegriffen
  werden darf, allein auf der Basis der Identität des Benutzers getroffen.
  Dieser steht die [Mandatory Access Control](#glossar-mac) gegenüber, die den
  Zugang auf Grund allgemeiner Regeln und zusätzlicher Informationen über den
  Benutzer trifft.
  In [Kapitel sechs](#sec-lokal-zugriffsrechte) gehe ich näher auf
  verschiedene Optionen der Zugangskontrolle bei Linux ein.

Dateibaum
: [siehe Dateisystem](#glossar-dateisystem)

{#glossar-dateisystem}
Dateisystem
: Ein Dateisystem beschreibt die Organisation der Datenablage auf einem
  Datenträger.
  Der Hauptzweck für den Benutzer ist die Zuordnung eines Dateinamens innerhalb
  des Dateisystems zu den entsprechenden Datenblöcken und Metadaten.
  Abhängig von der Art des Datenträgers und dem Einsatzzweck des Dateisystems
  kommen verschiedene Arten von Dateisystemen zum Einsatz.
  In [Kapitel 4](#sec-linux-grundlagen-dateien) gehe ich näher auf den
  Zusammenhang von Dateisystemen und Dateien ein.

{#glossar-datenbank}
Datenbank
: Eine Datenbank ist ein System zur elektronischen Datenverwaltung.
  Dabei unterscheidet man die Software, auch Datenbankmanagementsystem (DBMS)
  genannt, von der Datenbank im engeren Sinne, den Daten.
  Die Daten in einem Datenbanksystem bestehen aus den Nutzerdaten und den
  Verwaltungsdaten, die man Metadaten nennt.
  Es gibt verschiedene Datenbankmodelle wie zum Beispiel hierarchische
  Modelle, die in Dateisystemen verwendet werden, netzwerkartige
  Modelle, die wir beim DNS finden, oder dokumentenorientierte Modelle,
  wie Mailboxen.
  Neben den genannten gibt es noch andere, im Rahmen dieses Buches weniger
  relevante Datenbankmodelle, außerdem können Mischformen auftreten.

Datendurchsatz
: Damit bezeichnet man die im Mittel über einen Übertragungsweg pro
  Zeiteinheit  übertragene digitale Datenmenge.

Datenübertragungsrate
: Diese bezeichnet die digitale Datenmenge, die in einer definierten Zeit
  übertragen wird.
  Die maximal mögliche Datenübertragunsrate bezeichnet man auch als
  Kanalkapazität, die, gemeinsam mit der Latenz, zwei wesentliche Kenngrößen
  eines Übertragungsweges darstellen.

DHCP
: Das *Dynamic Host Configuration Protocol* ermöglicht die Zuweisung der
  Netzwerkkonfiguration an Clients durch einen Server.
  Neben den IP-Adressen und Routern können noch weitere Informationen, wie
  DNS-Server, Zeitserver oder Informationen zu HTTP-Proxy-Servern übergeben
  werden.

DMA, Direct Memory Access
: Beim Speicherdirektzugriff greifen externe Geräte wie zum Beispiel
  Festplatten- oder USB-Controller ohne den Umweg über die CPU auf den
  Speicher zu.
  Das entlastet die CPU, so dass diese mehr Rechenzeit für andere Aufgaben zu
  Verfügung hat.
  Dafür kann der Hauptspeicher ohne Einfluss des Betriebssystems verändert
  werden, was im schlimmsten Fall zum Absturz oder zur Kompromittierung des
  Systems führen kann.

DNS
: Das *Domain Name System* ist ein verteiltes hierarchisches Datenbanksystem,
  das primär der Zuordnung von Rechnernamen zu IP-Adressen dient.
  Es ist in den RFCs 1034 und 1035 beschrieben.

DRM, Direct Rendering Manager
: Der Direct Rendering Manager ist ein Linux-Kernelmodul, das Zugriff auf den
  Speicher der Grafik-Karte gewährt.
  Damit ist es möglich, diesen auch ohne X-Server in Programmen zu verwenden.

Einhängepunkt
: siehe [Mount Point](#glossar-mount-point).

EWMA
: *Exponentially-Weighted Moving Average* ist ein Verfahren zur Glättung von
  Zeitreihen, bei denen ältere Datenpunkte geringer gewichtet werden als
  neuere.

{#glossar-firmware}
Firmware
: Unter Firmware versteht man Software, die in elektronischen Geräten fest
  eingebettet ist und, wenn überhaupt, dann oft nur mit speziellen
  Vorkehrungen änderbar ist.
  Bei Computern lädt die Firmware das Betriebssystem.

Gateway
: Ein Gateway verbindet Rechnernetze, die auf unterschiedlichen
  Netzwerkprotokollen basieren können.
  Zum Beispiel kann ein Gateway E-Mail in SMS oder umgekehrt umwandeln.
  Der Begriff Gateway wird teilweise auch dann verwendet, wenn keine Protokolle
  umgewandelt, sondern nur Teilnetze miteinander verbunden werden.

{#glossar-geraetedatei}
Gerätedatei
: Über Gerätedateien erlaubt der Kernel normalen Anwenderprogrammen den
  Zugriff auf die Hardware des Systems.
  Dabei können die Gerätedateien wie
  [reguläre Dateien](#glossar-regulaere-datei) verwendet werden.
  Man unterscheidet blockorientierte und zeichenorientierte Gerätedateien.
  Ursprünglich wurden Gerätedateien mit dem Programm `mknod` angelegt.
  Später übernahm *devfs* das dynamische Erzeugen von Gerätedateien.
  In modernen Linuxsystemen werden Gerätedateien mit *udev* verwaltet.
  In [Kapitel 4](#sec-linux-grundlagen-dateien) gehe ich näher auf die
  Zusammenhänge von Dateien und Dateisystemen ein.

HTTP
: Das *Hypertext Transfer Protocol* dient zum Übertragen von Daten im
  Netzwerk.
  Es wird für die Übertragung von Webseiten und Bildern im Webbrowser
  verwendet und zunehmend auch für die Kommunikation von Serverdiensten
  untereinander.
  Das Protokoll wird in RFC 1945 (Version 1.0) und RFC 2616 (Version 1.1)
  beschrieben.

ICMP
: Das *Internet Control Message Protocol* dient dem Austausch von Steuer und
  Fehlernachrichten über das Internet Protokoll.
  Es wird in RFC 792 beschrieben.

IDE, Integrated Drive Electronics
: Das ist eine ältere Festplattenschnittstelle, bei der die Steuerelektronik
  im Festplattengehäuse integriert ist.

IGMP
: Das *Internet Group Management Protocol* dient zur Organisation von
  Multicast Gruppen im Rahmen des Internet Protokolls.
  Die verschiedenen Versionen werden in den RFCs 1112, 2236 und 3376
  beschrieben.

Initramfs
: Das Initramfs ist ein komprimiertes Archiv, das für den Systemstart
  benötigte Dateien enthält.
  Es kann vom Kernel beim Systemstart als Stammverzeichnis eingehängt werden.
  Anschließend wird ein im Initramfs vorhandenes Programm *init* gestartet,
  welches den Systemstart vorbereitet und als letztes */sbin/init* startet.

{#glossar-inode}
Inode
: Ein Inode (von engl. *index node*) ist ein Eintrag in einem
  [Dateisystem](#glossar-dateisystem), der die Verwaltungsinformationen
  (Metadaten) für die zugehörige Datei enthält.
  In [Kapitel 4](#sec-linux-grundlagen-dateien) gehe ich auf die Zusammenhänge
  von Dateien, Inodes und Verzeichnissen detaillierter ein.

IP, IPv4, IPv6
: Das *Internet Protocol* stellt die Grundlage des Internets dar.
  Es implementiert die Vermittlungsschicht des OSI-Modells beziehungsweise die
  Internetschicht des TCP/IP-Modells.
  Version 4 (IPv4) wird in RFC 791 beschrieben, Version 6 (IPv6) in RFC 2640.

IPG
: Das *Interpacket Gap* bezeichnet den minimalen Abstand zwischen zwei auf
  einem Übertragungsmedium gesendeten Datenpaketen.

Jitter
: Als Jitter bezeichnet man die Varianz der Laufzeit von Datenpaketen.
  Dieser Effekt ist insbesondere bei Multimedia-Übertragungen stören, da
  einzelne Datenpakete zu früh oder zu spät für eine kontinuierliche
  Darstellung ankommen.

Kerberos
: Kerberos ist ein verteilter Authentisierungsdienst für Computernetze.
  Die aktuelle Version 5 ist in RFC 4120 beschrieben.
  Das Protokoll benötigt einen Zeitabgleich der beteiligten Computer, zum
  Beispiel durch NTP.
  Microsoft verwendet das Kerberos-Protokoll als Bestandteil von Active
  Directory zur Authentifizierung.

Kernel
: Der Kernel (deutsch: Betriebssystemkern) ist der zentrale Bestandteil eines
  Betriebssystems.
  Er ist zuständig für die Verwaltung der Ressourcen, wie Hauptspeicher, Ein-
  und Ausgabegeräte, CPU-Zeit.
  Er bildet die unterste Schicht des Betriebssystem und hat meist direkten
  Zugriff auf die Hardware.

Kernel-Oops
: Ein Oops ist eine Abweichung vom korrekten Verhalten des Linux-Kernels, die
  eine Lognachricht erzeugt.
  Wenn der Kernel ein Problem entdeckt, schreibt er eine Oops-Nachricht und
  beendet die am Problem beteiligten Prozesse.

Kernel Panic
: Eine Kernel Panic ist eine Fehlermeldung des Kernels bei einem gravierendem
  Problem, auf Grund dessen keine Möglichkeit besteht, das System kontrolliert
  weiter zu betreiben.
  Bei einer Kernel Panic wird das System angehalten.

{#glossar-kommandozeile}
Kommandozeile
: Jedes UNIX-Programm erhält beim Aufruf eine Reihe von positionsabhängigen
  Parametern.
  Diese werden als Zeichenreihen übergeben, welche jeweils durch das Zeichen
  `\0` abgeschlossen werden.
  Beim Aufruf eines Programms aus einer Shell kann die Kommandozeile aus einer
  oder mehreren Textzeilen zusammengebaut werden.
  In [Kapitel 4](#sec-unix-programmschnittstellen) gehe ich im Rahmen der
  Programmschnittstellen auf die Kommandozeile ein.

Korrelation
: Eine Korrelation beschreibt eine Beziehung zwischen zwei Merkmalen,
  Ereignissen oder Zuständen.
  Ob die Beziehung kausal ist und falls ja, wie, geht aus der Korrelation
  nicht hervor.

Latenz
: Die Latenz bezeichnet in Computer-Netzwerken die Zeit zwischen dem Senden
  eines Datenpaketes und der Ankunft beim Empfänger.
  Zusammen mit der maximalen Datenübertragungsrate ist sie eine wesentliche
  Kenngröße eines Übertragungsweges.

LDAP
: Das *Lightweight Directory Access Protocol* erlaubt die Abfrage und die
  Modifikation von Informationen eines Verzeichnisdienstes über ein
  IP-Netzwerk.
  Die aktuelle Version ist in den RFCs 4510 und 4511 beschrieben.

Link
: Ein Link ist ein Verweis auf einen [Inode](#glossar-inode) in einem
  Dateisystem.
  Die meisten Links sind Einträge in [Dateisystemen](#glossar-dateisystem),
  die einen Namen in einem Verzeichnis mit einem Inode verknüpfen,
  diese werden auch Hardlinks genannt.
  Neben den Hardlinks gibt es symbolische Links, auch Softlink genannt, die
  nicht auf einen Inode verweisen, sondern auf einen anderen Dateinamen.
  Für weitere Informationen zu Dateien, Verzeichnissen und Links
  [siehe Kapitel 4](#sec-linux-grundlagen-dateien).

Live-System
: Mit diesem Begriff bezeichnet man ein Betriebssystem, das ohne Installation
  und ohne Beeinflussung des Inhalts einer eingebauten Festplatte gestartet
  werden kann.
  Üblicherweise wird ein Live-System auf einer CD-ROM oder einem USB-Stick
  installiert und über die Firmware von dort gestartet.

{#glossar-log}
Log, Logdatei, Logfile
: Traditionell werden die Systemnachrichten auf Linux-Systemen als
  Textdateien mit zeilenweisen Einträgen geführt.
  Diese Zeilen enthalten neben der Nachricht das Datum und die Uhrzeit,
  den Namen oder die Adresse des Rechners und den Namen und die PID des
  Prozesses, der die Lognachricht erzeugte.
  Damit nicht alle Programme dieselbe Datei zum Schreiben öffnen müssen, gibt
  es auf den Systemen einen [Syslog](#glossar-syslog)-Dienst, dem sie die
  Lognachrichten mittels Bibliotheksfunktionen übergeben.
  Dabei kann den Nachrichten eine Priorität und ein Bereich zugewiesen
  werden.

Magic SysRequest
: Als Magic SysRequest bezeichnet man eine Reihe von Tastenkombinationen mit
  der Taste `Druck/S-Abf`, über die sich verschiedene Funktionen des Kernels
  aufrufen lassen, solange dieser noch nicht abgestürzt ist.
  In [Kapitel 5](#sec-lokal-total-magic-sysrq) gehe ich auf eine Möglichkeit
  ein, mit Hilfe des Magic SysRequest ein hängendes System sicher neu zu
  starten.

{#glossar-mac}
Mandatory Access Control, MAC
: Wenn in einem System die Regeln für die Zugangsrechte zentral und zwingend
  vorgegeben werden, spricht man von Mandatory Access Control (deutsch:
  zwingend erforderliche Zugangskontrolle). Dem gegen über steht die
  benutzerbestimmbare Zugangskontrolle ([DAC](#glossar-dac)), die dem Nutzer
  selbst das Festlegen der Zugangsregeln zu Dateien und Verzeichnissen
  erlaubt.
  In [Kapitel sechs](#sec-lokal-zugriffsrechte) gehe ich näher auf
  verschiedene Optionen der Zugangskontrolle bei Linux ein.

Master Boot Record, MBR
: Der MBR ist der erste Sektor eines Speichermediums, welches sich in
  Partitionen aufteilen läßt, wie zum Beispiel eine Festplatte.
  Dieser enthält eine Tabelle, die die Aufteilung des Mediums beschreibt und
  optional für Computer mit BIOS einen Bootloader, der den Betriebssystemstart
  einleiten kann.

{#glossar-mount-point}
Mount-Point
: Alle für Benutzer zugänglichen Dateisysteme sind bei UNIX und Linux in einem
  Dateibaum zusammengefasst.
  Der Mount-Point (deutsch: Einhängepunkt) ist die Stelle im Dateibaum, an der
  ein Dateisystem den Nutzern zur Verfügung gestellt wird.
  Der erste Mount-Point ist */*.
  Ein Dateisystem kann nur bei einem Verzeichnis eingehängt werden, enthält
  dieses Verzeichnis Einträge, werden diese vom eingehängten Dateisystem
  verdeckt.

Multicast
: Eine Multicast-Nachricht wird an eine Gruppe von Teilnehmern in einem Netz
  gesendet.
  Siehe auch *Unicast* und *Broadcast*.

Netflow
: Netflow ist eine ursprünglich von Cisco entwickelte Technik um Informationen
  über die Datenströme an einem Gateway zu einem Sammelpunkt für das
  Monitoring zu senden.
  Damit sind detailliertere Auswertungen möglich, die unter anderem auch zur
  Performanceanalyse verwendet werden können.

Netzsegment
: Der Begriff wird auf den verschiedenen OSI-Ebenen für unterschiedliche
  Abgrenzungen verwendet:
  *   auf Schicht 1 bezeichnet er das gemeinsame physische Medium, zum
      Beispiel das Koaxialkabel einer 10Base2-Verbindung, alle per Hub
      verbundenen Rechner einer 10BaseT-Verbindung oder zwei per TP-Kabel
      verbundene Rechner.
  *   auf Schicht 2 bezeichnet er die Netze an beiden Ports einer Bridge oder
      allen gemeinsamen Ports eines Switches
  *   auf Schicht 3 bezeichnet er ein Subnetz oder Netzbereich

NFS
: Das *Network File System*, ursprünglich von Sun Microsystems entwickelt,
  ist ein Protokoll zur Übertragung von Dateien über das Netzwerk.
  Im Gegensatz zu anderen Protokollen zur Dateiübertragung wie FTP oder HTTP
  können Benutzer auf die Dateien so zugreifen, als ob sie auf dem lokalen PC
  gespeichert wären.

NTP
: Das *Network Time Protocol* dient zur Synchronisierung von Uhren in
  Computersystemen über das Netz.
  Die aktuelle Version 4 ist in RFC 5905 beschrieben.

OSI-Modell
: Das *Open Systems Interconnection Model* ist ein Schichtenmodell, welches
  als Entwurfsgrundlage für Kommunikationsprotokolle entwickelt wurde.
  In [Kapitel 9](#sec-osi-modell) gehe ich näher auf dieses Modell ein.

OSPF
: *Open Shortest Path First* ist ein dynamisches Routingprotokoll, das in RFC
  2328 beschrieben ist.

Overlay-Dateisystem
: Von Overlay-Dateisystemen spricht man, wenn mehrere Dateisysteme am selben
  Einhängepunkt im Dateibaum montiert werden. Meist wird ein nur-lesend
  eingehängtes Dateisystem mit einem weiteren Dateisystem kombiniert, welches
  die Schreibzugriffe auf einem anderen Datenträger oder im RAM speichert.
  Bei Lesezugriffen kommen die Daten zunächst aus dem nur-lesend eingehängten
  Dateisystem. Bei einem Schreibzugriff werden die Daten auf den Datenträger
  des zweiten Dateisystems geschrieben und bei nachfolgenden Lesezugriffen von
  dort gelesen.
  Overlay-Dateisysteme werden zum Beispiel bei Livesystemen eingesetzt, die
  von CD-ROM starten und alle Dateiänderungen in den RAM schreiben.

PAC-Datei
: Mit Hilfe einer *Proxy-Auto-Config-Datei* kann ein Webbrowser
  automatisch den passenden Proxyserver für eine gewünschte URL ermitteln.
  In [Kapitel 11](#sec-proxy-auto-config) gehe ich näher auf die
  Funktionsweise automatischen Proxy-Konfiguration ein.

Paging
: Mit Paging bezeichnet man die Speicherverwaltung per Seitenadressierung im
  Betriebssystem.
  Dieser Mechanismus wird auch zur virtuellen Speicherverwaltung verwendet, so
  dass der logische Adressraum größer sein kann als der physisch im Rechner
  vorhandene Speicher.
  Sobald ein Prozess auf eine nicht im physischen Speicher befindliche
  Speicherseite zugreift, wird die entsprechende Speicherseite vom
  Betriebssystem nachgeladen.

PMU
: Die *Performance Monitoring Unit* ist ein Bestandteil moderner CPUs, der in
  verschiedenen Zählern Performancewerte während der Arbeit der CPU sammelt
  und Ereignisse (Interrupts) beim Erreichen von bestimmten Zuständen oder
  Zählerständen auslösen kann.

Partitionstabelle
: Eine Tabelle im MBR, die die Aufteilung des Speichermediums in einzelne
  Partitionen beschreibt.

Peripherie
: Dieser Begriff bezeichnet Geräte, die an einen Computer angeschlossen werden
  können oder sind, aber nicht zur Zentraleinheit gehören.

{#glossar-programm}
Programm
: Ein Programm ist eine Folge von Anweisungen, die den Regeln einer
  Programmiersprache genügen und es einem Computer ermöglichen,
  eine bestimmte Aufgabe zu bewältigen.
  Dabei unterscheidet man Programme im Maschinencode, die nach dem Laden
  in den Arbeitsspeicher direkt vom Prozessor des Computers abgearbeitet
  werden können, von Programmen in "höheren" Programmiersprachen, die vor der
  Abarbeitung durch den Prozessor erst in Maschinencode übersetzt werden oder
  durch spezielle Programme interpretiert werden.
  In [Kapitel 4](#sec-unix-prozessmodell) gehe ich näher auf den Zusammenhang
  von Programmen und Prozessen ein.

{#glossar-prozess}
Prozess
: Im Betriebssystem ist ein Prozess ein Vorgang der Informationsverarbeitung.
  Dieser benötigt Rechenzeit an mindestens einem Prozessor, ein Programm,
  dessen Anweisungen er ausführt, Speicherplatz für temporäre Daten und einen
  Kontext, der unter anderem auf die verarbeiteten Daten verweist.
  Der Prozess wird durch das Programm gesteuert und durch den Kontext und die
  verarbeiteten Daten beeinflusst.
  [Kapitel 4](#sec-unix-prozessmodell) geht näher auf das UNIX-Prozessmodell
  ein.

PXE, Preboot Execution Environment
: PXE ist eine Erweiterung zum Starten von Rechnern über Rechnernetze.
  Diese nutzt die Protokolle DHCP zum Übertragen von Bootinformationen und
  TFTP zum Übertragen von Dateien, wie zum Beispiel Betriebssystemimages.

QoS
: *Quality of Service*, deutsch auch Dienstgüte, beschreibt, wie gut ein
  Dienst aus Anwendersicht ist.
  In IP-Netzen wird QoS üblicherweise mit den Parametern Latenz, Jitter,
  Paketverlustrate und Datendurchsatz erfasst.

RAID
: Ein *Redundand Array of Independent Disks* ist eine Kombination von mehreren
  Festplatten zu einem logischen Laufwerk um eine bessere Datenverfügbarkeit
  bei Ausfall einzelner Platten und/oder einen größeren Datendurchsatz zu
  erreichen.

{#glossar-regulaere-datei}
reguläre Datei
: Eine reguläre Datei enthält permanente Daten, die als Bitfolge in einem
  [Dateisystem](#glossar-dateisystem) auf einem Datenträger
  gespeichert werden.
  Die Verwaltungsinformationen für die Datei werden in einem
  [Inode](#glossar-inode) abgelegt.
  Ein und dieselbe reguläre Datei kann mehrere Namen haben, die als Link auf
  den zugehörigen Inode in den [Verzeichnissen](#glossar-verzeichnis) des
  Dateisystems geführt werden.
  In [Kapitel 4](#sec-linux-grundlagen-dateien) gehe ich auf die Zusammenhänge
  von Dateien und Verzeichnissen detaillierter ein.

Rescue-System
: Ein Rescue-System ist ein [Live-System](#glossar-live-system), dass
  zur Wiederherstellung von beschädigten Betriebssystemen geeignet ist.

RIP, RIP2
: Das *Routing Information Protocol* ist ein dynamisches Routingprotokoll.
  Heute wird meist Version 2 dieses Protokolls eingesetzt, die in RFC 2453
  beschrieben ist.

Router
: Ein Router verbindet mehrere Teilnetze miteinander und trifft Entscheidungen
  über die Weiterleitung von Datenpaketen anhand ihrer Zieladresse.

RTT
: Die *Round Trip Time*, deutsch Paketumlaufzeit, gibt die Zeit an, die ein
  Datenpaket benötigt um in einem Rechnernetz von der Quelle zum Ziel und
  zurück zu kommen.
  Das Programm `ping` weist diese aus.
  Die RTT allein reicht nicht zur Bewertung der Qualität des Netzes, da die
  RTT von mehreren Faktoren beeinflusst wird.
  Eine Änderung der RTT kann aber auf außergewöhnliche Umstände im Netz
  deuten.

SAS
: *Serial Attached SCSI* ist ein Nachfolger der parallelen SCSI-Schnittstelle.
  Dieses umgeht das Problem von parallelen Schnittstellen, dass die
  Signallaufzeiten der einzelnen Adern nicht zu stark differieren dürfen,
  dadurch, dass eine Leitung mit serieller Schnittstelle verwendet wird.

SATA
: *Serial-ATA* oder auch *Serial Advanced Technology Attachment* wurde aus dem
  älteren ATA-Standard entwickelt, um höhere Datenraten zu erreichen und die
  Kabelführung zu vereinfachen.

SCSI
: Das *Small Computer System Interface* ist eine parallele Schnittstelle für
  die Verbindung von Peripheriegeräten und Computer-Bus.

Shell
: Die Shell ist ein interaktives Programm, über das der Benutzer mit dem
  Computer kommuniziert und spezielle Programme startet.
  In den meisten Fällen versteht man unter einer Shell das Programm, dass
  nach dem Anmelden an einer Text-Konsole oder via SSH gestartet wird und
  eine Kommandozeile zur Bedienung präsentiert.
  Im erweiterten Sinn sind auch grafische Benutzeroberflächen Shells.

Sicherungsschicht (OSI-Modell)
: Die Sicherungsschicht ist die zweite Schicht des OSI-Modells für
  Netzwerkprotokolle.
  Sie regelt den Zugriff auf das Übertragungsmedium und sorgt für eine
  zuverlässige Datenübertragung über das Medium.

Signal
: Ein Signal ist eine primitive Form der Kommunikation zwischen Prozessen.
  Um ein Signal zu senden, wird der *kill()* Systemaufruf beziehungsweise in
  der Kommandozeile der *kill* Befehl verwendet.
  Der sendende Prozess benötigt bestimmte Rechte, um einem anderen Prozess ein
  Signal zu senden.
  Im Rahmen des UNIX-Prozessmodells gehe ich in
  [Kapitel 4](#sec-unix-prozessmodell) näher auf Signale ein.

SMTP
: Das *Simple Mail Transfer Protocol* dient dem Versenden und Weiterleiten
  von E-Mail in Computernetzen.
  Das Protokoll ist textbasiert und in RFC 5321 beschrieben.

SNMP
: Das *Simple Network Management Protocol* dient der Überwachung und Steuerung
  von Netzwerkelementen von einer zentralen Station aus.
  Es ist unter anderem in den RFCs 1157 und 3410 beschrieben.

Standardausgabe, -eingabe, fehlerausgabe
: Diese drei Standard-Datenströme im Betriebssystem UNIX werden auch *STDIN*,
  *STDOUT* und *STDERR* genannt.
  Beim Start von Programmen werden diesen Datenströmen die Dateideskriptoren
  0, 1 und 2 zugeordnet.
  An einem Textterminal ist STDIN meist mit der Tastatur verbunden und STDOUT
  und STDERR mit dem Display.

  Programme , die als Filter in einer Pipe verkettet werden, lesen ihre
  Eingabe von STDIN und schreiben die verarbeiteten Daten nach STDOUT und
  Fehlermeldungen nach STDERR.
  In den gängigen Shells können diese Datenströme durch Eingabeumleitung
  (`<`), Ausgabeumleitung (`>`) oder Verknüpfung (`|`) mit Dateien oder
  Programmen verbunden werden.
  In [Kapitel 4](#sec-unix-programmschnittstellen) gehe ich bei den
  Programmschnittstellen näher auf die Datenströme ein.

Swap, Swapping
: Wenn ein bestimmter Speicherbereich eines Prozesses längere Zeit nicht
  benutzt wurde, kann er auf Festplatte ausgelagert werden, um Speicherplatz
  für andere Prozesse zu gewinnen.
  Wird der Speicher später wieder benötigt, wird er von der Platte  in den RAM
  geladen.
  Diesen Vorgang nennt man Swapping.

{#glossar-syslog}
Syslog
: Der Syslog-Dienst auf einem Rechner nimmt am UNIX-Socket */dev/log*
  [Lognachrichten](#glossar-log) entgegen und schreibt sie entsprechend
  seiner Konfiguration, der Priorität und dem Bereich in Dateien im
  Verzeichnis */var/log/*.
  Einige Syslog-Dämonen schreiben die Lognachrichten stattdessen in
  Datenbanken oder in Ringpuffer im Hauptspeicher.
  Letztere sind vor allem für Systeme mit geringen Ressourcen interessant,
  verlieren aber ältere Nachrichten, wenn der Ringpuffer voll ist und neue
  Nachrichten kommen.
  Zusätzlich besteht die Möglichkeit, das der Syslog-Dämon über UDP-Port 514
  Lognachrichten an andere Rechner sendet oder von anderen Rechnern
  entgegennimmt.

Tail-Merging, Tail-Packing
: Traditionell waren die kleinsten Einheiten in Dateisystemen Blöcke mit einer
  Größe, die ein Vielfaches von 512 ist.
  Da die Größe einer Datei nicht immer ein ganzes Vielfaches von 512 ist, war
  der letzte Block in einer Datei oft nicht vollständig belegt.
  Wenn ein Dateisystem viele kleine Dateien enthält oder die Blockgröße
  größer als 512 ist, kann der Anteil des nicht genutzten Speicherplatzes
  ziemlich groß werden.
  Aus diesem Grund werden bei manchen Dateisystemen die letzten Bytes
  verschiedener Dateien in gemeinsamen Blöcken gespeichert.
  Das nennt man Tail-Merging oder Tail-Packing.

TCP
: Das *Transmission Control Protocol* ist ein paketvermitteltes, zuverlässiges
  und verbindungsorientiertes Protokoll zur Datenübertragung.
  In [Kapitel 9](#sec-tcp-grundlagen) gehe ich auf einige Eigenschaften dieses
  Protokolls ein.

TFTP
: Das **Trivial File Transfer Protocol** ist ein sehr einfaches
  Dateiübertragungsprotokoll.
  Es unterstützt nur das Lesen und Schreiben von Dateien.

Thrashing
: Damit bezeichnet man den Zustand, wenn ein Betriebssystem beim
  [Paging](#glossar-paging) die meiste Zeit mit dem Nachladen und Auslagern
  von Speicherseiten beschäftigt ist.
  Der Prozessor verbringt die meiste Zeit im Wartezustand und die verfügbare
  Rechenleistung ist deutlich herabgesetzt.

Traffic-Shaping
: Traffic-Shaping ist eine Möglichkeit in IP-Netzwerken QoS zu gewährleisten.
  Dabei werden bestimmte Datenpakete vorrangig behandelt beziehungsweise ein
  bestimmte Datenübertragungsrate reserviert.

UDP
: Das *Universal Datagram Protocol* ist ein minimales verbindungsloses
  Protokoll zur Datenübertragung.
  Es gibt keine Gewähr, dass die Daten überhaupt, oder in der Reihenfolge
  ankommen, in der sie gesendet werden.

Umgebungsvariablen
: Neben den Variablen, die ein Programm beim Aufruf in der
  [Kommandozeile](#glossar-kommandozeile) übergeben bekommt, erhält es weitere
  Variablen in der Aufrufumgebung.
  Im Unterschied zur Kommandozeile, deren Variablen über ihre Position
  verwendet werden, werden Umgebungsvariablen über ihren Namen identifiziert.
  [Kapitel 4](#sec-unix-programmschnittstellen) geht im Rahmen der
  Programmschnittstellen auf Umgebungsvariablen ein.

Unicast
: Eine Unicast-Nachricht geht vom Sender zu genau einem Empfänger.
  Vergleiche hierzu *Multicast* und *Broadcast*.

Vermittlungsschicht (OSI-Modell)
: Die Vermittlungsschicht ist die dritte Schicht im OSI-Modell für
  Netzwerkprotokolle.
  Sie sorgt bei paketorientierten Diensten für die Weiterleitung von
  Datenpaketen und bei leitungsorientierten Diensten für das Schalten von
  Verbindungen.
  In beiden Fällen geht die Datenübertragung über das gesamte Netz und
  schließt die Wegesuche ein.

{#glossar-verzeichnis}
Verzeichnis
: Ein Verzeichnis ist eine spezielle Art von Dateien in einem
  [Dateisystem](#glossar-dateisystem), die nur Dateinamen, gepaart mit der
  Referenz auf die zugehörigen [Inodes](#glossar-inode) enthalten.
  [Kapitel 4](#sec-linux-grundlagen-dateien) dieses Buches geht näher auf das
  Verhältnis von Dateien und Verzeichnissen in Dateisystemen ein.

VGA
: **Video Graphics Array** ist ein Computergrafik-Standard, der
  bestimmte Kombinationen von Bildauflösung und Farbanzahl sowie
  Bildwiederholfrequenz definiert.

Virtualisierung
: Virtualisierung bezeichnet die Erzeugung von virtuellen, das heißt nicht
  physikalischen Dingen wie einer emulierten Hardware, Datenspeichers oder
  Netzwerkanschlusses.

WPAD
: Mit dem *Web Proxy Autodiscovery Protocol* können Web-Clients (Browser) zu
  verwendende Proxy-Server automatisch finden, wenn die PAC-Datei unter einer
  definierten URL zu erreichen ist.
  In [Kapitel 11](#sec-proxy-auto-config) gehe ich näher auf die
  Funktionsweise automatischen Proxy-Konfiguration ein.


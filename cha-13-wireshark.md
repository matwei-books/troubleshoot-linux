
## wireshark {#sec-netz-werkzeuge-wireshark}

Neben tcpdump verwende ich sehr gern Wireshark zur Auswertung von
Paketmitschnitten. Da dieses Werkzeug mit einer grafischen
Benutzeroberfläche daherkommt, habe ich es zwar auf kaum einem Server
installiert, aber wegen der bequemen Handhabung setze ich es sehr gern zur
Auswertung von Paketmitschnitten auf meiner Arbeitsstation ein. Und, wen es
sich ergibt, auch zum Mitschneiden der Datenpakete.

Im Netz finden sich einige Tutorials zum Einsatz von Wireshark, darum gehe
ich hier nur kurz auf die Menüpunkte ein, die ich am häufigsten einsetze.

### Analyze > Expert Info Composite

Einen ersten Überblick über einen geladenen oder mit Wireshark erzeugten
Paketmitschnitt bekomme ich über den
Menüeintrag **Analyze > Expert Info Composite**.
In dem daraufhin geöffneten Fenster sind fünf Panels über die Reiter
`Errors`, `Warnings`, `Notes`, `Chats` und
`Details` zu erreichen. Die ersten vier Panels enthalten Bemerkungen
von Wiresharks zu Ereignissen mit der Wichtung entsprechend dem zugehörigen
Reiter. Im Panel `Details` finde ich noch einmal alle Bemerkungen in
der Reihenfolge, in der sie im Paketmitschnitt vorkommen. Praktisch ist, das
beim Anklicken einer Notiz das zugehörige Datenpaket im Hauptfenster
ebenfalls gleich ausgewählt wird.

### Statistics > Conversations

Über den Menüeintrag **Statistics > Conversations** bekomme ich ebenfalls
ein Fenster mit mehreren Panels, die über Reiter wie `Ethernet`,
`IPv4`, `IPv6`, `TCP`, `UDP`, ..., jeweils gefolgt
von einer Zahl, ausgewählt werden. Dabei sind nur die Reiter aktiv, für die
Wireshark Konversationen (das heisst Datenaustausch mit dem entsprechenden
Protokoll) identifizieren konnte. Die Zahl gibt die Anzahl der verschiedenen
Konversationen an.

Im Panel ist dann eine Liste mit einer Zeile pro Konversation und den
zugehörigen Parametern zu sehen. Über das Kontextmenü kann man die
entsprechende Konversation zu einem Displayfilter für das Hauptfenster
hinzufügen oder einferben.
  
Bei TCP und UDP kann man auch `Follow Stream` anwählen um in einem
weiteren Fenster die Nutzdaten der Verbindung zu sehen und zu speichern.
Dieses Feature von Wireshark ist vor allem dadurch praktisch, weil
Paketwiederholungen automatisch herausgerechnet werden un man so bequem an
die Nutzdaten herankommt.

### Statistics > IO Graphs

Über diesen Menüeintrag bekomme ich einen grafischen Überblick über den
zeitlichen Ablauf des Datenverkehrs. Hier kann ich mit Filtern einzelne
Aspekte farblich hervorheben.

### Hauptfenster

Bleibt schließlich die Paketliste im Hauptfenster.

Mit Displayfiltern kann ich die angezeigten Datenpakete einschränken. Es
lassen sich Zeitreferenzpunkte für eine genauere Analyse des Zeitverhaltens
setzen.

Auch hier habe ich die Möglichkeit, über das Kontextmenü und
**Follow Stream** an die Nutzdaten zu kommen.

Und vor allem kann ich für jedes Datenpaket die verschiedenen
Protokollschichten auf und zu klappen und  brauch die entsprechenden
Protokollparameter nicht aus dem Hexdump selbst zu ermitteln.


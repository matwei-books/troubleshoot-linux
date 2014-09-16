
## Wireshark {#sec-netz-werkzeuge-wireshark}

Neben `tcpdump` und den `libtrace-tools` arbeite ich oft mit `wireshark` zur
Auswertung von Paketmitschnitten.
Da dieses Werkzeug mit einer grafischen Benutzeroberfläche daherkommt, habe
ich es auf kaum einem Server installiert, wegen der bequemen
Handhabung verwende ich es aber gern zur Auswertung von Paketmitschnitten auf
meiner Arbeitsstation.
Und, wenn es sich ergibt, auch zum Mitschneiden der Datenpakete.

Im Internet finden sich etliche Tutorials zum Einsatz von Wireshark, darum gehe
ich hier nur kurz auf die Menüpunkte ein, die ich am häufigsten einsetze.

### Analyze > Expert Info Composite

Einen ersten Überblick über einen geladenen oder mit Wireshark erzeugten
Paketmitschnitt bekomme ich über den
Menüeintrag **Analyze > Expert Info Composite**.
In dem daraufhin geöffneten Fenster sind fünf Panels über die Reiter
*Errors*, *Warnings*, *Notes*, *Chats* und *Details* zu erreichen.
Die ersten vier Panels enthalten Bemerkungen von Wiresharks zu Ereignissen
mit der Priorisierung entsprechend dem zugehörigen Reiter.
Im Panel *Details* finde ich noch einmal alle Bemerkungen in der
Reihenfolge, in der sie im Paketmitschnitt vorkommen.
Praktisch ist, das beim Anklicken einer Notiz das zugehörige Datenpaket
im Hauptfenster gleich ausgewählt wird.

### Statistics > Conversations

Über den Menüeintrag **Statistics > Conversations** bekomme ich ebenfalls
ein Fenster mit mehreren Panels, die ich über Reiter wie *Ethernet*,
*IPv4*, *IPv6*, *TCP*, *UDP*, ..., jeweils gefolgt von einer Zahl,
auswählen kann.
Dabei sind nur die Reiter aktiv, für die Wireshark Konversationen, das
heisst Datenpakete mit dem entsprechenden Protokoll, identifizieren konnte.
Die Zahl gibt die Anzahl der verschiedenen Konversationen an.

Im Panel ist dann eine Liste mit einer Zeile pro Konversation und den
zugehörigen Parametern zu sehen.
Über das Kontextmenü kann ich die entsprechende Konversation als
Displayfilter für das Hauptfenster hinzufügen oder einfärben.
  
Bei TCP und UDP kann ich auch *Follow Stream* anwählen, um in einem
weiteren Fenster die Nutzdaten der Verbindung zu sehen und zu speichern.
Dieses Feature von Wireshark ist vor allem dadurch praktisch, weil es
Paketwiederholungen automatisch heraus rechnet und ich so bequem an
die Nutzdaten herankomme.

### Statistics > IO Graphs

Über diesen Menüeintrag bekomme ich einen grafischen Überblick über den
zeitlichen Ablauf des Datenverkehrs.
Hier kann ich mit Filtern einzelne Aspekte farblich hervorheben.

### Hauptfenster

Bleibt schließlich die Paketliste im Hauptfenster.

Mit Displayfiltern kann ich die angezeigten Datenpakete einschränken.
Außerdem kann ich Zeitreferenzpunkte setzen, für eine Analyse des
Zeitverhaltens.

Auch hier habe ich die Möglichkeit, über das Kontextmenü und
*Follow Stream* an die Nutzdaten heranzukommen.

Und vor allem kann ich für jedes Datenpaket die verschiedenen
Protokollschichten auf- und zuklappen und  brauche die entsprechenden
Protokollparameter nicht selbst aus dem Hexdump zu ermitteln.


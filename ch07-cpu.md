
## Engpass CPU

Habe ich festgestellt, dass die CPU den Engpass des Systems bildet, dann will
ich als nächstes wissen, was sie gerade macht.
Mit `vmstat` habe ich nicht nur herausbekommen, dass die CPU bremst, sondern
auch, ob sie mehr im Userland, das heißt mit dem Code des Benutzerprogramms
und den Bibliotheken, oder mehr im Systembereich, also mit dem Kernelcode,
beschäftigt ist.

Außerdem kann ich an Hand der Anzahl der Interrupts und Kontextwechsel
einschätzen, ob die CPU vorwiegend mit wenigen Prozessen zu tun hat oder
oft zwischen verschiedenen Programmen hin und her springt.
Im letzteren Fall kann das Abschalten einiger Dienste zu einer spürbaren
Entlastung führen.

Welche Prozesse die meiste Rechenzeit benötigen, ermittle ich mit `top` und
`ps`.
Dabei setze ich `top` ein, um interaktiv die Prozesse mit der meisten
Systemzeit zu finden.
Mit `ps` sortiere ich die Prozesse wie folgt:

{line-numbers=off,lang="text"}
    $ ps k-%cpu
      PID TTY      STAT   TIME COMMAND
     4288 ?        Sl     1:16 /usr/lib/firefox/firefox
     3578 tty7     Rs+    0:39 /usr/bin/X :0 -auth ...
     4086 ?        Sl     0:08 gnome-terminal
     ...
     5212 pts/3    R+     0:00 ps k-%cpu -e
     5213 pts/3    S+     0:00 less

Habe ich im Moment keine Möglichkeit, weitere Dienste zu beenden, kann ich mit
`renice` den Scheduler anweisen, bestimmte Prozesse höher oder niedriger zu
priorisieren, so dass er diesen mehr oder weniger Rechenzeit zuteilt.

Langfristig kann ich mit Systemaccounting den Ressourcenbedarf der einzelnen
Programme festhalten und diesen für weitere Entscheidungen heranziehen.
Dabei muss ich bedenken, dass die Accounting-Programme zwar den
Ressourcenbedarf mehr oder weniger gut erfassen und Hilfe für die allgemeine
Dimensionierung des Rechners geben können, aber im konkreten Überlastfall
keine direkte Hilfe bieten.
Sie können im Nachhinein zeigen, ob bestimmte Programme mehr Ressourcen als
üblich benötigt haben oder häufiger als sonst gelaufen sind.
Außerdem benötigen die Accounting-Programme selbst Ressourcen und tragen auf
diese Weise mit zum Problem bei.

Einige Programme lassen sich so konfigurieren, dass sie weniger Ressourcen
verbrauchen.
Da ich dazu keine allgemeinen Hinweise geben kann, verweise ich auf die
Dokumentation der entsprechenden Software.
Ist das nicht möglich, kann ich das Programm vielleicht durch ein anderes
ersetzen, welches weniger Ressourcen benötigt.

Bei modernen Prozessoren habe ich oft die Möglichkeit, die Taktfrequenz der
CPU per Software zu manipulieren.
Falls die CPU momentan nicht mit der maximal möglichen Taktfrequenz arbeitet,
kann ich diese mit den *cpufrequtils* bei einem Engpass kurzfristig anheben.
Das Programm `cpufreq-info` zeigt mir Informationen zur aktuellen und zu
einstellbaren Taktfrequenzen.
Mit `cpufreq-set` ändere ich die Einstellungen.

Schließlich habe ich noch die Möglichkeit, durch Hardware-Erweiterungen das
System zu beschleunigen.
Eine oder mehrere zusätzliche CPU, schnellere CPU oder Hardware-Beschleuniger
für Verschlüsselungen können das Problem mitunter eliminieren.

Eventuell muss ich die Dienste des Systems auf mehrere Maschinen verteilen.
Das kann ich auf verschiedene Art machen: ich kann mehrere gleich
konfigurierte Systeme nehmen und die Last zwischen diesen aufteilen, ich
kann die verschiedenen Teilaufgaben auf verschiedene Maschinen verteilen, zum
Beispiel eine Maschine für die Verschlüsselung, eine für die Anwendung und
eine für die Datenbank. Und natürlich kann ich beide Formen gleichzeitig
verwenden und mischen.

### Performance Monitoring Unit der CPU

Seit Jahren gibt es in den Prozessoren Performance-Counter,
spezielle Zähler in der Performance Monitoring Unit (PMU) der CPU.
Diese ermitteln Leistungsdaten, die ich zur Analyse der Laufeigenschaften von
Programmen einsetzen kann.

Da die Mechanismen von CPU zu CPU unterschiedlich sind, gab es lange keine
einheitliche Schnittstelle unter Linux, um diese Daten zu nutzen.

Mit `perf` gibt es nun jedoch ein Werkzeug, das eine einheitliche
Schnittstelle für den Zugang zu diesen Daten bietet. In dem Artikel
[[ctHM2013](#bib-ct-hm2013)] geben die Autoren einen Einblick in die
Funktionsweise der Performance-Counter und die Anwendung von `perf`.
Weitere Hinweise und ein Tutorial kann ich im
[Perf Wiki](https://perf.wiki.kernel.org/) finden.


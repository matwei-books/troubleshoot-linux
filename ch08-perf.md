
## Perf

Seit Jahren gibt es in den Prozessoren Performance-Counter,
spezielle Zähler, die performance- und verhaltensrelevante Daten ermitteln,
mit denen die Laufzeiteigenschaften von Programmen analysiert werden können.

Da die Mechanismen von CPU zu CPU unterschiedlich sind, gab es lange Zeit keine
einheitliche Schnittstelle unter Linux, um diese Daten zu nutzen.

Mit `perf` gibt es nun ein Werkzeug, das eine einheitliche
Schnittstelle für den Zugang zu diesen Daten bietet.
Dieses Werkzeug besteht aus zwei Teilen: dem Kernelcode für
den Zugriff auf die Daten und dem Programm zur Auswertung.

Da beide Teile eng gekoppelt sind, werden die Quellen des Programms `perf`
zusammen mit dem Kernelcode geführt.
Baue ich meinen Kernel selbst, brauche ich lediglich im Unterverzeichnis
*tools/perf/* den Befehl `make` aufrufen, um das für diesen Kernel passende
Programm zu erhalten.
In den verschiedenen Distributionen finde ich `perf` in eigenen Paketen, die
von der Kernelversion abhängig sind, bei Debian oder Ubuntu beispielsweise in
*linux-tools*.

Das Grundprinzip funktioniert so, dass von der CPU verwaltete Zählerregister
auf bestimmte Messereignisse programmiert werden können.
Bei Erreichen eines Maximalwertes wird ein Interrupt ausgelöst, der zum Aufruf
eines Handlers führt, welcher den aktuellen Wert des Befehlszählers in einem
Ringpuffer speichert.
Das Analyseprogramm wertet den Ringpuffer aus und stellt den Bezug vom
Befehlszählerinhalt zu den CPU-Befehlen an dieser Stelle her.

Dadurch ergibt sich ein geringer Overhead bei der Beobachtung der Programme
und diese können auch innerhalb von Funktionen beobachtet werden.
Allerdings kann es vorkommen, dass der ermittelte Wert des Befehlszählers auf
Grund von Verzögerungen bis zum Aufruf des Handlers nicht exakt ist.
Diesen Umstand darf ich bei der Analyse nicht aus den Augen lassen.

Neben Hardwarezählern stellt `perf` auch Softwarezähler aus dem Kernel
für die Auswertung zur Verfügung.
Damit kann ich global oder eingeschränkt auf eine Task oder eine
*cgroup* messen.

### Aufruf des Programmes

Ich kann das Programm `perf` auf eine der folgenden Arten verwenden:

{line-numbers=off,lang="text"}
    $ perf stat [$optionen] $programm

Bei diesem Aufruf startet `perf` das Programm `$programm`, sammelt
Performancedaten und gibt diese nach Beendigung des Programms aus.

{line-numbers=off,lang="text"}
    # perf top [$optionen]

So gibt das Programm laufend aktualisierte Daten aus, ähnlich dem Programm
`top` für Prozesse.
Dafür benötige ich erweiterte Rechte.
Ich kann das Programm als *root* aufrufen, oder über
*/proc/sys/kernel/perf_event_paranoid* die Einstellungen für `perf` lockern.

{line-numbers=off,lang="text"}
    $ perf record [$optionen] $programm

Dieser Aufruf ist ähnlich dem von `perf stat`, allerdings werden die
Performancedaten nicht ausgegeben, sondern in der Datei  *perf.data*
gespeichert.

{line-numbers=off,lang="text"}
    $ perf report [$optionen]

Zeigt die in *perf.data* gespeicherten Daten an.

{line-numbers=off,lang="text"}
    $ perf list [$optionen]

Damit zeigt `perf` alle bekannten symbolischen Ereignistypen an.

Details finden sich, wie gewöhnlich, in den Handbuchseiten, die für die oben
genannten fünf Aufrufe auch via 

{line-numbers=off,lang="text"}
    $ perf help $befehl

angesehen werden können.

Im Perf Wiki gibt es ein englischsprachiges
[Tutorial](https://perf.wiki.kernel.org/index.php/Tutorial), das den Einsatz
von `perf` anhand von Beispielläufen erläutert.


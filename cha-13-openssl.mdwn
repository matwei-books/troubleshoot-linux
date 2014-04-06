
## openssl s_client {#sec-netz-werkzeuge-openssl}

Openssl s_client ist das dritte Werkzeug, welches ich zu Verbindungstests
verwende. Dabei handelt es sich um einen generischen SSL/TLS Client, mit dem
ich verschlüsselte Protokolle wie HTTPS, SSMTP, und so weiter und die
entsprechenden Server testen kann.

### Aufruf

Der Grundlegende Aufruf sieht wie folgt aus:

    $ openssl s_client -connect host:port [ options ]
  
### Optionen

Die folgenden Optionen verwende ich hin und wieder, weitere gibt es wie
fast immer in den Handbuchseiten.

-connect host:port
: Baut eine SSL- oder TLS-Verbindung zu dem angegebenen Server und Port auf.

-crlf
: Setzt den Zeilenvorschub des Terminals in CR+LF, wie für
  einige Protokolle gefordert, um.

-quiet
: Unterdrückt die Ausgabe der Zertifikatinformationen.

starttls proto
: sendet die Protokollspezifischen Befehle um eine
  Verbindung auf TLS umzuschalten. Für `proto` sind momentan nur die
  folgenden Protokolle erlaubt: `smtp`, `pop3`, `imap`, `ftp`.

Bei Problemen mit der Aushandlung des SSL-Protokolls kann man mit den
Optionen `-bugs`, `-ssl2`, `-ssl3`, `-tls`, `-no_ssl2`, ... experimentieren.
Details finden sich in der Handbuchseite.

### Beispiel

Das folgende Beispiel zeigt eine HTTP-Abfrage mit openssl:

    $ openssl s_client -connect encrypted.example.net:443 -quiet
    depth=0 CN = encrypted.example.net
    verify error:num=18:self signed certificate
    verify return:1
    depth=0 CN = encrypted.example.net
    verify return:1
    GET / HTTP/1.0
    Host: encrypted.example.net
    
    HTTP/1.1 200 OK
    Date: Fri, 05 Apr 2013 09:39:20 GMT
    Server: Apache
    Vary: Accept-Encoding
    Content-Length: 709
    Connection: close
    Content-Type: text/html;charset=UTF-8
    
    <!DOCTYPE HTML PUBLIC ``-//W3C//DTD HTML 3.2 Final//EN''>
    <html>
    <head>
    <title>Index of /</title>
    </head>
    <body>
    <h1>Index of /</h1>
    ...
    <address>Apache Server at encrypted.example.net Port 443</address>
    </body></html>


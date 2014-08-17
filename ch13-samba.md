
## Samba, smbclient {#sec-netz-werkzeuge-smbclient}

Die Programme der Samba-Suite, insbesondere die zum Paket smbclient
zusammengefassten, können bei der Fehlersuche in Zusammenhang mit MS Windows
Rechnern helfen.

Konkret handelt es sich dabei um die folgenden Programme

findsmb
: liefert Informationen über Maschinen, die auf SMB
  Namensanfragen in einem Netz antworten

rpcclient
: führt MS-RPC-Funktionen aus

smbcacls
: erfragt oder setzt ACLs auf NTFS Dateien oder Verzeichnissen

smbclient
: ist ein FTP-ähnliches Programm um auf SMB/CIFS-Ressourcen
  auf Servern zuzugreifen

smbcquota
: dient zum Setzen und Abfragen der Quotas von NTFS Freigaben

smbget
: kann, ähnlich `wget` für HTTP, Dateien mit dem SMB-Protokoll herunterladen

smbtar
: ist ein Shellskript, mit dem SMB/CIFS-Freigaben direkt auf
  UNIX Bandlaufwerke gesichert werden können

smbtree
: ist eine Art textbasierter SMB Netzwerkbrowser

smbspool
: kann eine Druckdatei an einen SMB Drucker senden

### findsmb

Aufruf:

{line-numbers=off,lang="text"}
    $ findsmb [ broadcast_address ]

Das Programm listet die IP Adresse, den NetBIOS-Namen, den Namen der
Arbeitsgruppe, des Betriebssystem und der SMB-Server-Version. Bei einem
lokalen Masterbrowser wird ein `+` hinzugefügt, bei einem Domain
Masterbrowser ein `*`.

### rpcclient

Das Programm wurde ursprünglich entwickelt, um die MS-RPC-Funktionalität in
Samba zu testen. Es ist möglich, damit Windows NT Clients von
UNIX-Arbeitsstationen aus zu administrieren. Und das Programm läßt sich gut
in Skripten verwenden.
  
Für nähere Informationen schaue ich in die Handbuchseiten.

### smbclient

Das ist ein Client-Programm mit dem ich auf SMB- oder CIFS-Ressourcen auf
Servern zugreifen kann. Das Interface ist ähnlich dem Programm `ftp`
für den Zugriff auf FTP-Server.

Damit kann ich Dateien vom Server holen, auf dem Server ablegen und
Verzeichnisinformationen bekommen.

So kann ich zum Beispiel mit dem Aufruf

{line-numbers=off,lang="text"}
    $ smbclient -L hostname -N

anonym alle Dienste des Servers `hostname` abfragen.
  
### smbget

Mit diesem  Programm kann ich Dateien von Servern mit dem SMB-Protokoll
abholen, ähnlich wie mit dem Programm wget für das HTTP-Protokoll. Die
Dateien werden als smb-URL angegeben.
Eine smb-URL sieht wie folgt aus:

{line-numbers=off,lang="text"}
    smb://[[[dom;]usr[:pas]@]host[/share[/path[/file]]]]

Für Informationen zu den möglichen Optionen schaue ich in die Handbuchseite.

### smbtree

Dieses Programm gibt eine Baumstruktur als Text aus, die alle bekannten Domains,
die Server in diesen Domains und die Freigaben auf diesen Servern auflistet.
Das sieht in etwa so aus:

{line-numbers=off,lang="text"}
    $ smbtree -N
    WORKGROUP1
    \\HOST1             host1 server (Samba, Ubuntu)
      \\HOST1\bilder         	
      \\HOST1\psc_1100 HEWLETT-PACKARD OFFICEJET
      \\HOST1\IPC$     IPC Service (host1 server (Samba))
      \\HOST1\print$   Printer Drivers
    WORKGROUP2
    \\HOST2             Samba 3.5.6
      \\HOST2\public
      \\HOST2\share
      \\HOST2\IPC$     IPC Service (Samba 3.5.6)


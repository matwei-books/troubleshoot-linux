# Hinweise zum Übersetzen

## verschiedene Versionen

    make VERSION=abstracts
    make VERSION=abstractstext
    make VERSION=text
    make VERSION=textnotes
    make VERSION=final

Die Versionen abstractstext, text, textnotes können mit ONLY=dateiname,...
kombiniert werden. Zum Beispiel erzeugt

    make VERSION=textnotes ONLY=tl-netz-totalausfall

nur den Text von Kapitel 10 mit den Notizen.

# Hinweise zum Übersetzen

## Konvertieren in Markdown

### \verb?...? durch `...` ersetzen

    perl -pi.bak -e 's/\verb(.)(.+?)\1//g' chapter04.mdwn 

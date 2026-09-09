#!/usr/bin/env bash
set -u
spiel="$1"; ordner=/tmp/ansible-kurs/level4
hier="$(cd "$(dirname "$spiel")" && pwd)"
rm -rf "$ordner"

# Die Musterlösung bringt ihre eigene Rolle mit; die Aufgabe benutzt
# die Rolle unter rollen/.
if [[ "$(basename "$spiel")" == loesung.yml ]]; then
  pfad="$hier/loesung_rolle"
else
  pfad="$hier/rollen"
fi

ausgabe="$(cd "$hier/.." && ANSIBLE_ROLES_PATH="$pfad" ansible-playbook "$spiel" 2>&1)"
pruefe "4.0 Playbook läuft ohne Fehler" "$(grep -c 'failed=[1-9]' <<<"$ausgabe")" "0"
pruefe "4.1 Verzeichnis der Rolle"   "$([ -d "$ordner" ] && echo da)" "da"
pruefe "4.2 Vorlage gefüllt"         "$(sed -n 's/^name = //p' "$ordner/dienst.conf" 2>/dev/null)" "kursdienst"
pruefe "4.4 Port von außen gesetzt"  "$(sed -n 's/^port = //p' "$ordner/dienst.conf" 2>/dev/null)" "9443"
pruefe "4.4 Knoten von außen gesetzt" \
  "$(sed -n 's/^[0-9]* = //p' "$ordner/dienst.conf" 2>/dev/null | tr '\n' ' ')" "eins zwei drei "
pruefe "4.3 Name aus defaults"       "$(cat "$ordner/name.txt" 2>/dev/null)" "kursdienst"
pruefe "4.2 Handler hat ausgelöst"   "$(cat "$ordner/neustart.marke" 2>/dev/null)" "neu gestartet"

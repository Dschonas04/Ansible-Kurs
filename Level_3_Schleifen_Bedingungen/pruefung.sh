#!/usr/bin/env bash
set -u
spiel="$1"; ordner=/tmp/ansible-kurs/level3
rm -rf "$ordner"
ausgabe="$(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" 2>&1)"
pruefe "3.0 Playbook läuft ohne Fehler" "$(grep -c 'failed=[1-9]' <<<"$ausgabe")" "0"
pruefe "3.1 drei Verzeichnisse aus einem Task" \
  "$(ls -d "$ordner"/alpha "$ordner"/beta "$ordner"/gamma 2>/dev/null | wc -l)" "3"
pruefe "3.2 drei Konfigurationen" \
  "$(cat "$ordner"/web.conf "$ordner"/api.conf "$ordner"/mail.conf 2>/dev/null | tr '\n' ' ')" \
  "port = 80 port = 8080 port = 25 "
pruefe "3.3 Bedingung auf os_family" "$(cat "$ordner/familie.txt" 2>/dev/null)" "Debian"
pruefe "3.4/3.5 Größe aus register" "$(cat "$ordner/groesse.txt" 2>/dev/null)" "$(wc -c < "$ordner/web.conf" 2>/dev/null)"
pruefe "3.6 Handler hat ausgelöst" "$(cat "$ordner/marke.txt" 2>/dev/null)" "geaendert"

# Zweiter Lauf: nichts ändert sich, also darf der Handler NICHT laufen.
rm -f "$ordner/marke.txt"
(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" >/dev/null 2>&1)
pruefe "3.6 Handler bleibt ohne Änderung aus" \
  "$([ -e "$ordner/marke.txt" ] && echo gelaufen || echo ruhig)" "ruhig"

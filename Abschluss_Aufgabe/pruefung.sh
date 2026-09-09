#!/usr/bin/env bash
set -u
spiel="$1"; ordner=/tmp/ansible-kurs/abschluss
rm -rf "$ordner"
ausgabe="$(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" 2>&1)"
pruefe "Abschluss: läuft ohne Fehler" "$(grep -c 'failed=[1-9]' <<<"$ausgabe")" "0"
pruefe "Abschluss: Grundverzeichnis 0755" "$([ -d "$ordner" ] && stat -c '%a' "$ordner")" "755"
pruefe "Abschluss: drei Verzeichnisse" \
  "$(ls -d "$ordner"/web "$ordner"/api "$ordner"/alt 2>/dev/null | wc -l)" "3"
pruefe "Abschluss: web.conf aus Vorlage" \
  "$(cat "$ordner/web/dienst.conf" 2>/dev/null | tr '\n' '|')" \
  "name = web|port = 80|rechner = $(hostname -s)|"
pruefe "Abschluss: api hat Port 8080" \
  "$(sed -n 's/^port = //p' "$ordner/api/dienst.conf" 2>/dev/null)" "8080"
pruefe "Abschluss: alt bleibt ohne Konfiguration" \
  "$([ -e "$ordner/alt/dienst.conf" ] && echo da || echo weg)" "weg"
pruefe "Abschluss: Übersicht" "$(cat "$ordner/uebersicht.txt" 2>/dev/null)" "web, api"
pruefe "Abschluss: Handler gelaufen" "$(cat "$ordner/ausgeliefert.txt" 2>/dev/null)" "fertig"

zweiter="$(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" 2>&1)"
pruefe "Abschluss: zweiter Lauf ändert nichts" \
  "$(sed -n 's/.*changed=\([0-9]*\).*/\1/p' <<<"$zweiter" | tail -1)" "0"

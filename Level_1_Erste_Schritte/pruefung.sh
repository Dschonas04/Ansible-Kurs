#!/usr/bin/env bash
set -u
spiel="$1"
ordner=/tmp/ansible-kurs/level1
rm -rf /tmp/ansible-kurs
mkdir -p "$ordner"; : > "$ordner/alt.txt"

ausgabe="$(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" 2>&1)"
pruefe "1.0 Playbook läuft ohne Fehler" \
  "$(grep -c 'failed=[1-9]' <<<"$ausgabe")" "0"
pruefe "1.1 Verzeichnis mit Rechten 0755" \
  "$([ -d "$ordner" ] && stat -c '%a' "$ordner")" "755"
pruefe "1.2 notiz.txt mit richtigem Inhalt" \
  "$(cat "$ordner/notiz.txt" 2>/dev/null)" "Ansible beschreibt Zustand."
pruefe "1.3 leer.txt ist da und leer" \
  "$([ -f "$ordner/leer.txt" ] && wc -c < "$ordner/leer.txt")" "0"
pruefe "1.4 alt.txt ist weg" \
  "$([ -e "$ordner/alt.txt" ] && echo da || echo weg)" "weg"

# Der zweite Lauf darf nichts mehr ändern.
zweiter="$(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" 2>&1)"
geaendert="$(sed -n 's/.*changed=\([0-9]*\).*/\1/p' <<<"$zweiter" | tail -1)"
pruefe "1.5 zweiter Lauf ändert nichts (Idempotenz)" "${geaendert:-x}" "0"

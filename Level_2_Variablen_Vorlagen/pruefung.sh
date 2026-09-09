#!/usr/bin/env bash
set -u
spiel="$1"; ordner=/tmp/ansible-kurs/level2
rm -rf "$ordner"
ausgabe="$(cd "$(dirname "$spiel")/.." && ansible-playbook "$spiel" 2>&1)"
pruefe "2.0 Playbook läuft ohne Fehler" "$(grep -c 'failed=[1-9]' <<<"$ausgabe")" "0"
pruefe "2.2 Knoten verbunden und groß" "$(cat "$ordner/namen.txt" 2>/dev/null)" "ALPHA, BETA, GAMMA"
pruefe "2.3 Anzahl der Knoten"        "$(cat "$ordner/anzahl.txt" 2>/dev/null)" "3"
pruefe "2.1/2.4 Hostname aus den Fakten" "$(cat "$ordner/rechner.txt" 2>/dev/null)" "$(hostname -s)"
pruefe "2.5 Vorlage gefüllt: Port"    "$(sed -n 's/^port = //p' "$ordner/dienst.conf" 2>/dev/null)" "9090"
pruefe "2.5 Vorlage gefüllt: Knoten"  "$(sed -n 's/^anzahl = //p' "$ordner/dienst.conf" 2>/dev/null)" "3"
pruefe "2.5 Vorlage kennt das Inventar" "$(sed -n 's/^umgebung = //p' "$ordner/dienst.conf" 2>/dev/null)" "kurs"
pruefe "2.6 Vorgabewert gegriffen"    "$(cat "$ordner/port.txt" 2>/dev/null)" "8080"

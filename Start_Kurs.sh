#!/usr/bin/env bash
# Interaktives Menü durch den Kurs. Starten mit:  ./Start_Kurs.sh
set -uo pipefail
cd "$(dirname "$0")"

FETT=$'\e[1m'; GRAU=$'\e[90m'; AUS=$'\e[0m'
[ -t 1 ] || { FETT=""; GRAU=""; AUS=""; }

zeige() {
  printf '\n%s══ %s ══%s\n\n' "$FETT" "$1" "$AUS"
}

while true; do
  zeige "Ansible-Kurs"
  ordner=(Level_*/ Abschluss_Aufgabe/)
  for i in "${!ordner[@]}"; do
    printf '  %d) %s\n' "$((i + 1))" "${ordner[$i]%/}"
  done
  printf '  p) alles prüfen\n  q) beenden\n\n'
  read -r -p "Auswahl: " wahl
  case "$wahl" in
    q|Q) exit 0 ;;
    p|P) ./pruefen.sh; read -r -p $'\nWeiter mit Enter…' _ ;;
    ''|*[!0-9]*) printf 'Bitte eine Zahl, p oder q.\n' ;;
    *)
      auswahl="${ordner[$((wahl - 1))]:-}"
      [ -n "$auswahl" ] || { printf 'Gibt es nicht.\n'; continue; }
      while true; do
        zeige "${auswahl%/}"
        printf '  1) Theorie und Aufgabenstellung lesen\n  2) Beispiel ausführen\n  3) Übung im Editor öffnen\n'
        printf '  4) Aufgabe prüfen\n  5) Musterlösung zeigen\n  z) zurück\n\n'
        read -r -p "Auswahl: " unter
        case "$unter" in
          1) ${PAGER:-less} "$auswahl"/{theorie.txt,Aufgabenstellung.txt} 2>/dev/null || true ;;
          2) bash "$auswahl/beispiel.yml"; read -r -p $'\nWeiter mit Enter…' _ ;;
          3) ${EDITOR:-nano} "$auswahl/uebung.yml" ;;
          4) nummer="$(sed -n 's/^Level_\([0-9]*\).*/\1/p' <<<"$auswahl")"
             ./pruefen.sh "${nummer:-alle}"; read -r -p $'\nWeiter mit Enter…' _ ;;
          5) ${PAGER:-less} "Loesungen/${auswahl%/}.yml" ;;
          z|Z) break ;;
        esac
      done
      ;;
  esac
done

#!/usr/bin/env bash
# ================================================================
#  Prüfer für den Ansible-Kurs.
#
#  Er sagt dir nach jeder Aufgabe, ob sie stimmt -- das ist der
#  Unterschied zwischen "ich habe etwas hingeschrieben" und "ich
#  habe es verstanden".
#
#    ./pruefen.sh          alle Level
#    ./pruefen.sh 3        nur Level 3
#    ./pruefen.sh --loesung  prüft die Musterlösungen (sollte alles
#                            grün sein; zeigt, dass der Prüfer stimmt)
# ================================================================
set -uo pipefail
cd "$(dirname "$0")"

GRUEN=$'\e[32m'; ROT=$'\e[31m'; GRAU=$'\e[90m'; FETT=$'\e[1m'; AUS=$'\e[0m'
[ -t 1 ] || { GRUEN=""; ROT=""; GRAU=""; FETT=""; AUS=""; }

gesamt=0; gut=0

# pruefe <Name> <Ist> <Soll>   -- steht den Prüfskripten zur Verfügung
pruefe() {
  local name="$1" ist="$2" soll="$3"
  gesamt=$((gesamt + 1))
  if [ "$ist" = "$soll" ]; then
    gut=$((gut + 1))
    printf '  %s✓%s %s\n' "$GRUEN" "$AUS" "$name"
  else
    printf '  %s✗%s %s\n' "$ROT" "$AUS" "$name"
    printf '     %serwartet:%s %s\n' "$GRAU" "$AUS" "$(printf '%q' "$soll")"
    printf '     %sbekommen:%s %s\n' "$GRAU" "$AUS" "$(printf '%q' "$ist")"
  fi
}
export -f pruefe 2>/dev/null || true

welche="${1:-alle}"
modus="uebung"
[ "$welche" = "--loesung" ] && { modus="loesung"; welche="alle"; }

for ordner in Level_*/ Abschluss_Aufgabe/; do
  [ -f "$ordner/pruefung.sh" ] || continue
  nummer="$(sed -n 's/^Level_\([0-9]*\).*/\1/p' <<<"$ordner")"
  [ "$welche" != "alle" ] && [ "$welche" != "$nummer" ] && continue

  printf '\n%s%s%s\n' "$FETT" "${ordner%/}" "$AUS"
  if [ "$modus" = loesung ]; then
    ziel="Loesungen/${ordner%/}.yml"
  else
    ziel="${ordner}uebung.yml"
  fi
  if [ ! -f "$ziel" ]; then
    printf '  %s✗%s %s fehlt\n' "$ROT" "$AUS" "$ziel"
    gesamt=$((gesamt + 1))
    continue
  fi
  if [ "$modus" = uebung ] && grep -q 'tasks: \[\]' "$ziel"; then
    printf '  %s·%s %s ist noch leer.\n' "$GRAU" "$AUS" "$ziel"
  fi
  # Das Prüfskript läuft in dieser Shell, damit es pruefe und die
  # Zähler sieht.
  source "$ordner/pruefung.sh" "$ziel"
done

printf '\n%s%d von %d Aufgaben stimmen.%s\n' "$FETT" "$gut" "$gesamt" "$AUS"
[ "$gut" -eq "$gesamt" ] || exit 1

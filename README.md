# Ansible-Kurs

Ansible in vier Leveln, mit einem Prüfer, der nach jeder Aufgabe sagt,
ob sie stimmt.

Alles läuft **gegen den eigenen Rechner**. Es gibt keinen SSH-Zugriff auf
fremde Maschinen, geschrieben wird ausschließlich unter `/tmp/ansible-kurs`.

## Aufbau

Jedes Level hat vier Dateien:

| Datei          | Zweck                                        |
| -------------- | -------------------------------------------- |
| `theorie.txt`  | Konzepte lesen und verstehen                 |
| `beispiel.yml` | Lauffähiges Playbook zum Ausprobieren        |
| `aufgabe.yml`  | Selbst lösen, Lücken mit `___` ausfüllen     |
| `loesung.yml`  | Musterlösung, erst nach dem eigenen Versuch  |

## Los geht es

```bash
./Start_Kurs.sh          # Menü durch alle Level
./pruefen.sh             # alles prüfen
./pruefen.sh 2           # nur Level 2
./pruefen.sh --loesung   # prüft die Musterlösungen, muss grün sein
```

Ein Playbook von Hand ausführen:

```bash
ansible-playbook Level_1_Erste_Schritte/beispiel.yml
```

## Level

| Level                                          | Thema                                      |
| ---------------------------------------------- | ------------------------------------------ |
| [Level 1](Level_1_Erste_Schritte/)              | Playbook, Module, Idempotenz               |
| [Level 2](Level_2_Variablen_Vorlagen/)          | Variablen, Fakten, Filter, Jinja2-Vorlagen |
| [Level 3](Level_3_Schleifen_Bedingungen/)       | loop, when, register, Handler              |
| [Level 4](Level_4_Rollen/)                      | Rollen, defaults, Struktur                 |
| [Abschluss](Abschluss_Aufgabe/)                 | eine kleine Auslieferung, alles zusammen   |

## Was der Prüfer zusätzlich prüft

Bei mehreren Aufgaben läuft das Playbook **zweimal**. Der zweite Lauf muss
`changed=0` melden. Das ist der Unterschied zwischen einem Playbook und
einem Skript in YAML-Schreibweise: Ansible beschreibt einen Zustand, und
wer denselben Zustand zweimal herstellt, hat beim zweiten Mal nichts zu tun.

An derselben Stelle lernt man auch die Ausnahmen kennen -- `file` mit
`state: touch` und jedes `command` melden immer `changed`, solange man es
ihnen nicht abgewöhnt.

## Voraussetzungen

`ansible-core` 2.12 oder neuer. Prüfen mit `ansible --version`.
Installieren etwa mit `pipx install ansible-core` oder aus der
Paketverwaltung.

# Golden Path: First Successful Use Case

Dieser Pfad ist der empfohlene erste End-to-End-Durchlauf.

## Ziel

Du sollst genau **ein kleines, überprüfbares Inkrement** erfolgreich durch das Framework bringen.

## Vorbedingungen

- Tools sind installiert
- `./scripts/check-current-setup.sh` hat keine harten Fehler
- `python3 scripts/validate-framework.py` läuft erfolgreich
- ein Projekt wurde mit `new-ai-app.sh` erzeugt

## Reihenfolge

### 1. Projekt öffnen
```bash
cd ~/dev/my-first-app
opencode
```

### 2. Provider verbinden
```text
/connect
```

### 3. Modell prüfen
```text
/models
```

### 4. Aufgabe normalisieren
```text
/intake add a very small first feature
```

Erwartetes Ergebnis:
- klare Scope-Grenze
- Akzeptanzkriterien
- angenommene Dateien
- empfohlener nächster Schritt

### 5. Plan erzeugen
```text
/plan-feature
```

Erwartetes Ergebnis:
- genau ein kleines Inkrement
- Pflichtprüfungen
- Risiken

### 6. Nur ein kleines Inkrement bauen
```text
/build-small
```

Regel:
Wenn die Änderung groß wirkt, war der Scope vorher zu breit.

### 7. Fehler nur gezielt beheben
```text
/fix
```

Nur nutzen, wenn ein echter Fehler oder ein fehlgeschlagener Check vorliegt.

### 8. Abschluss prüfen
```text
/review-release
```

## Stop-Regeln

Brich den ersten Durchlauf ab und gehe einen Schritt zurück, wenn:
- `/intake` schon mehrere Features gleichzeitig enthält
- `/plan-feature` einen großen Umbau plant
- `/build-small` viele Ordner gleichzeitig ändern will
- die Fehlersuche diffus wird

## Woran du erkennst, dass der Golden Path funktioniert

- die Aufgabe ist klein und verständlich
- der nächste Schritt ist immer klar
- Fehler sind benennbar
- es gibt kein freies Herumprobieren ohne Workflow

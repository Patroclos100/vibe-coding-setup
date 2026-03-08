# Command Map

## Basic-Kommandos

### `/intake`
Nutzen, wenn eine Anforderung noch unscharf ist.

### `/plan-feature`
Nutzen, wenn der Scope nach `/intake` in ein kleines Inkrement übersetzt werden soll.

### `/build-small`
Nutzen, wenn genau ein kleines Inkrement implementiert werden soll.

### `/fix`
Nutzen, wenn ein Build-, Test-, Typ-, Pfad- oder Konfigurationsfehler vorliegt.

### `/review-release`
Nutzen, wenn das Inkrement fachlich und technisch abgeschlossen wirken soll.

### `/status`
Nutzen, wenn unklar ist, wo der aktuelle Arbeitsstand liegt.

## Advanced-Kommandos

Diese Kommandos sind sinnvoll, aber nicht Teil des ersten Einstiegs:
- `/build-large`
- `/refactor-safe`
- Factory-/Module-/Release-Kommandos
- Monitoring- und Quality-Gate-Kommandos

## Wichtigste Regel

Basic nutzt zuerst nur den kleinen Zyklus:

```text
/intake -> /plan-feature -> /build-small -> /fix -> /review-release
```

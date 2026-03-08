# Workflow Guide

## 1. Überblick

VibeCoding Basic lebt von klaren Arbeitsmustern. Die Kommandos sind nur dann nützlich, wenn der Anwendungsfall sauber dazu passt.

## 2. `/plan`

### Wann benutzen?

- bei neuen Anforderungen
- vor mittleren oder großen Änderungen
- bei unklaren Risiken
- vor Architekturentscheidungen

### Wofür geeignet?

- Zerlegung einer Aufgabe
- Risikoanalyse
- Ableitung des kleinsten ersten Schritts

### Wofür nicht?

- direkte Implementierung
- triviale Ein-Zeilen-Änderungen
- spontane Komplettlösungen ohne Dateilesen

### Benötigte Eingaben

- Ziel oder Problem
- relevante Dateien oder Bereiche
- bekannte Randbedingungen

### Erwartetes Ergebnis

- Diagnose des Ist-Zustands
- 5–8 Schritte
- Annahmen und Risiken
- empfohlener erster kleiner Schritt

### Risiken

- zu vage Anforderungen erzeugen vage Pläne
- zu großer Scope wird nur umetikettiert, nicht kleiner

### Danach

- entweder `/build-small`
- oder `/build-large` bei sauber begründeter größerer Änderung

## 3. `/build-small`

### Wann benutzen?

- kleine Änderungen
- klar begrenzte Bugfixes
- einzelne UI- oder Textanpassungen
- eng umrissene Komponentenarbeit

### Wofür geeignet?

- kleinster sinnvoller Inkrementbau
- Änderungen mit niedriger Seiteneffekt-Gefahr

### Wofür nicht?

- große Architekturumbauten
- komplexe Mehrphasen-Features
- unscharf geschnittene Arbeitspakete

### Benötigte Eingaben

- konkrete Änderung
- betroffene Dateien oder Bereiche
- gewünschtes sichtbares Ergebnis

### Erwartetes Ergebnis

- schmale Änderung
- kurze Dateiliste
- ausgeführter Check oder Hinweis darauf

### Risiken

- Scope creep durch „nur noch schnell“
- Vermischung von Fix, Refactor und Feature

### Danach

- `/review`
- bei Bedarf Projektkontext aktualisieren

## 4. `/build-large`

### Wann benutzen?

- mehrere zusammenhängende Dateien betroffen sind
- eine Änderung nicht sinnvoll in nur einen Minischritt passt
- ein Plan bereits vorliegt

### Wofür geeignet?

- kontrollierte Mehrdatei-Änderungen
- Feature-Phase 1

### Wofür nicht?

- erste Reaktion auf vage Anforderungen
- Komplettumbauten ohne Review-Zwischenstopps

### Benötigte Eingaben

- vorhandener Plan
- grobe Teilpakete
- bekannte Grenzen und Risiken

### Erwartetes Ergebnis

- Phasenplan
- Umsetzung nur der ersten Teilpakete
- keine unreviewte Totaländerung

### Risiken

- zu großer Scope in einem Schritt
- versteckte Architekturverschiebung

### Danach

- `/review`
- eventuell Folgephase planen

## 5. `/review`

### Wann benutzen?

- vor Commit
- nach mittleren und großen Änderungen
- wenn Unsicherheit über Qualität besteht

### Wofür geeignet?

- Komplexitätsprüfung
- Dubletten erkennen
- Benennung, UX, Fehlerbehandlung prüfen

### Wofür nicht?

- als Ersatz für Planung
- als kosmetischer Schlussakt ohne echte Kritikbereitschaft

### Benötigte Eingaben

- aktueller Änderungsstand
- betroffene Bereiche
- optional Fokus wie UX, Naming oder Fehlerfälle

### Erwartetes Ergebnis

- Review-Befunde zuerst
- kleinster sicherer Nachschritt danach

### Risiken

- Review wird ignoriert
- Review wird zu spät gemacht, wenn der Scope bereits ausufert

### Danach

- kleine Nachbesserung
- Commit oder nächste kleine Phase

## 6. Optional `/fix`

### Wann benutzen?

- wenn nach Review oder Test ein klar umrissener Mangel besteht

### Wofür geeignet?

- gezielte Fehlerbehebung ohne Scope-Erweiterung

### Wofür nicht?

- als Türöffner für neue Features

## 7. Optional `/status`

### Wann benutzen?

- beim Wiedereinstieg nach Tagen oder Wochen
- bei Übergabe an Dritte

### Erwartetes Ergebnis

- kurzer Überblick aus Projektkontext, offenen Punkten und nächstem sinnvollen Schritt

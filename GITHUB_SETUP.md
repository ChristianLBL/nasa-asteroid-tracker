# Guida Setup Git & GitHub

## 🚀 Inizializzare Git Locale

```bash
# Vai nella directory del progetto
cd /Users/chris/Developer/App/nasa_asteroid_tracker

# Inizializza repository Git
git init

# Aggiungi tutti i file
git add .

# Primo commit
git commit -m "Initial commit: NASA Asteroid Tracker with complete test suite"
```

## 📦 Creare Repository su GitHub

### Opzione 1: Da GitHub Website

1. Vai su [github.com](https://github.com)
2. Clicca su **"+"** → **"New repository"**
3. Imposta:
   - **Repository name**: `nasa-asteroid-tracker`
   - **Description**: `Flutter app to track near-Earth asteroids using NASA's NeoWs API`
   - **Visibility**: Public o Private (a tua scelta)
   - **NON** spuntare "Add README" (abbiamo già il nostro)
   - **NON** spuntare "Add .gitignore" (abbiamo già il nostro)
4. Clicca **"Create repository"**

### Opzione 2: Da GitHub CLI (gh)

```bash
# Installa GitHub CLI (se non l'hai)
brew install gh

# Login
gh auth login

# Crea repo
gh repo create nasa-asteroid-tracker --public --source=. --remote=origin
```

## 🔗 Collegare Repository Locale a GitHub

Dopo aver creato il repo su GitHub:

```bash
# Aggiungi remote
git remote add origin https://github.com/TUO-USERNAME/nasa-asteroid-tracker.git

# Verifica
git remote -v

# Rinomina branch a main (se necessario)
git branch -M main

# Push iniziale
git push -u origin main
```

## 📝 Workflow Git Consigliato

### Commit Regolari
```bash
# Controlla stato
git status

# Aggiungi file modificati
git add .

# Commit con messaggio descrittivo
git commit -m "feat: add new feature X"

# Push su GitHub
git push
```

### Tipi di Commit Consigliati (Conventional Commits)
```bash
git commit -m "feat: nuova funzionalità"
git commit -m "fix: correggi bug"
git commit -m "docs: aggiorna documentazione"
git commit -m "test: aggiungi test"
git commit -m "refactor: refactoring codice"
git commit -m "style: formattazione codice"
git commit -m "chore: aggiorna dipendenze"
```

## 🌿 Branching Strategy (Opzionale)

```bash
# Crea branch per feature
git checkout -b feature/nome-feature

# Lavora sulla feature...
git add .
git commit -m "feat: implementa feature X"

# Torna su main
git checkout main

# Merge feature
git merge feature/nome-feature

# Push
git push
```

## 🏷️ Creare Release/Tag

```bash
# Tag per versione
git tag -a v1.0.0 -m "Release v1.0.0"

# Push tag
git push origin v1.0.0

# Oppure push tutti i tag
git push --tags
```

## 📋 Checklist Pre-Push

Prima di ogni push su GitHub, verifica:

```bash
# 1. Test passano
flutter test

# 2. Nessun errore di analisi
flutter analyze

# 3. Codice formattato
dart format .

# 4. Build funziona
flutter build apk --debug  # Android
flutter build ios --debug  # iOS (solo su macOS)
```

## 🔐 File .env e Secrets

**IMPORTANTE**: Il file `.env` è già nel `.gitignore` e **NON** verrà caricato su GitHub.

### Per collaboratori:

Crea un file `.env.example` con template:

```bash
# Crea template senza secrets
echo "NASA_API_KEY=your_api_key_here" > .env.example
git add .env.example
git commit -m "docs: add .env.example template"
git push
```

Poi nel README aggiungi istruzioni:
> I collaboratori devono creare il proprio `.env` copiando `.env.example` e inserendo la propria API key NASA.

## 📊 GitHub Actions CI/CD (Opzionale Avanzato)

Crea `.github/workflows/flutter-ci.yml`:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.7.0'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
```

## 🎨 README Badges (Opzionale)

Aggiungi badge al README.md:

```markdown
![Flutter](https://img.shields.io/badge/Flutter-3.7.0-blue)
![Tests](https://img.shields.io/badge/tests-24%20passing-brightgreen)
![License](https://img.shields.io/badge/license-MIT-green)
```

## 🔄 Aggiornare da GitHub

```bash
# Scarica ultime modifiche
git pull origin main
```

## ❓ Comandi Git Utili

```bash
# Vedi cronologia commit
git log --oneline

# Vedi differenze
git diff

# Annulla modifiche locali
git checkout -- nome-file

# Annulla ultimo commit (mantiene modifiche)
git reset --soft HEAD~1

# Vedi branch
git branch -a

# Elimina branch locale
git branch -d nome-branch

# Vedi chi ha modificato cosa
git blame nome-file
```

## 🆘 Troubleshooting

### Errore: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/TUO-USERNAME/nasa-asteroid-tracker.git
```

### Errore: "failed to push some refs"
```bash
# Forza push (usa con cautela!)
git push -f origin main
```

### File non viene ignorato nonostante sia in .gitignore
```bash
# Rimuovi dalla cache Git
git rm --cached nome-file
git commit -m "fix: remove ignored file"
git push
```

### Vuoi cambiare l'ultimo messaggio di commit
```bash
git commit --amend -m "Nuovo messaggio"
git push --force
```

## 📱 Repository Esempio

Il tuo repository finale dovrebbe avere questa struttura su GitHub:

```
nasa-asteroid-tracker/
├── .github/
│   └── workflows/         # (opzionale) CI/CD
├── android/
├── assets/
├── integration_test/
├── ios/
├── lib/
├── test/
├── .gitignore            ✅
├── README.md             ✅
├── TEST_GUIDE.md         ✅
├── GITHUB_SETUP.md       ✅
├── pubspec.yaml          ✅
└── LICENSE              (da aggiungere se vuoi)
```

## 📄 Aggiungere Licenza (Opzionale)

Crea file `LICENSE`:

```bash
# MIT License (esempio)
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
EOF

git add LICENSE
git commit -m "docs: add MIT license"
git push
```

---

**Pronto per andare su GitHub!** 🚀

Segui i passi in ordine e il tuo progetto sarà online in pochi minuti.

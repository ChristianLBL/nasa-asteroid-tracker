# NASA Asteroid Tracker

Un'applicazione Flutter per tracciare gli asteroidi vicini alla Terra (NEO - Near-Earth Objects) utilizzando l'API NeoWs della NASA.

## 📱 Funzionalità

### 1. **Feed degli Asteroidi**
- Visualizza asteroidi in transito vicino alla Terra per un intervallo di date selezionato
- Selezione range di date personalizzato (massimo 7 giorni)
- Organizzazione per data con raggruppamento automatico
- Indicatori visivi per asteroidi potenzialmente pericolosi

### 2. **Browse degli Asteroidi**
- Esplora un catalogo generale di asteroidi noti
- Paginazione con 5 asteroidi per pagina
- Navigazione tra pagine con controlli intuitivi

### 3. **Ricerca per ID**
- Cerca asteroidi specifici tramite NASA JPL small body ID
- Esempi: 3542519, 3726710, 2000433
- Validazione input e gestione errori

### 4. **Dettagli Asteroide**
- **Parametri Fisici:**
  - Magnitudine assoluta (H)
  - Diametro stimato (min-max) in chilometri
  - Stato di pericolosità (Potentially Hazardous Asteroid)
  
- **Dati di Avvicinamento (Close Approach):**
  - Data di avvicinamento (completa con ora)
  - Velocità relativa (km/h)
  - Distanza minima dalla Terra (km)
  - Corpo celeste orbitato (generalmente Earth)

### 5. **Space Compass (Bussola Spaziale)**
- Funzionalità interattiva che utilizza i sensori del dispositivo
- Calibrazione automatica della bussola
- Indicatore direzionale per "puntare" verso l'asteroide
- Visualizzazione:
  - Rosa dei venti con direzioni cardinali (N, S, E, W, NE, SE, SW, NW)
  - Heading del dispositivo in tempo reale
  - Indicatore di accuratezza con feedback visivo (verde/giallo/rosso)
  - Distanza simulata dell'asteroide
- Supporto solo per dispositivi con sensore bussola

## 🏗️ Architettura

### Struttura del Progetto

```
lib/
├── main.dart                       # Entry point dell'app
├── models/                         # Modelli di dati
│   └── asteroid.dart              # Classe Asteroid e CloseApproachData
├── providers/                      # State management (Provider)
│   └── asteroid_provider.dart     # Gestione stato asteroidi
├── services/                       # Servizi esterni
│   └── asteroid_service.dart      # Comunicazione con API NASA
├── screens/                        # Schermate dell'app
│   ├── home_screen.dart           # Schermata principale con bottom navigation
│   ├── feed_screen.dart           # Feed asteroidi per date
│   ├── browse_screen.dart         # Browse catalogo asteroidi
│   ├── search_screen.dart         # Ricerca per ID
│   ├── asteroid_detail_screen.dart # Dettagli asteroide
│   └── space_compass_screen.dart  # Bussola spaziale interattiva
├── widgets/                        # Componenti riutilizzabili
│   ├── asteroid_card.dart         # Card per visualizzare asteroide
│   ├── date_range_picker.dart     # Selettore intervallo date
│   ├── loading_widget.dart        # Widget di caricamento
│   └── error_widget.dart          # Widget per errori
└── utils/                          # Utility
    ├── date_utils.dart            # Formattazione date
    └── number_formatter.dart      # Formattazione numeri
```

### Pattern e Tecnologie

#### State Management
- **Provider**: Utilizzato per la gestione dello stato globale dell'applicazione
- `AsteroidProvider`: Gestisce il caricamento e lo stato dei dati degli asteroidi

#### Modelli Dati

**Asteroid:**
- `id`: Identificativo univoco NASA
- `name`: Nome dell'asteroide
- `absoluteMagnitude`: Magnitudine assoluta
- `estimatedDiameterMin/Max`: Diametro stimato in km
- `isPotentiallyHazardous`: Flag di pericolosità
- `closeApproachData`: Lista di avvicinamenti alla Terra

**CloseApproachData:**
- `closeApproachDate`: Data (YYYY-MM-DD)
- `closeApproachDateFull`: Data completa con ora
- `relativeVelocity`: Velocità in km/h
- `missDistance`: Distanza minima in km
- `orbitingBody`: Corpo celeste orbitato

#### Servizi

**AsteroidService:**
- `getFeed(startDate, endDate)`: Ottiene asteroidi per intervallo di date (max 7 giorni)
- `getAsteroid(id)`: Ottiene un singolo asteroide per ID
- `browseAsteroids()`: Ottiene lista generale di asteroidi

## 🔌 API NASA NeoWs

L'app utilizza la [NASA Near Earth Object Web Service (NeoWs)](https://api.nasa.gov/).

### Endpoints Utilizzati

1. **Feed**: `GET /neo/rest/v1/feed`
   - Parametri: `start_date`, `end_date`, `api_key`
   - Limite: massimo 7 giorni di intervallo

2. **Lookup**: `GET /neo/rest/v1/neo/{asteroid_id}`
   - Parametri: `api_key`
   - Restituisce dettagli di un singolo asteroide

3. **Browse**: `GET /neo/rest/v1/neo/browse`
   - Parametri: `api_key`
   - Restituisce lista paginata di asteroidi

### Configurazione API Key

1. Crea un file `.env` nella root del progetto
2. Aggiungi la tua API key NASA:
   ```
   NASA_API_KEY=your_api_key_here
   ```
3. Ottieni una API key gratuita su: https://api.nasa.gov/

**Nota**: L'app utilizza `DEMO_KEY` come fallback, ma ha limitazioni di rate limiting.

## 📦 Dipendenze

### Core
- **flutter**: SDK Flutter
- **provider** (^6.0.5): State management
- **http** (^1.1.0): HTTP requests

### UI/UX
- **flutter_spinkit** (^5.2.0): Animazioni di caricamento
- **cached_network_image** (^3.2.3): Caching immagini
- **url_launcher** (^6.1.12): Apertura URL esterni
- **lottie** (^2.6.0): Animazioni Lottie

### Sensori e Hardware
- **sensors_plus** (^6.1.1): Accesso sensori accelerometro/giroscopio
- **flutter_compass** (^0.8.1): Accesso sensore bussola magnetica
- **vector_math** (^2.1.4): Calcoli vettoriali per rotazioni

### Utilities
- **intl** (^0.18.1): Formattazione date e numeri
- **shared_preferences** (^2.2.0): Storage locale
- **flutter_dotenv** (^5.1.0): Gestione variabili ambiente

### Development
- **flutter_lints** (^5.0.0): Linting e best practices

## 🎨 Design e Tema

### Tema Scuro Spaziale
- Background: Nero con sfondo spaziale
- Colori primari:
  - Cyan Accent (`Colors.cyanAccent`): Elementi interattivi e highlights
  - Indigo (`Colors.indigo`): Colore primario
  - Deep Purple (`Colors.deepPurple.shade400`): Colore secondario

### Componenti Visuali

**AppBar Personalizzate:**
- Sfondo nero con glow cyan
- Icone e titoli con effetto futuristico
- Letterspacing aumentato per look "tech"

**Bottom Navigation:**
- 3 tab: Feed, Browse, Search
- Indicatore attivo con punto cyan
- Bordo superiore con effetto glow

**Cards Asteroidi:**
- Gradient background (rosso per pericolosi, blu per sicuri)
- Badge "Hazardous" per asteroidi pericolosi
- Icone informative per ogni dato
- Effetto InkWell al tap

**Date Range Picker:**
- Selettore personalizzato con stile futuristico
- Limite automatico di 7 giorni
- Validazione date (end date >= start date)

**Space Compass:**
- Rosa dei venti custom con CustomPainter
- Indicatori di direzione cardinale (N, E, S, W)
- Indicatori secondari (NE, SE, SW, NW)
- Tick marks per gradi (ogni 15°, numeri ogni 30°)
- Indicatore asteroide che si muove in base all'orientamento
- Progress bar con codice colore (verde = puntato, giallo = vicino, rosso = lontano)

## 🚀 Setup e Installazione

### Prerequisiti
- Flutter SDK ≥3.7.0
- Dart ≥3.7.0
- Android Studio / Xcode (per emulatori)
- Un editor (VS Code, Android Studio, IntelliJ)

### Passi di Installazione

1. **Clone/Download del progetto**
   ```bash
   cd nasa_asteroid_tracker
   ```

2. **Installa dipendenze**
   ```bash
   flutter pub get
   ```

3. **Configura API Key**
   - Crea file `.env` nella root
   - Aggiungi: `NASA_API_KEY=your_key_here`

4. **Verifica asset**
   - Aggiungi un'immagine di sfondo spaziale in `assets/images/space_background.jpg`
   - (Opzionale) Aggiungi animazioni Lottie in `assets/animations/`

5. **Esegui l'app**
   ```bash
   flutter run
   ```

### Build per Produzione

**Android:**
```bash
flutter build apk --release
# oppure
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📱 Compatibilità

- **Android**: API 21+ (Android 5.0 Lollipop)
- **iOS**: iOS 12.0+
- **Orientamento**: Solo Portrait (verticale)

### Funzionalità Hardware

**Space Compass richiede:**
- Sensore magnetometro (bussola)
- Accelerometro
- Giroscopio

**Nota**: La maggior parte degli smartphone moderni supporta questi sensori. Se non disponibili, l'app mostrerà un messaggio appropriato.

## 🧪 Testing

Il progetto include una suite completa di test:

### Tipi di Test

1. **Unit Tests** (`test/unit/`)
   - Test per models (Asteroid, CloseApproachData)
   - Test per utilities (DateUtils, NumberFormatter)

2. **Widget Tests** (`test/widget/`)
   - Test per widget riutilizzabili (AsteroidCard, LoadingWidget, ErrorWidget)

3. **Integration Tests** (`integration_test/`)
   - Test end-to-end dell'app completa
   - Test della navigazione e flussi utente

### Eseguire i Test

```bash
# Tutti i test (unit + widget)
flutter test

# Solo unit tests
flutter test test/unit/

# Solo widget tests
flutter test test/widget/

# Integration tests (richiede emulatore/device)
flutter test integration_test/app_test.dart

# Con coverage
flutter test --coverage
```

**Per dettagli completi, consulta:** [TEST_GUIDE.md](TEST_GUIDE.md)

## ⚙️ Configurazione

### Orientamento Schermo
L'app forza l'orientamento portrait:
```dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);
```

### Tema e Colori
Modificabili in [main.dart](lib/main.dart) nel `ThemeData.dark().copyWith(...)`.

## 🔍 Troubleshooting

### Problema: API Key non funziona
- Verifica che `.env` sia nella root del progetto
- Verifica che il file contenga `NASA_API_KEY=...`
- Riavvia l'app dopo aver modificato `.env`

### Problema: Space Compass non funziona
- Verifica che il dispositivo abbia un sensore magnetometro
- Calibra la bussola muovendo il telefono a forma di 8
- Alcuni emulatori non supportano sensori reali

### Problema: Immagini di sfondo non si caricano
- Verifica che `assets/images/space_background.jpg` esista
- Verifica che sia dichiarato in `pubspec.yaml` sotto `flutter: assets:`

### Problema: Errore di rete
- Verifica connessione internet
- Verifica che l'API key sia valida
- La DEMO_KEY ha limiti di rate (40 richieste/ora, 1000/giorno)

## 📄 Licenza

Questo progetto è di esempio e utilizza dati pubblici NASA.

## 🙏 Crediti

- **NASA NeoWs API**: https://api.nasa.gov/
- **Flutter Framework**: https://flutter.dev/
- **Icone e Assets**: Material Design Icons

## 📞 Supporto

Per problemi o domande:
1. Verifica la documentazione
2. Controlla gli issue esistenti
3. Consulta la documentazione NASA: https://api.nasa.gov/

---

**Versione**: 1.0.0+1  
**Ultima modifica**: 2025

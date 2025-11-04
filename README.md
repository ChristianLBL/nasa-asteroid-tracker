# AsteroidTracker

App Flutter per tracciare asteroidi vicini alla Terra tramite API NASA NeoWs.

## 🎯 Funzionalità

### 1. Feed Asteroidi
Visualizza asteroidi in transito per intervallo di date (max 7 giorni).

### 2. Browse Catalogo
Esplora catalogo completo asteroidi con paginazione (5 per pagina).

### 3. Ricerca per ID
Cerca asteroidi specifici tramite NASA JPL ID (es: 3542519, 3726710).

### 4. Dettagli Asteroide
- Magnitudine assoluta
- Diametro stimato (km)
- Velocità relativa (km/h)
- Distanza minima Terra (km)
- Flag pericolosità

### 5. Bussola Spaziale
Feature interattiva che usa il magnetometro del telefono per "puntare" verso l'asteroide.

## 🚀 Setup

```bash
flutter pub get
echo "NASA_API_KEY=your_key_here" > .env
flutter run
```

Ottieni API key gratuita: https://api.nasa.gov

## 🏗️ Architettura

```
lib/
├── models/          Asteroid, CloseApproachData
├── providers/       AsteroidProvider (Provider pattern)
├── services/        AsteroidService (HTTP NASA API)
├── screens/         6 schermate UI
├── widgets/         4 widget riutilizzabili
└── utils/           DateUtils, NumberFormatter
```

**State Management:** Provider  
**API:** NASA NeoWs REST v1  
**Sensori:** flutter_compass (magnetometro), sensors_plus

## 📦 Build

```bash
flutter build apk --release
```

APK disponibile in: `build/app/outputs/flutter-apk/app-release.apk`

## 🧪 Test

```bash
flutter test                # Tutti i test
flutter test test/unit/     # Solo unit test
flutter test test/widget/   # Solo widget test
flutter test --coverage     # Con coverage report
```

## 🔧 API Endpoints Usati

- **Feed**: `/neo/rest/v1/feed?start_date=X&end_date=Y`
- **Lookup**: `/neo/rest/v1/neo/{id}`
- **Browse**: `/neo/rest/v1/neo/browse`

## 📱 Requisiti

- Flutter SDK ≥3.5.0
- Android API 21+ / iOS 12.0+
- Sensore magnetometro per Space Compass

## 🎨 Tecnologie

- **UI**: Material Design Dark Theme
- **HTTP**: package:http
- **State**: package:provider
- **Loading**: flutter_spinkit
- **Formatting**: intl
- **Env**: flutter_dotenv
- **Sensors**: flutter_compass, sensors_plus

## 📊 CI/CD

GitHub Actions esegue automaticamente:
- ✅ Unit + Widget tests
- ✅ Build Android APK (artifact disponibile)

https://github.com/ChristianLBL/nasa-asteroid-tracker/actions

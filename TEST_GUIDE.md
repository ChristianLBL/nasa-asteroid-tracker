# Guida ai Test - NASA Asteroid Tracker

Questa guida spiega come eseguire tutti i test del progetto.

## 📋 Tipi di Test Implementati

### 1. **Unit Tests** (Test Unitari)
Testano singole unità di codice isolate (funzioni, metodi, classi).

**Cosa testiamo:**
- `asteroid_model_test.dart` - Parsing JSON del modello Asteroid
- `number_formatter_test.dart` - Formattazione numeri
- `date_utils_test.dart` - Formattazione date

**Ubicazione:** `test/unit/`

### 2. **Widget Tests** (Test dei Widget)
Testano i singoli widget in isolamento.

**Cosa testiamo:**
- `asteroid_card_test.dart` - Card visualizzazione asteroide
- `loading_widget_test.dart` - Widget di caricamento
- `error_widget_test.dart` - Widget errore

**Ubicazione:** `test/widget/`

### 3. **Integration Tests** (Test di Integrazione)
Testano l'app completa end-to-end.

**Cosa testiamo:**
- `app_test.dart` - Flusso completo dell'app, navigazione, interazioni

**Ubicazione:** `integration_test/`

## 🚀 Come Eseguire i Test

### Prerequisiti
```bash
flutter pub get
```

### 1️⃣ Eseguire TUTTI i Test (Unit + Widget)
```bash
flutter test
```

### 2️⃣ Eseguire Solo Unit Tests
```bash
flutter test test/unit/
```

### 3️⃣ Eseguire Solo Widget Tests
```bash
flutter test test/widget/
```

### 4️⃣ Eseguire un Singolo File di Test
```bash
flutter test test/unit/asteroid_model_test.dart
```

### 5️⃣ Eseguire Integration Tests
```bash
# Su dispositivo/emulatore connesso
flutter test integration_test/app_test.dart

# Oppure con driver
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

## 📊 Test con Coverage

Per generare un report di code coverage:

```bash
# Genera coverage
flutter test --coverage

# Visualizza report (richiede lcov installato)
# macOS/Linux:
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Windows:
# Usa un tool come VS Code con l'estensione Coverage Gutters
```

### Installare lcov (opzionale per visualizzare coverage HTML)
```bash
# macOS
brew install lcov

# Ubuntu/Debian
sudo apt-get install lcov
```

## 🎯 Obiettivi di Coverage

Punta ad avere almeno:
- **80%+ coverage** per models e utils
- **70%+ coverage** per widgets
- **60%+ coverage** per screens

## 🔧 Debug dei Test

### Test fallisce? Usa verbose mode:
```bash
flutter test --verbose
```

### Vedere print() durante i test:
```bash
flutter test --plain-name 'nome del test'
```

### Test widget non funziona? Aggiungi pumpAndSettle:
```dart
await tester.pumpAndSettle(); // Aspetta animazioni
```

## 📝 Scrivere Nuovi Test

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Descrizione Gruppo', () {
    test('dovrebbe fare qualcosa', () {
      // Arrange (prepara)
      final value = 42;
      
      // Act (esegui)
      final result = value * 2;
      
      // Assert (verifica)
      expect(result, 84);
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('descrizione test', (WidgetTester tester) async {
    // Build del widget
    await tester.pumpWidget(
      MaterialApp(
        home: MioWidget(),
      ),
    );
    
    // Verifica
    expect(find.text('Testo'), findsOneWidget);
  });
}
```

### Integration Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('flusso completo', (WidgetTester tester) async {
    // Avvia app
    app.main();
    await tester.pumpAndSettle();
    
    // Interazioni
    await tester.tap(find.text('Button'));
    await tester.pumpAndSettle();
    
    // Verifiche
    expect(find.text('Risultato'), findsOneWidget);
  });
}
```

## 🐛 Problemi Comuni

### "No tests found"
- Verifica che i file finiscano con `_test.dart`
- Controlla di essere nella directory corretta

### "MissingPluginException" durante integration test
- Assicurati che un emulatore/dispositivo sia connesso
- Riavvia l'emulatore

### "Null check operator used on a null value"
- Inizializza tutti i mock necessari
- Verifica i parametri required nei widget

### Test lento
- Usa `pumpAndSettle()` con timeout: `pumpAndSettle(Duration(seconds: 2))`
- Mockka le chiamate API invece di farle davvero

## 📚 Best Practices

1. **Nomina i test chiaramente** - Spiega cosa viene testato
2. **Un test = una cosa** - Non testare troppo in un solo test
3. **Arrange-Act-Assert** - Organizza il codice test
4. **Mock le dipendenze esterne** - Non fare chiamate API reali nei test
5. **Test isolati** - Ogni test deve essere indipendente
6. **Test veloci** - I test devono essere rapidi da eseguire

## 🔗 Risorse Utili

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing Guide](https://docs.flutter.dev/testing/integration-tests)

## ✅ Checklist Pre-Commit

Prima di committare su Git:

- [ ] `flutter test` passa senza errori
- [ ] Almeno 70% code coverage
- [ ] Nessun warning nel codice
- [ ] `flutter analyze` non riporta problemi
- [ ] Integration tests passano (se modifiche importanti)

---

**Ultimo aggiornamento:** 2025

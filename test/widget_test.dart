// Parcours complet en mode démo :
//   flutter test --dart-define=DEMO_MODE=true
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:microfinance_mobile/config/app_config.dart';
import 'package:microfinance_mobile/main.dart';
import 'package:microfinance_mobile/services/demo_data.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('fr_FR', null);
  });

  testWidgets('Le splash mène à la connexion', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('TontiFaso'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
  });

  testWidgets('Mode démo : connexion puis tableau de bord rempli', (tester) async {
    if (!AppConfig.demoMode) {
      markTestSkipped('Lancer avec --dart-define=DEMO_MODE=true');
      return;
    }
    await tester.binding.setSurfaceSize(const Size(420, 1800));
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // L'encart démo préremplit les identifiants
    await tester.tap(find.textContaining('Mode démo'));
    await tester.pump();
    expect(find.text(DemoData.email), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Tableau de bord'), findsOneWidget);
    // Solde du membre de démo (187 500 FCFA), affiché dès la première connexion
    expect(find.textContaining('FCFA'), findsWidgets);
    expect(find.textContaining('187'), findsWidgets);
  });

  testWidgets('Mode démo : mauvais identifiants refusés', (tester) async {
    if (!AppConfig.demoMode) {
      markTestSkipped('Lancer avec --dart-define=DEMO_MODE=true');
      return;
    }
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'x@y.bf');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mot de passe'), 'faux');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Tableau de bord'), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}

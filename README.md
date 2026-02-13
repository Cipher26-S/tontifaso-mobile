# MicroFinance Mobile App

Application mobile Flutter pour la gestion de microfinance - Interface membre

## 📱 Fonctionnalités

- ✅ Connexion sécurisée
- ✅ Consultation du solde en temps réel
- ✅ Historique des dépôts
- ✅ Suivi des prêts et remboursements
- ✅ Profil utilisateur
- ✅ Statistiques financières

## 🚀 Installation

### Prérequis

- Flutter SDK (>= 3.0.0)
- Android Studio / Xcode
- Un émulateur ou appareil physique

### Étapes

1. **Cloner le projet**
```bash
git clone <votre-repo>
cd microfinance_mobile
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer l'API Backend**

Modifier `lib/config/app_config.dart` :
```dart
// Pour émulateur Android
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

// Pour émulateur iOS
static const String baseUrl = 'http://localhost:8000/api/v1';

// Pour appareil physique
static const String baseUrl = 'http://VOTRE_IP:8000/api/v1';
```

4. **Lancer l'application**
```bash
flutter run
```

## 📦 Structure du projet
```
lib/
├── config/          # Configuration (API, constantes)
├── models/          # Modèles de données
├── services/        # Services API
├── providers/       # State management (Provider)
├── screens/         # Écrans de l'application
├── widgets/         # Widgets réutilisables
└── main.dart        # Point d'entrée
```

## 🔧 Technologies utilisées

- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: http package
- **Storage**: SharedPreferences
- **Charts**: fl_chart
- **Formatage**: intl

## 📸 Captures d'écran

_À ajouter après les tests_

## 🧪 Tests

Pour tester l'application sans backend :

1. Modifier les services API pour retourner des données de test
2. Ou utiliser un mock server

## 📝 Notes de développement

- L'app utilise `10.0.2.2` pour Android émulateur (qui redirige vers localhost de la machine hôte)
- Pour iOS, utiliser `localhost` directement
- Sur appareil physique, utiliser l'adresse IP locale de votre machine

## 👤 Auteur

Votre nom

## 📄 Licence

Ce projet est sous licence MIT
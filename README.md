# TontiFaso Mobile

> Application mobile Flutter pour les membres d'une tontine / microfinance : solde, épargne, prêts et remboursements, en FCFA.

Client mobile de la plateforme **TontiFaso** (backend PHP). Un **mode démo** intégré permet de l'essayer sans serveur.

## Fonctionnalités

- **Connexion et inscription** des membres (session PHP par cookie)
- **Tableau de bord** : solde, total épargné, prêts en cours et reste à payer
- **Épargne** : historique des dépôts et cotisations
- **Prêts** : liste, détail, taux, durée, progression du remboursement, retards
- **Profil** du membre
- **Mode démo** : données réalistes intégrées, identifiants préremplis d'un clic

## Stack technique

| Couche | Technologies |
|---|---|
| Mobile | Flutter, Dart, Provider |
| Réseau | http, session par cookie `PHPSESSID` |
| Stockage local | shared_preferences |
| Formatage | intl (dates et montants en français) |
| Backend attendu | API PHP TontiFaso (`/backend/auth/*.php`, `/backend/api/*.php`) |

## Structure

```
lib/
├── config/app_config.dart  URL de l'API, endpoints, mode démo
├── models/                 Member, Deposit, Loan
├── providers/              AuthProvider, MemberProvider
├── services/
│   ├── api_service.dart    Appels à l'API TontiFaso
│   └── demo_data.dart      Données du mode démo
└── screens/                login, register, dashboard, deposits, loans, loan_detail, profile
```

## Lancer l'application

**Prérequis** : Flutter SDK 3.x.

```bash
flutter pub get
```

### En mode démo (sans backend)

```bash
flutter run --dart-define=DEMO_MODE=true
```

Identifiants : `demo@tontifaso.bf` / `demo1234` (ou touchez l'encart « Mode démo » sur l'écran de connexion).

### Avec le backend TontiFaso

```bash
flutter run --dart-define=BASE_URL=http://192.168.1.10:8080
```

Remplacez l'adresse par celle du serveur PHP (`http://10.0.2.2:8080` depuis l'émulateur Android).

### Version web de démonstration

```bash
flutter build web --release --dart-define=DEMO_MODE=true
```

## Tests

```bash
flutter test --dart-define=DEMO_MODE=true
```

Les tests rejouent le parcours complet : splash, connexion, tableau de bord rempli, refus des mauvais identifiants.

## Auteur

**Sawadogo Kiswendsida Salif** — Développeur Full-Stack & Mobile
[GitHub](https://github.com/Cipher26-S) · [LinkedIn](https://www.linkedin.com/in/salif-sawadogo-348081375)

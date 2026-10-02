class AppConfig {
  // API Configuration
  // -----------------------------------------------------------------------------
  // IMPORTANT : Pour tester sur VOTRE téléphone avec un backend local :
  // 1. Trouvez l'IP de votre PC (ex: via 'ipconfig' sur Windows).
  // 2. Remplacez l'IP ci-dessous OU utilisez la commande :
  //    flutter run --dart-define=BASE_URL=http://VOTRE_IP:8080
  // -----------------------------------------------------------------------------
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.100.60:8080',
  );

  // Pour l'émulateur Android, l'adresse spéciale est : http://10.0.2.2:8000
  // Pour l'émulateur iOS, l'adresse est : http://localhost:8000

  // Mode démo : données fictives intégrées, aucun backend nécessaire
  //    flutter run --dart-define=DEMO_MODE=true
  static const bool demoMode = bool.fromEnvironment('DEMO_MODE');

  // Endpoints selon la documentation TontiFaso
  static const String loginEndpoint = '/backend/auth/login.php';
  static const String registerEndpoint = '/backend/auth/register.php';
  static const String logoutEndpoint = '/backend/auth/logout.php';
  static const String getDataEndpoint = '/backend/api/get_data.php';
  static const String updateMemberEndpoint = '/backend/api/update_member.php';
  static const String addLoanEndpoint = '/backend/api/add_loan.php';
  static const String addPaymentEndpoint = '/backend/api/add_payment.php';
  static const String addContributionEndpoint =
      '/backend/contributions/add.php';

  // App Info
  static const String appName = 'TontiFaso Mobile';
  static const String appVersion = '1.0.0';

  // Local Storage Keys
  static const String sessionCookieKey = 'phpsessid';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userRoleKey = 'user_role';

  // Colors
  static const int primaryColorValue = 0xFF2E7D32;
  static const int secondaryColorValue = 0xFF1565C0;
  static const int accentColorValue = 0xFFFFA726;
  static const int errorColorValue = 0xFFD32F2F;
  static const int successColorValue = 0xFF388E3C;
}

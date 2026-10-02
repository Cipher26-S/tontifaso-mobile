/// Données fictives utilisées quand l'application est compilée en mode démo
/// (`--dart-define=DEMO_MODE=true`), pour l'essayer sans le backend TontiFaso.
///
/// Le format est celui renvoyé par `/backend/api/get_data.php`.
class DemoData {
  static const String email = 'demo@tontifaso.bf';
  static const String password = 'demo1234';
  static const String memberId = '1';
  static const String memberName = 'Aminata Ouédraogo';

  static String _daysAgo(int days) =>
      DateTime.now().subtract(Duration(days: days)).toIso8601String();

  static Map<String, dynamic> allData() => {
        'members': [
          {
            'id': memberId,
            'first_name': 'Aminata',
            'last_name': 'Ouédraogo',
            'phone': '+226 70 12 34 56',
            'email': email,
            'join_date': _daysAgo(420),
            'balance': 187500,
            'status': 'active',
          },
        ],
        'deposits': [
          for (final d in const [
            [3, 15000, 'Cotisation hebdomadaire'],
            [10, 15000, 'Cotisation hebdomadaire'],
            [17, 25000, 'Épargne vente de karité'],
            [24, 15000, 'Cotisation hebdomadaire'],
            [31, 10000, 'Cotisation hebdomadaire'],
            [45, 50000, 'Épargne campagne agricole'],
            [60, 15000, 'Cotisation hebdomadaire'],
            [75, 42500, 'Dépôt initial'],
          ])
            {
              'id': 'd${d[0]}',
              'memberId': memberId,
              'amount': d[1],
              'date': _daysAgo(d[0] as int),
              'description': d[2],
              'status': 'completed',
            },
        ],
        'loans': [
          {
            'id': 'l1',
            'memberId': memberId,
            'principal': 150000,
            'interestRate': 10,
            'durationMonths': 6,
            'startDate': _daysAgo(90),
            'endDate': DateTime.now().add(const Duration(days: 90)).toIso8601String(),
            'paidAmount': 82500,
            'status': 'active',
            'description': 'Achat de matériel de couture',
          },
          {
            'id': 'l2',
            'memberId': memberId,
            'principal': 75000,
            'interestRate': 8,
            'durationMonths': 3,
            'startDate': _daysAgo(240),
            'endDate': _daysAgo(150),
            'paidAmount': 76500,
            'status': 'completed',
            'description': 'Fonds de roulement commerce',
          },
        ],
      };
}

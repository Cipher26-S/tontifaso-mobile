class Member {
  final String id;
  final String name;
  final String phone;
  final String email;
  final DateTime joinDate;
  final double balance;
  final String status;

  Member({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.joinDate,
    required this.balance,
    this.status = 'active',
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    // Adapter selon la structure de TontiFaso
    final firstName = json['firstName'] ?? json['first_name'] ?? '';
    final lastName = json['lastName'] ?? json['last_name'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    
    return Member(
      id: json['id']?.toString() ?? json['memberId']?.toString() ?? '',
      name: fullName.isNotEmpty ? fullName : (json['fullname'] ?? json['name'] ?? 'Membre'),
      phone: json['phone'] ?? json['telephone'] ?? '',
      email: json['email'] ?? '',
      joinDate: json['join_date'] != null
          ? DateTime.parse(json['join_date'])
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'join_date': joinDate.toIso8601String(),
      'balance': balance,
      'status': status,
    };
  }
}
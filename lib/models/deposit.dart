class Deposit {
  final String id;
  final String memberId;
  final double amount;
  final DateTime date;
  final String description;
  final String status;

  Deposit({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.date,
    this.description = '',
    this.status = 'completed',
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id']?.toString() ?? '',
      memberId: json['memberId']?.toString() ?? json['member_id']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
      description: json['description'] ?? json['note'] ?? '',
      status: json['status'] ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'status': status,
    };
  }
}
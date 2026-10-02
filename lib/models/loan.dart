class Loan {
  final String id;
  final String memberId;
  final double amount;
  final double interestRate;
  final int durationMonths;
  final DateTime startDate;
  final DateTime? endDate;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String status;
  final String? description;

  Loan({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.interestRate,
    required this.durationMonths,
    required this.startDate,
    this.endDate,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.remainingAmount,
    this.status = 'active',
    this.description,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    final principal = double.tryParse(json['principal']?.toString() ?? json['amount']?.toString() ?? '0') ?? 0.0;
    final rate = double.tryParse(json['interestRate']?.toString() ?? json['interest_rate']?.toString() ?? '0') ?? 0.0;
    final duration = int.tryParse(json['durationMonths']?.toString() ?? json['duration']?.toString() ?? '0') ?? 0;
    
    // Calcul intérêt simple
    final interest = principal * (rate / 100) * (duration / 12);
    final total = principal + interest;
    final paid = double.tryParse(json['paidAmount']?.toString() ?? json['paid_amount']?.toString() ?? '0') ?? 0.0;
    
    return Loan(
      id: json['id']?.toString() ?? '',
      memberId: json['memberId']?.toString() ?? json['member_id']?.toString() ?? '',
      amount: principal,
      interestRate: rate,
      durationMonths: duration,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : (json['start_date'] != null ? DateTime.parse(json['start_date']) : DateTime.now()),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : (json['end_date'] != null ? DateTime.parse(json['end_date']) : null),
      // Montants calculés si l'API ne les fournit pas (tryParse('0') renverrait 0, pas le calcul)
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? json['total_amount']?.toString() ?? '') ?? total,
      paidAmount: paid,
      remainingAmount: double.tryParse(json['remainingAmount']?.toString() ?? json['remaining_amount']?.toString() ?? '') ?? (total - paid),
      status: json['status'] ?? 'active',
      description: json['description'] ?? json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'principal': amount,
      'interest_rate': interestRate,
      'duration_months': durationMonths,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'status': status,
      'description': description,
    };
  }

  double get progressPercentage {
    if (totalAmount == 0) return 0;
    return (paidAmount / totalAmount * 100).clamp(0, 100);
  }

  bool get isCompleted => status == 'completed' || status == 'paid' || remainingAmount <= 0;
  bool get isActive => (status == 'active' || status == 'approved') && remainingAmount > 0;
  bool get isOverdue {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!) && remainingAmount > 0;
  }
}
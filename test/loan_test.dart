import 'package:flutter_test/flutter_test.dart';
import 'package:microfinance_mobile/models/loan.dart';

void main() {
  test("Le total et le reste à payer sont calculés si l'API ne les fournit pas", () {
    final loan = Loan.fromJson({
      'id': '1',
      'memberId': '1',
      'principal': 150000,
      'interestRate': 10,
      'durationMonths': 6,
      'paidAmount': 82500,
      'status': 'active',
    });
    // 150 000 + 150 000 × 10 % × 6/12 = 157 500
    expect(loan.totalAmount, 157500);
    expect(loan.remainingAmount, 75000);
    expect(loan.isActive, isTrue);
    expect(loan.progressPercentage.round(), 52);
  });

  test("Les montants fournis par l'API sont prioritaires", () {
    final loan = Loan.fromJson({
      'principal': 100000,
      'interest_rate': 5,
      'duration': 12,
      'total_amount': 106000,
      'remaining_amount': 6000,
      'paid_amount': 100000,
    });
    expect(loan.totalAmount, 106000);
    expect(loan.remainingAmount, 6000);
  });
}

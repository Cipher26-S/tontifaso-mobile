import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/loan.dart';

class LoanDetailScreen extends StatelessWidget {
  final Loan loan;

  const LoanDetailScreen({Key? key, required this.loan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'fr_FR');
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');

    Color statusColor = loan.isCompleted
        ? Colors.green
        : loan.isOverdue
            ? Colors.red
            : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du prêt'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    loan.isCompleted
                        ? Icons.check_circle
                        : Icons.account_balance,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${currencyFormat.format(loan.amount)} FCFA',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loan.isCompleted
                        ? 'Prêt remboursé'
                        : 'Prêt en cours',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Progression du remboursement
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progression du remboursement',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: loan.progressPercentage / 100,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${loan.progressPercentage.toStringAsFixed(1)}% remboursé',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informations financières
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations financières',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Montant emprunté',
                        '${currencyFormat.format(loan.amount)} FCFA',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Taux d\'intérêt',
                        '${loan.interestRate}%',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Durée',
                        '${loan.durationMonths} mois',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Montant total à rembourser',
                        '${currencyFormat.format(loan.totalAmount)} FCFA',
                        highlight: true,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Montant payé',
                        '${currencyFormat.format(loan.paidAmount)} FCFA',
                        color: Colors.green,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Reste à payer',
                        '${currencyFormat.format(loan.remainingAmount)} FCFA',
                        color: statusColor,
                        highlight: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Dates
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dates importantes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Date de début',
                        dateFormat.format(loan.startDate),
                      ),
                      if (loan.endDate != null) ...[
                        const Divider(height: 24),
                        _buildInfoRow(
                          'Date de fin prévue',
                          dateFormat.format(loan.endDate!),
                          color: loan.isOverdue ? Colors.red : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            if (loan.description != null && loan.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loan.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool highlight = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: highlight ? 16 : 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
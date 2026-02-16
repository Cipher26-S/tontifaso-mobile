import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/member_provider.dart';
import '../providers/auth_provider.dart';
import '../models/loan.dart';
import 'loan_detail_screen.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Prêts'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => memberProvider.loadLoans(authProvider.userId!),
        child: Column(
          children: [
            // En-tête avec statistiques
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        'Total emprunté',
                        '${currencyFormat.format(memberProvider.totalLoans)} F',
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white30,
                      ),
                      _buildStatColumn(
                        'Reste à payer',
                        '${currencyFormat.format(memberProvider.totalRemaining)} F',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${memberProvider.loans.length} prêt(s) • ${memberProvider.activeLoans.length} actif(s)',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Liste des prêts
            Expanded(
              child: memberProvider.loans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun prêt pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: memberProvider.loans.length,
                      itemBuilder: (context, index) {
                        final loan = memberProvider.loans[index];
                        return _buildLoanCard(context, loan, currencyFormat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoanCard(BuildContext context, Loan loan, NumberFormat currencyFormat) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (loan.isCompleted) {
      statusColor = Colors.green;
      statusText = 'Remboursé';
      statusIcon = Icons.check_circle;
    } else if (loan.isOverdue) {
      statusColor = Colors.red;
      statusText = 'En retard';
      statusIcon = Icons.warning;
    } else {
      statusColor = Colors.orange;
      statusText = 'En cours';
      statusIcon = Icons.pending;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoanDetailScreen(loan: loan),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${currencyFormat.format(loan.amount)} FCFA',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Taux: ${loan.interestRate}% • ${loan.durationMonths} mois',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Barre de progression
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: loan.progressPercentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payé: ${currencyFormat.format(loan.paidAmount)} F',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Reste: ${currencyFormat.format(loan.remainingAmount)} F',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
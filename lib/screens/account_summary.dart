import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/finance_account.dart';

class AmountSummary extends StatefulWidget {
  final FinanceAccount? bankAccount;
  final FinanceAccount? cashAccount;

   AmountSummary({
    Key? key,
    required this.bankAccount,
    required this.cashAccount,
  }) : super(key: key);

  @override
  State<AmountSummary> createState() => _AmountSummaryState();
}

class _AmountSummaryState extends State<AmountSummary> {
 

 


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    
          return Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: colorScheme.surface, // Use surface color for the card
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monetization_on, color: colorScheme.primary), // Use a relevant icon
                          SizedBox(width: 8),
                          Text(
                            'Amount Summary',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface, // Use onSurface color for the text
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAmountRow(
                        'Bank Amount',
                        NumberFormat('#,###.##', 'en_US').format(widget.bankAccount!.balance),
                        colorScheme.primary,
                        icon: Icons.account_balance, // Add icon
                      ),
                      _buildAmountRow(
                        'Cash Amount',
                        NumberFormat('#,###.##', 'en_US').format(widget.cashAccount!.balance),
                        colorScheme.secondary,
                        icon: Icons.money, // Add icon
                      ),
                      const Divider(height: 24, thickness: 1),
                      _buildAmountRow(
                        'Total Amount',
                        NumberFormat('#,###.##', 'en_US').format(widget.bankAccount!.balance + widget.cashAccount!.balance),
                        colorScheme.tertiary,
                        isTotal: true,
                        icon: Icons.attach_money, // Add icon
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
    
  }

  Widget _buildAmountRow(String label, String amount, Color color, {bool isTotal = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20), // Add icon
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            amount, // Format to 2 decimal places
            style: TextStyle(
              fontSize: 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
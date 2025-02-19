import 'package:flutter/material.dart';

class AmountSummary extends StatelessWidget {
  final double bankAmount;
  final double cashAmount;

  const AmountSummary({
    Key? key,
    required this.bankAmount,
    required this.cashAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAmount = bankAmount + cashAmount;

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildAmountRow('Bank Amount', bankAmount, Colors.blue),
            _buildAmountRow('Cash Amount', cashAmount, Colors.green),
            Divider(height: 20, thickness: 1),
            _buildAmountRow('Total Amount', totalAmount, Colors.purple, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, Color color, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          Text(
            amount.toStringAsFixed(2), // Format to 2 decimal places
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
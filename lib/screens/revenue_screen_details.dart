import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/finance_account.dart';

class RevenueScreenDetails extends StatelessWidget {
  final FinanceAccount financeAccount;

  const RevenueScreenDetails({super.key, required this.financeAccount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue Details"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: financeAccount.debits.length,
        itemBuilder: (context, index) {
          final debit = financeAccount.debits[index];

          // Compare with previous entry (if exists)
          double? previousAmount = index > 0 ? financeAccount.debits[index - 1].amount : null;
          bool isIncreasing = previousAmount == null || debit.amount >= previousAmount;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: isIncreasing ? Colors.green[50] : Colors.red[50], // Light green if increasing, light red if decreasing
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blueAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('yyyy-MM-dd').format(debit.createdAt),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isIncreasing ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isIncreasing ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${NumberFormat().format(debit.amount)} SDG",
                        style: TextStyle(
                          fontSize: 16,
                          color: isIncreasing ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.description, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          debit.entry!.description,
                          style: const TextStyle(fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/finance_account.dart';
import 'package:http/http.dart' as http;

class AmountSummary extends StatefulWidget {
  final double bankAmount;
  final double cashAmount;

  const AmountSummary({
    Key? key,
    required this.bankAmount,
    required this.cashAmount,
  }) : super(key: key);

  @override
  State<AmountSummary> createState() => _AmountSummaryState();
}

class _AmountSummaryState extends State<AmountSummary> {
   FinanceAccount? bankAccount;
   FinanceAccount? cashAccount;

  Future<List<FinanceAccount>> _getDate () async{
      final url =  Uri(scheme: schema,host: host,path: '$path/financeAccounts');
      try {
         Response response =   await http.get(url);
      if(response.statusCode == 200){
        List<dynamic> data =   jsonDecode(response.body);
       List<FinanceAccount> financeAccounts=   data.map((fjson)=>FinanceAccount.fromJson(fjson)).toList();

         bankAccount =   financeAccounts.firstWhere((a)=>a.id == 16);
         cashAccount =   financeAccounts.firstWhere((a)=>a.id == 5);

        return financeAccounts;
      }

      } catch (e) {
        print(e.toString());
        rethrow;
      }
     return [];
   }

   Future<void> _refreshData() async {
    setState(() {
      bankAccount = null;
      cashAccount = null;
    });
    await _getDate();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
        onRefresh: _refreshData,
      child: FutureBuilder(
        future: _getDate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (bankAccount == null || cashAccount == null) {
            return Center(child: Text('Failed to load account data.'));
          }
          else {
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
                          NumberFormat('#,###.##', 'en_US').format(bankAccount!.balance),
                          colorScheme.primary,
                          icon: Icons.account_balance, // Add icon
                        ),
                        _buildAmountRow(
                          'Cash Amount',
                          NumberFormat('#,###.##', 'en_US').format(cashAccount!.balance),
                          colorScheme.secondary,
                          icon: Icons.money, // Add icon
                        ),
                        const Divider(height: 24, thickness: 1),
                        _buildAmountRow(
                          'Total Amount',
                          NumberFormat('#,###.##', 'en_US').format(bankAccount!.balance + cashAccount!.balance),
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
        },
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
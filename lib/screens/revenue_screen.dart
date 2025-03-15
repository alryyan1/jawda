import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/finance_account.dart';
import 'package:http/http.dart' as http;
import 'package:jawda/screens/revenue_screen_details.dart';

class RevenueScreen extends StatefulWidget {
  RevenueScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  bool _isLoading = false;
  Future<List<FinanceAccount>> _getDate() async {
    final url = Uri(scheme: schema, host: host, path: '$path/financeAccounts-revenues');
    try {
      setState(() {
        _isLoading = true;
      });
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<FinanceAccount> financeAccounts =
            data.map((fjson) => FinanceAccount.fromJson(fjson)).toList();

        return financeAccounts
            .where((a) => a.accountType == AccountType.revenue)
            .toList();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('الايرادات '),),
      body: FutureBuilder(
          future: _getDate(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: colorScheme.error),
              );
            }
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            final accounts = snapshot!.data;
            return Card(
              elevation: 8,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: colorScheme.surface, // Use surface color for the card
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: accounts!.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RevenueScreenDetails(financeAccount: account),)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monetization_on,
                                  color:
                                      colorScheme.primary), // Use a relevant icon
                              SizedBox(width: 8),
                              Text(
                                account.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme
                                      .onSurface, // Use onSurface color for the text
                                ),
                              ),
                            ],
                          ),
                      
                          _buildAmountRow(
                            ' Amount',
                            NumberFormat('#,###.##', 'en_US')
                                .format(account.balance),
                            colorScheme.secondary,
                            icon: Icons.money, // Add icon
                          ),
                          const Divider(height: 24, thickness: 1),
                          
                        ],
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildAmountRow(String label, String amount, Color color,
      {bool isTotal = false, IconData? icon}) {
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

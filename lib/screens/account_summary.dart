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
    super.key,
    required this.bankAmount,
    required this.cashAmount,
  });

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
        
        print(data);
        return financeAccounts;
      } 
     
      } catch (e) {
        print(e.toString());
        rethrow;
      }
     return [];
   } 

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.bankAmount + widget.cashAmount;

    return FutureBuilder(future: _getDate(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const CircularProgressIndicator();
      }
      if(snapshot.hasError){
        return Text(snapshot.error.toString());
      }else{
         return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amount Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildAmountRow('Bank Amount', NumberFormat('#,###.##','en_Us').format(bankAccount!.balance), Colors.blue),
            _buildAmountRow('Cash Amount',  NumberFormat('#,###.##','en_Us').format(cashAccount!.balance), Colors.green),
            const Divider(height: 20, thickness: 1),
            _buildAmountRow('Total Amount',NumberFormat('#,###.##','en_Us').format( bankAccount!.balance + cashAccount!.balance ), Colors.purple, isTotal: true),
          ],
        ),
      ),
    );
      }
     
    },);

    
  }

  Widget _buildAmountRow(String label, String amount, Color color, {bool isTotal = false}) {
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
            amount, // Format to 2 decimal places
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
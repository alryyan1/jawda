import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawda/constansts.dart';
import '../models/finance_account.dart';

class FinanceAccountListScreen extends StatefulWidget {
  @override
  _FinanceAccountListScreenState createState() => _FinanceAccountListScreenState();
}

class _FinanceAccountListScreenState extends State<FinanceAccountListScreen> {
  List<FinanceAccount> _accounts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri( scheme: schema,host: host,path: '${path}/financeAccounts'); // Replace with your API endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        _accounts = decodedData.map((item) => FinanceAccount.fromJson(item)).toList();
      } else {
        print('Failed to load accounts: ${response.statusCode}');
        // Handle error (e.g., show a snackbar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load finance accounts')),
        );
      }
    } catch (error) {
      print('Error fetching accounts: $error');
      // Handle network errors, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching finance accounts')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Accounts'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _accounts.isEmpty
              ? Center(child: Text('No finance accounts found.'))
              : ListView.builder(
                  itemCount: _accounts.length,
                  itemBuilder: (context, index) {
                    final account = _accounts[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('Code: ${account.code}'),
                            Text('Debit/Credit: ${account.debits.fold(0, ( previousValue, element) =>  previousValue + element.amount.toInt() )}'),
                            Text('Balance: ${account.balance}'),
                            if (account.description != null)
                              Text('Description: ${account.description}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
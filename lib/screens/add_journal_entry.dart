import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:jawda/constansts.dart';
import 'package:jawda/screens/signature_screen.dart';
import 'package:jawda/services/dio_client.dart';
import '../models/finance_account.dart';

class AddJournalEntryScreen extends StatefulWidget {
  const AddJournalEntryScreen({super.key});

  @override
  _AddJournalEntryScreenState createState() => _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends State<AddJournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<DebitCreditEntry> _debitEntries = [DebitCreditEntry()];
  List<DebitCreditEntry> _creditEntries = [DebitCreditEntry()];
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

    final url = Uri(
        scheme: schema,
        host: host,
        path: '$path/financeAccounts'); // Replace with your API endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        _accounts =
            decodedData.map((item) => FinanceAccount.fromJson(item)).toList();
      } else {
        print('Failed to load accounts: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load finance accounts')),
        );
      }
    } catch (error) {
      print('Error fetching accounts: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching finance accounts')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validate that at least one debit and credit account is selected
      if (_debitEntries.isEmpty || _creditEntries.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select at least one debit and credit account')),
        );
        return;
      }

      // Validate that the debit and credit amounts balance
      double totalDebit = 0;
      for (var entry in _debitEntries) {
        totalDebit += double.tryParse(entry.amountController.text) ?? 0;
      }

      double totalCredit = 0;
      for (var entry in _creditEntries) {
        totalCredit += double.tryParse(entry.amountController.text) ?? 0;
      }

      if (totalDebit != totalCredit) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debits and credits must balance')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final url = Uri(
          scheme: schema,
          host: host,
          path:
              '$path/createFinanceEntries'); // Replace with your API endpoint
      try {
        final formattedDate =
            intl.DateFormat('yyyy-MM-dd').format(_selectedDate);

        // Transform debit and credit entries to the format expected by the API
        List<Map<String, dynamic>> debits = _debitEntries
            .where((e) => e.selectedAccount != null) // Filter out empty accounts
            .map((entry) => {
                  'account': entry.selectedAccount!.id,
                  'amount': entry.amountController.text,
                })
            .toList();

        List<Map<String, dynamic>> credits = _creditEntries
            .where((e) => e.selectedAccount != null) // Filter out empty accounts
            .map((entry) => {
                  'account': entry.selectedAccount!.id,
                  'amount': entry.amountController.text,
                })
            .toList();

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'description': _descriptionController.text,
            'date': formattedDate,
            'debits': debits,
            'credits': credits,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Journal entry added successfully!')),
          );

          // Reset the form
          _descriptionController.clear();

          setState(() {
            _selectedDate = DateTime.now();
            _debitEntries = [DebitCreditEntry()];
            _creditEntries = [DebitCreditEntry()];
          });
        } else {
          print('Failed to add journal entry: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add journal entry')),
          );
        }
      } catch (error) {
        print('Error adding journal entry: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred while adding journal entry')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Journal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Date: '),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                          intl.DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Debit Accounts',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ..._buildDebitCreditEntries(
                    _debitEntries, "Debit Account", context),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _debitEntries.add(DebitCreditEntry());
                      });
                    },
                    child: const Text("Add Debit Account")),
                const SizedBox(height: 16),
                const Text('Credit Accounts',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ..._buildDebitCreditEntries(
                    _creditEntries, "Credit Account", context),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _creditEntries.add(DebitCreditEntry());
                      });
                    },
                    child: const Text("Add Credit Account")),
                const SizedBox(height: 24),
            //       ElevatedButton(
            //   onPressed: _addSignature,
            //   child: Text('Add Signature'),
            // ),
            // if (_signatureImage != null)
            //   Image.memory(
            //     _signatureImage!,
            //     height: 100,
            //   ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Journal Entry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDebitCreditEntries(
      List<DebitCreditEntry> entries, String label, BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < entries.length; i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField<FinanceAccount>(
                controller: entries[i].accountController,
                
                
                suggestionsCallback: (pattern) async {
                  return _accounts
                      .where((account) => account.name
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, FinanceAccount suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: Text(suggestion.name),
                    subtitle: Text(suggestion.code),
                  );
                },
                onSelected: (FinanceAccount suggestion) {
                  setState(() {
                    entries[i].accountController.text = suggestion.name;
                    entries[i].selectedAccount = suggestion;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: entries[i].amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ));
    }
    return widgets;
  }
}

class DebitCreditEntry {
  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FinanceAccount? selectedAccount;
}
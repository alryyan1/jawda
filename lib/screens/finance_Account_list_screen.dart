import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/screens/ledger.dart';
import '../models/finance_account.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import syncfusion_flutter_pdfviewer

class FinanceAccountListScreen extends StatefulWidget {
  @override
  _FinanceAccountListScreenState createState() => _FinanceAccountListScreenState();
}

class _FinanceAccountListScreenState extends State<FinanceAccountListScreen> {
  List<FinanceAccount> _accounts = [];
  bool _isLoading = false;
  Uint8List? _pdfData; // Store PDF data
  bool _isPdfLoading = false;

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

  Future<void> _generateAndShowPdf(int accountId) async {
    setState(() {
      _isPdfLoading = true;
      _pdfData = null; // Reset previous PDF data
    });

    final url = Uri(scheme: schema,host: host,path: path +'ledger/${accountId}'); // Replace with your PDF generation endpoint
    print(url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
 
        final String base64Pdf = response.body;

        setState(() {
          _pdfData = base64Decode(base64Pdf);
        });


      } else {
        print('Failed to generate PDF: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF')),
        );
      }
    } catch (error) {
      print('Error generating PDF: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while generating PDF')),
      );
    } finally {
      setState(() {
        _isPdfLoading = false;
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
              : Column( // Use a Column to stack the list and PDF viewer
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _accounts.length,
                        itemBuilder: (context, index) {
                          final account = _accounts[index];
                            final totalDebit = account.debits.fold(0, (previousValue, element) {
                              return previousValue + element.amount.toInt();
                            },);
                          return ListTile(
                            title: Text(account.name),
                            subtitle: Text(NumberFormat('#,###.##','en_Us').format(totalDebit)),
                            leading: IconButton(
                              icon: Icon(Icons.picture_as_pdf),
                              onPressed: () {
                                _generateAndShowPdf(account.id); // Pass accountId
                              },
                            ),
                            trailing: IconButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return Ledger(financeAccount:  account);
                              },));
                            }, icon: Icon(Icons.remove_red_eye)),
                          );

                        },
                      ),
                    ),
                    if (_isPdfLoading)
                      Center(child: CircularProgressIndicator())
                    else if (_pdfData != null)
                      Expanded(
                        child: SfPdfViewer.memory( // Display PDF using syncfusion_flutter_pdfviewer
                          _pdfData!,
                        ),
                      )
                  ],
                ),
    );
  }
}
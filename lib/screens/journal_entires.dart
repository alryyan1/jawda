import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/finance_account.dart';
import 'package:jawda/services/dio_client.dart';

class JournalEntriesScreen extends StatefulWidget {
  @override
  _JournalEntriesScreenState createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen> {
  List<FinanceEntry> _entries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    setState(() {
      _isLoading = true;
    });


    try {
          final now = DateTime.now();
    final firstDay = DateTime(now.year,now.month,1);
    final lastDay = DateTime(now.year,now.month+1,0);
  
      final dio = DioClient.getDioInstance(context);
      final response = await dio.get('financeEntries', queryParameters:  {'first':DateFormat('yyyy-MM-dd').format(firstDay),'second':DateFormat('yyyy-MM-dd').format(lastDay)});
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = response.data;
        _entries = decodedData.map((item) => FinanceEntry.fromJson(item)).toList();
      } else {
        print('Failed to load journal entries: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load journal entries')),
        );
      }
    } catch (error) {
      print('Error fetching journal entries: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching journal entries')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatNumber(num? number) {
    if (number == null) return '';
    return NumberFormat('#,###.##', 'en_US').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Entries'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(child: Text('No journal entries found.'))
              : SingleChildScrollView(
                child: SingleChildScrollView( // Make the table scrollable horizontally
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: Center(child: Text('Date'))),
                        DataColumn(label: Center(child: Text('Entry No.'))),
                        DataColumn(label: Center(child: Text('Account'))),
                        DataColumn(label: Center(child: Text('Debit'))),
                        DataColumn(label: Center(child: Text('Credit'))),
                      ],
                      rows: _entries.mapIndexed((i, entry) {
                        final debitLength = entry.debit.length;
                        
                        final creditLength = entry.credit.length;
                        final maxRows = debitLength > creditLength ? debitLength : creditLength;
                
                        List<DataRow> rows = [];
                
                        // Main Row (Date, Entry No.)
                        rows.add(
                          DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(DateFormat('yyyy-MM-dd').format(entry.createdAt)),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(entry.id.toString()),
                                ),
                              ),
                              DataCell(Container()), // Placeholder
                              DataCell(Container()), // Placeholder
                              DataCell(Container()), // Placeholder
                            ],
                          ),
                        );
                
                
                        // Debit Rows
                        for (int j = 0; j < debitLength; j++) {
                          final e = entry.debit[j];
                          rows.add(
                            DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                if (i % 2 == 0) {
                                  return Colors.grey.withOpacity(0.1); // Light grey background for even rows
                                }
                                return null; // Use default value for other states and odd rows.
                              }),
                              cells: [
                                DataCell(Container()), // Date
                                DataCell(Container()), // Entry No
                                DataCell(
                                  Text((debitLength > 1 && j == 0 ? 'من مذكورين   ' : 'من ح/ ') + (e.account?.name ?? '')),
                                ),
                                DataCell(
                                  Center(child: Text(formatNumber(e.amount))),
                                ),
                                DataCell(Container()), // Credit placeholder
                              ],
                            ),
                          );
                        }
                
                        // Credit Rows
                        for (int j = 0; j < creditLength; j++) {
                          final e = entry.credit[j];
                          rows.add(
                            DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                if (i % 2 == 0) {
                                  return Colors.grey.withOpacity(0.1); // Light grey background for even rows
                                }
                                return null; // Use default value for other states and odd rows.
                              }),
                              cells: [
                                DataCell(Container()), // Date
                                DataCell(Container()), // Entry No
                                DataCell(
                                  Text((creditLength > 1 && j == 0 ? 'الي مذكورين .......   ' : 'الي ح/ ....... ') + (e.account?.name ?? '')),
                                ),
                                DataCell(Container()), // Debit placeholder
                                DataCell(
                                  Center(child: Text(formatNumber(e.amount))),
                                ),
                              ],
                            ),
                          );
                        }
                
                        // Description Row
                        rows.add(
                          DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                              if (i % 2 == 0) {
                                return Colors.grey.withOpacity(0.1); // Light grey background for even rows
                              }
                              return null; // Use default value for other states and odd rows.
                            }),
                            cells: [
                              DataCell(Container()), // Date
                              DataCell(Container()), // Entry No
                              DataCell(
                                Center(
                                  child: Text(
                                    entry.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataCell(Container()), // Debit placeholder
                              DataCell(Container()), // Credit placeholder
                            ],
                          ),
                        );
                
                
                        return rows;
                      }).expand((element) => element).toList(),
                    ),
                  ),
              ),
            );
  }
}
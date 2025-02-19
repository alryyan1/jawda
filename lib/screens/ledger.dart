import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/finance_account.dart';

class Ledger extends StatelessWidget {
  FinanceAccount financeAccount;
  Ledger({super.key, required this.financeAccount});
  List<TableRow> handleEntries(context) {
    List entries = [
      ...financeAccount.credits.map((d) => d.financeEntryId),
      ...financeAccount.debits.map((d) => d.financeEntryId)
    ];

    entries.sort((a, b) => b.compareTo(a));
    List<TableRow> transformedList = [];
    for (int i = 0; i < entries.length; i++) {
      var creditAmount = 0;
      var debitAmount = 0;
      String detials = '';
      DateTime date;
      var entryId = entries[i];

      if (financeAccount.debits.isNotEmpty) {
        //fold
        debitAmount = financeAccount.debits
            .where((d) => d.financeEntryId == entryId)
            .fold(0, (prev, curr) {
          return prev + curr.amount.toInt();
        });

        debitAmount = financeAccount.debits
            .where((d) => d.financeEntryId == entryId)
            .fold(0, (prev, curr) {
          return prev + curr.amount.toInt();
        });
      }
      if (financeAccount.credits.isNotEmpty) {
        //fold
        creditAmount = financeAccount.credits
            .where((d) => d.financeEntryId == entryId)
            .fold(0, (prev, curr) {
          return prev + curr.amount.toInt();
        });

      }

   var filteredCredits = financeAccount.credits
    .where((d) => d.financeEntryId == entryId)
    .toList();

// Check if list is not empty before accessing [0]
 detials = filteredCredits.isNotEmpty ? filteredCredits[0].entry?.description ?? '' : '';

if(detials == ''){
  var filteredDebits = financeAccount.debits
    .where((d) => d.financeEntryId == entryId)
    .toList();

// Check if list is not empty before accessing [0]
 detials = filteredDebits.isNotEmpty ? filteredDebits[0].entry?.description ?? '' : '';
}



      try {
             
        date = financeAccount.debits
            .firstWhere((d) => d.financeEntryId == entryId)
            .createdAt;
      } catch (e) {
               
        date = financeAccount.credits
            .firstWhere(
              (d) => d.financeEntryId == entryId,
            )
            .createdAt;
      }
      transformedList.add(TableRow(children: [
        TableCell(child: Text(DateFormat('yyyy-MM-dd').format(date))),
        TableCell(child: Text(entryId.toString())),
        TableCell(
            child: Text(NumberFormat('#,###.##', 'en-Us').format(debitAmount))),
        TableCell(child: Text(NumberFormat().format(creditAmount))),
        TableCell(
            child: IconButton(
          icon: const Icon(Icons.more),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Details'),
                  content: Text(detials.toString()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    )
                  ],
                );
              },
            );
          },
        )),
      ]));
    }
    return transformedList;
  }

  @override
  Widget build(BuildContext context) {
    print(financeAccount.debits.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(financeAccount.name),
      ),
      body: SingleChildScrollView(
        child: Table(
          columnWidths: const {0: const FlexColumnWidth(1.1)},
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              TableCell(child: Text('Date')),
              TableCell(child: Text('ID')),
              TableCell(child: Text('Credit')),
              TableCell(child: Text('Debit')),
              TableCell(child: Text('Details')),
            ]),
            ...handleEntries(context)
          ],
        ),
      ),
    );
  }
}

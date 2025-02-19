import 'package:flutter/material.dart';
import 'package:jawda/screens/add_journal_entry.dart';
import 'finance_account_list_screen.dart'; // Import FinanceAccountListScreen
// import 'journal_entries_screen.dart';
// import 'trial_balance_screen.dart';
// import 'ledger_screen.dart';
import 'package:intl/intl.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, 1);
    final lastDate = DateTime(now.year, now.month + 1, 0);
    final formatedFirstDate = DateFormat('yyyy-MM-dd').format(firstDate);
    final formatedLastDate = DateFormat('yyyy-MM-dd').format(lastDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Period from  $formatedFirstDate to $formatedLastDate '),
            const Divider(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildGridItem(context, 'Account List', Icons.account_balance,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinanceAccountListScreen()),
                  );
                }),
                _buildGridItem(context, 'Journal Entries', Icons.book, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Journal Entries page is under construction')));
                }),
                _buildGridItem(context, 'Trial Balance', Icons.equalizer, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Trial Balance page is under construction')));
                }),
                _buildGridItem(context, 'Ledger', Icons.description, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Ledger page is under construction')));
                }),
                _buildGridItem(context, 'add Entry', Icons.description, () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return AddJournalEntryScreen();
                  },));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Colors.green,
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

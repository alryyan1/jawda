import 'package:flutter/material.dart';
import 'package:jawda/screens/add_journal_entry.dart';
import 'package:jawda/screens/journal_entires.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import 'package:jawda/screens/petty_cash_screen.dart';
import 'finance_account_list_screen.dart';
import 'package:intl/intl.dart' as intl;

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, 1);
    final lastDate = DateTime(now.year, now.month + 1, 0);
    final formatedFirstDate = intl.DateFormat('yyyy-MM-dd').format(firstDate);
    final formatedLastDate = intl.DateFormat('yyyy-MM-dd').format(lastDate);

    return Directionality( // Use Directionality for RTL support
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المالية'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('الفترة من $formatedFirstDate إلى $formatedLastDate '),
              const Divider(),
              Expanded( // Use Expanded to avoid overflow
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                  children: [
                    _buildGridItem(
                      context,
                      'قائمة الحسابات',
                      Icons.account_balance,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FinanceAccountListScreen()),
                        );
                      },
                    ),
                    _buildGridItem(
                      context,
                      'قيود اليومية',
                      Icons.book,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return JournalEntriesScreen();
                            },
                          ),
                        );
                      },
                    ),
                    _buildGridItem(
                      context,
                      'ميزان المراجعة',
                      Icons.equalizer,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('صفحة ميزان المراجعة قيد الإنشاء')));
                      },
                    ),
                    _buildGridItem(
                      context,
                      'دفتر الأستاذ',
                      Icons.description,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('صفحة دفتر الأستاذ قيد الإنشاء')));
                      },
                    ),
                    _buildGridItem(
                      context,
                      'إضافة قيد',
                      Icons.add,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddJournalEntryScreen();
                            },
                          ),
                        );
                      },
                    ),
                    _buildGridItem(
                      context,
                      'الصندوق النثري',
                      Icons.local_atm,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return PettyCashScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: colorScheme.primary,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jawda/screens/account_summary.dart';
import 'package:jawda/screens/doctor_schedule.dart';
import 'package:jawda/screens/finance_screen.dart';
import 'package:jawda/screens/pharmacy/pharamcy_screen.dart';
import 'package:jawda/screens/revenue_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'doctor_list_screen.dart';
import 'package:jawda/constansts.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import '../models/finance_account.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  _checkSession() async {
    final url = Uri(host: host, scheme: schema, path: path + '/user/');
    var headers = await getHeaders();
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
    } else {
      final shared = await SharedPreferences.getInstance();
      shared.remove('auth_token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // Use Directionality for RTL support
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('القائمة الرئيسية'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('جارِ تحديث ملخص الحساب...')),
            );
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildGridItem(context, 'الأطباء', Icons.medical_services,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorListScreen()),
                      );
                    }),
                    _buildGridItem(context, 'الإعدادات', Icons.settings, () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('صفحة الإعدادات قيد الإنشاء')));
                    }),
                    _buildGridItem(context, 'المختبر', Icons.science, () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('صفحة المختبر قيد الإنشاء')));
                    }),
                    _buildGridItem(context, 'المالية', Icons.attach_money, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FinanceScreen()),
                      );
                    }),
                    _buildGridItem(
                        context, 'اداره المبيعات', Icons.local_pharmacy, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacyScreen()),
                      );
                    }),
                    _buildGridItem(
                      context,
                      'جدول الاطباء',
                      Icons.local_pharmacy,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DoctorScheduleManagerScreen()),
                        );
                      },
                    ),
                       _buildGridItem(
                      context,
                      'الايرادات ',
                      Icons.local_pharmacy,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RevenueScreen()),
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

  Widget _buildGridItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

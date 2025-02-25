import 'package:flutter/material.dart';
import 'package:jawda/screens/account_summary.dart';
import 'package:jawda/screens/finance_screen.dart';
import 'package:jawda/screens/pharmacy/pharamcy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'login_screen.dart'; // Import LoginScreen
import 'doctor_list_screen.dart';
import 'dart:convert';
import './../models/finance_account.dart';
import 'package:jawda/constansts.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  late FinanceAccount? bankAccount;
  late FinanceAccount? cashAccount;
  MainScreen({Key? key, this.bankAccount, this.cashAccount}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = false ;
  @override
  void initState() {
   
    super.initState();
    _checkSession();

  }
  _checkSession() async{
    final url = Uri(host: host,scheme: schema,path: path+'/user/');
    var headers =  await getHeaders();
     var response =  await http.get(url,headers: headers);
     if (response.statusCode == 200) {
    _getDate();
       
     }else{
      final shared =  await SharedPreferences.getInstance();
      shared.remove('auth_token');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    
     }
    
  }
  Future<List<FinanceAccount>> _getDate() async {
    final url = Uri(scheme: schema, host: host, path: '$path/financeAccounts');
    try {
       setState(() {
      _isLoading = true;
    });
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<FinanceAccount> financeAccounts =
            data.map((fjson) => FinanceAccount.fromJson(fjson)).toList();

        widget.bankAccount = financeAccounts.firstWhere((a) => a.id == 16);
        widget.cashAccount = financeAccounts.firstWhere((a) => a.id == 5);

        return financeAccounts;
      }
    } catch (e) {
      print(e.toString());
    
      rethrow;
    }finally{
  setState(() {
        _isLoading = false;
      });
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
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
          await _getDate();
          setState(() {
            _isLoading = false;
          });
          // Call the refresh method from AmountSummary
          // This assumes that AmountSummary has a public method or a Provider/State management solution
          // to trigger the data refresh.
          // You may need to use a GlobalKey or a ValueNotifier to trigger the refresh
          // For simplicity, we will show this message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Refreshing Amount Summary...')),
          );

          // Implement the actual refresh logic here.
        },
        child: ListView(
          // Use ListView to make the whole screen scrollable
          children: [
             _isLoading ? Center(child: CircularProgressIndicator(),) : AmountSummary(bankAccount: widget.bankAccount, cashAccount: widget.cashAccount),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true, // Important to avoid scroll issues
                physics:
                    NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildGridItem(context, 'Doctors', Icons.medical_services,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorListScreen()),
                    );
                  }),
                  _buildGridItem(context, 'Settings', Icons.settings, () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Settings page is under construction')));
                  }),
                  _buildGridItem(context, 'Laboratory', Icons.science, () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Laboratory page is under construction')));
                  }),
                  _buildGridItem(context, 'Finance', Icons.attach_money, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FinanceScreen()),
                    );
                  }),
                  // Add more items as needed
                    _buildGridItem(context, 'Pharmacy', Icons.local_pharmacy, () {  // Add Pharmacy item
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PharmacyScreen()),
                    );
                  }),
                ],
              ),
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
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remove the token

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

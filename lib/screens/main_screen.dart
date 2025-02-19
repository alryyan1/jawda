import 'package:flutter/material.dart';
import 'package:jawda/screens/account_summary.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'login_screen.dart'; // Import LoginScreen
import 'doctor_list_screen.dart';
import 'finance_screen.dart'; // Import FinanceScreen

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Column(

        children: [
          AmountSummary(bankAmount: 1000, cashAmount: 500),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildGridItem(context, 'Doctors', Icons.medical_services, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorListScreen()),
                    );
                  }),
                  _buildGridItem(context, 'Settings', Icons.settings, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Settings page is under construction')));
                  }),
                  _buildGridItem(context, 'Laboratory', Icons.science, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Laboratory page is under construction')));
                  }),
                  _buildGridItem(context, 'Finance', Icons.attach_money, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FinanceScreen()),
                    );
                  }),
                  // Add more items as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
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
            SizedBox(height: 10.0),
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
import 'package:flutter/material.dart';
import 'package:jawda/screens/account_summary.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'login_screen.dart'; // Import LoginScreen
import 'doctor_list_screen.dart';
import 'finance_screen.dart'; // Import FinanceScreen

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
        child: ListView( // Use ListView to make the whole screen scrollable
          children: [
            const AmountSummary(bankAmount: 1000, cashAmount: 500),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true, // Important to avoid scroll issues
                physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
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
                        const SnackBar(content: Text('Settings page is under construction')));
                  }),
                  _buildGridItem(context, 'Laboratory', Icons.science, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Laboratory page is under construction')));
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
          ],
        ),
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
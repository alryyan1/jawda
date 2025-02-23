import 'package:flutter/material.dart';
import 'package:jawda/screens/pharmacy/sales_screen.dart';
import 'near_expire_screen.dart';
import 'inventory_screen.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildGridItem(context, 'Sales', Icons.monetization_on, colorScheme.primary, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SaledateinfoList()),
              );
            }),
            _buildGridItem(context, 'Near Expire', Icons.warning, colorScheme.secondary, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NearExpireScreen()),
              );
            }),
            _buildGridItem(context, 'Inventory', Icons.inventory, colorScheme.tertiary, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: color,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
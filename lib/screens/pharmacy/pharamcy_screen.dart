import 'package:flutter/material.dart';
import 'package:jawda/screens/pharmacy/clients.dart';
import 'package:jawda/screens/pharmacy/items_screen.dart';
import 'package:jawda/screens/pharmacy/pos.dart';
import 'package:jawda/screens/pharmacy/purchases_screen.dart';
import 'package:jawda/screens/pharmacy/report_by_shift.dart';
import 'package:jawda/screens/pharmacy/sales_screen.dart';
import 'near_expire_screen.dart';
import 'inventory_screen.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to RTL
      child: Scaffold(
        appBar: AppBar(
          title: Text('الصيدلية'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildGridItem(
                context,
                'المبيعات',
                Icons.monetization_on,
                colorScheme.primary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaledateinfoList()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'قريب الانتهاء',
                Icons.warning,
                colorScheme.secondary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NearExpireScreen()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'المخزون',
                Icons.inventory,
                colorScheme.tertiary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InventoryScreen()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'الورديات',
                Icons.history,
                colorScheme.primary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportByShift()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'نقاط البيع',
                Icons.shopping_cart,
                colorScheme.secondary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pos()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'العملاء',
                Icons.person,
                colorScheme.tertiary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Clients()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'الأصناف',
                Icons.add_box,
                colorScheme.primary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemsScreen()),
                  );
                },
              ),
              _buildGridItem(
                context,
                'المشتريات',
                Icons.shopping_bag,
                colorScheme.secondary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PurchasesScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme; // Get color scheme

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Use color with opacity
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
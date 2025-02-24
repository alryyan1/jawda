import 'package:flutter/material.dart';
import '../models/pharmacy_models.dart';
import 'package:intl/intl.dart';

class ExpiredItemsScreen extends StatelessWidget {
  final int month;
  final int year;
  final List<Item> expiredItems;

  ExpiredItemsScreen({required this.month, required this.year, required this.expiredItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expired Items - ${DateFormat('MMMM yyyy').format(DateTime(year, month))}'),
      ),
      body: ListView.builder(
        itemCount: expiredItems.length,
        itemBuilder: (context, index) {
          final item = expiredItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Expire Date: ${item.expire}'),
          );
        },
      ),
    );
  }
}
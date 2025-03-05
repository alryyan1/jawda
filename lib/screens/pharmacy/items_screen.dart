import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:provider/provider.dart';
import 'add_edit_item_screen.dart'; // Import AddEditItemScreen

class ItemsScreen extends StatefulWidget {
  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
    List<Item> items = [];
    @override
  void initState() {
    super.initState();
   // Initialize the item provider here
    _getItems();
  }
  Future<void> _getItems()async{

    
      await Provider.of<ItemProvider>(context,listen: false).getItems('');
      setState(() {
        items = Provider.of<ItemProvider>(context,listen: false).items;
      });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditItemScreen(id: 0,)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _getItems(),
        child: Consumer<ItemProvider>(
          builder: (context, itemProvider, child) {
            if (itemProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (itemProvider.errorMessage != null) {
              return Center(child: Text('Error: ${itemProvider.errorMessage}'));
            }
            if (itemProvider.items.isEmpty) {
              return Center(child: Text('No items found.'));
            }
        
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search)
                  ),
                  onSubmitted: (value) {
                   setState(() {
                     items = itemProvider.items.where((element) => element.marketName.toLowerCase().contains(value),).toList();
                   });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.marketName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('R.Price: ${NumberFormat('#,###.##', 'en_US').format(item.lastDepositItem?.sellPrice)}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                                  Text('Expire: ${DateFormat('yyyy-MM-dd').format(item.lastDepositItem!.expire ?? DateTime(2025))}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text('Cost: ${NumberFormat().format(item.lastDepositItem?.cost)}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddEditItemScreen(item: item,id:item.id)),
                                    );
                                  },
                                  child: Text('Edit'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
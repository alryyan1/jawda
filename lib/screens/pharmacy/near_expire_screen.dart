import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/expire_month.dart';
import 'package:badges/badges.dart' as padg; // Import badges package

class NearExpireScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expire items in month'),
      ),
      body: FutureBuilder(
        future: ExpireData.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          }
          final expireDataList = snapshot.data!;
          return ListView.separated(
            itemCount: expireDataList.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(), // Add Divider
            itemBuilder: (context, index) {
              final expireData = expireDataList[index];
              return ListTile(
                leading:
                    Icon(Icons.calendar_month), // Add month icon on the left
                title: padg.Badge(
                    // Use Badge instead of badges.Badge
                    onTap: () {},
                    badgeStyle: padg.BadgeStyle(badgeColor: Colors.pink),
                    position: padg.BadgePosition.topEnd(
                        end: -12), // Adjust position if needed
                    badgeContent: Text(
                      '${expireData.items.length}', // Replace with the actual count
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Text(expireData.monthname)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.list), // Add details icon
                      onPressed: () {
                        // Handle details button press (e.g., navigate to details screen)
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Items expired in ${expireData.monthname}'),
                              content: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Divider(); // Add Divider
                                },
                                itemCount: expireData.items.length,
                                itemBuilder: (context, index) {
                                  var item = expireData.items[index];
                                  return ListTile(
                                    title: Text(item.marketName),
                                    subtitle: Text(DateFormat('yyyy-MM-dd').format(item.depositExpire!)
                                        ),
                                  );
                                },
                              ),
                              actions: <Widget>[],
                            );
                          },
                        );
                        print(
                            'Details button pressed for month: ${expireData.monthname}');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

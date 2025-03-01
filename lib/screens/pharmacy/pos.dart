import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/models/shift.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/screens/pharmacy/AddItemsToDeductScreen.dart';
import 'package:provider/provider.dart';

class Pos extends StatefulWidget {
  const Pos({Key? key}) : super(key: key);

  @override
  _PosState createState() => _PosState();
}

class _PosState extends State<Pos> {
  late Future<Shift> _shiftFuture; // Declare a Future

  @override
  void initState() {
    super.initState();
    Provider.of<ShiftProvider>(context, listen: false).fetchShift();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POS'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ShiftProvider>(context,listen: false).fetchShift(),
        child: Consumer<ShiftProvider>(
          builder: (context, shiftProvider, child) {
            if(shiftProvider.isLoading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(shiftProvider.errorMessage != null){
              return Center(
                child: Text('Error: ${shiftProvider.errorMessage}'),
              );
            }
            if(shiftProvider.shift == null){
              return Center(
                child: Text('No Shift Available'),
              );
            }
            final shift = shiftProvider.shift!;
            return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaction No'),
                      IconButton(
                        onPressed: () async {
                          try {
                            await Provider.of<ShiftProvider>(context,
                                    listen: false)
                                .addDeduct();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Error: ${e.toString()}')));
                          }
                        },
                        icon: Icon(Icons.add),
                        iconSize: 44,
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                      // Wrap GridView.builder with Expanded
                      child: Container(
                    child: GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: shift.deducts.length,
                      itemBuilder: (context, index) {
                        final deduct = shift.deducts[index];
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return InkWell(
                              onTap: () {
                                context.read<ShiftProvider>().setSelectedDeduct = deduct;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return AddItemsToDeductScreen(deduct: deduct);
                                },));
                              },
                              child: badges.Badge(
                                position:
                                    badges.BadgePosition.topEnd(top: 0, end: 0),
                                badgeContent: Text(
                                  '${deduct.deductedItems.length}', // Display item index as badge content
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 10),
                                ),
                                badgeStyle: badges.BadgeStyle(
                                    badgeColor:
                                        Colors.pink), // Set badge color to pink
                                child: Container(
                                  
                                  decoration: BoxDecoration(
                                    color:
                                        deduct.complete == 1 ? Colors.green : Colors.grey[200], // Light grey background
                                    borderRadius: BorderRadius.circular(
                                        15), // Rounded corners
                                  ),
                                  child: Center(
                                    child: Text(
                                      deduct.number.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

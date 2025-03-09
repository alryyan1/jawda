import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/screens/pharmacy/AddItemsToDeductScreen.dart';
import 'package:provider/provider.dart';

class ClientPurchases extends StatelessWidget {
  final Client client;

  const ClientPurchases({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    //clientprovider
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Purchases'),
      ),
      body: FutureBuilder(
          future: clientProvider.getClient(client.id, context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(7)
                  ),
                  child: Text('مبيعات: ${client.name}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: snapshot.data!.deducts.length,
                    itemBuilder: (context, index) {
                      final deduct = snapshot.data!.deducts[index];

                      return Column(
                        children: [
                          Divider(),
                          ListTile(
                            tileColor: deduct.complete == 1 ? Colors.green.shade100 : Colors.white,
                            leading: Text((index+1).toString()),
                            title: Text(DateFormat('yyyy-MM-dd').format(deduct.createdAt)),
                            subtitle: Text(NumberFormat().format(deduct.totalPrice)),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      context
                                          .read<ShiftProvider>()
                                          .setSelectedDeduct = deduct;
                          
                                      return AddItemsToDeductScreen(deduct: deduct);
                                    },
                                  ));
                                },
                                icon: Icon(Icons.remove_red_eye)),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}

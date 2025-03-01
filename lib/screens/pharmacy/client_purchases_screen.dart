import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:provider/provider.dart';

class ClientPurchases extends StatelessWidget {
  final Client client;

  const ClientPurchases({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    //clientprovider
    final clientProvider = Provider.of<ClientProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Purchases'),
      ),
      body: FutureBuilder(
        future: clientProvider.getClient( client.id,context),
        builder: (context, snapshot) {
      return     Column(
          children: [
            Text('Name: ${client.name}'),
            ListView.builder(
              itemCount: client.deducts!.length,
              itemBuilder: (context, index) {
                final deduct = client.deducts![index];
        
                return ListTile(
                  title: Text(DateFormat().format(deduct.createdAt)),
                  subtitle: Text(NumberFormat().format(deduct.paid)),
                );
              },
            )
          ],
        );
        } 
      ),
    );
  }
}

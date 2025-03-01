import 'package:flutter/material.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:provider/provider.dart';
import 'client_details_screen.dart';
import 'add_client_screen.dart'; // Import AddClientScreen
import 'package:intl/intl.dart';

class Clients extends StatelessWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clientProvider = Provider.of<ClientProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClientScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Client>>(
        future: clientProvider.getClients(''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No clients found'));
          }
      
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final client = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Icon(Icons.person),
                ),
                title: Text(client.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${client.phone}'),
                    Text('Email: ${client.email}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientDetailsScreen(client: client),
                      ),
                    );
                  },
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tileColor: colorScheme.surface,
              );
            },
          );
        },
      ),
    );
  }
}
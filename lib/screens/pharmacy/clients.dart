import 'package:flutter/material.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/screens/pharmacy/add_client_screen.dart';
import 'package:jawda/screens/pharmacy/client_details_screen.dart';
import 'package:provider/provider.dart';
class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  late Future<List<Client>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientsFuture = _fetchClients();
  }

  Future<List<Client>> _fetchClients() {
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    return clientProvider.getClients('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _clientsFuture = _fetchClients(); // Refresh future on pull
          });
        },
        child: FutureBuilder<List<Client>>(
          future: _clientsFuture,
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
      ),
    );
  }
}

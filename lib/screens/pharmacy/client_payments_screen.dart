import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/models/client_payment.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/screens/pharmacy/add_client_payment_screen.dart';
import 'package:provider/provider.dart';

class ClientPaymentsScreen extends StatelessWidget {
  final Client client;

  const ClientPaymentsScreen({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payments for ${client.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display client information at the top
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //btn to add payment
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AddClientPaymentScreen(client: client,) ,));
                    },
                    child: Text('Add Payment'),
                  ),
                  SizedBox(height: 16),
                  // Display payment details
                  Text(
                    'Payment History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Client: ${client.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 4),
                  Text('Phone: ${client.phone}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  Text('Email: ${client.email}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  Text('Address: ${client.address}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: client.payments.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final payment = client.payments[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Date: ${DateFormat('yyyy-MM-dd').format(payment.paymentDate)}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                              ),
                              SizedBox(height: 4),
                              Text('Created At: ${DateFormat('yyyy-MM-dd HH:mm').format(payment.createdAt)}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          Text(NumberFormat('#,###.##', 'en_US').format(payment.amount), style: TextStyle(color: colorScheme.onSurface)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
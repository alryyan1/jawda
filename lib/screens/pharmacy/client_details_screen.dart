import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/screens/pharmacy/client_payments_screen.dart';
import 'package:jawda/screens/pharmacy/client_purchases_screen.dart';

class ClientDetailsScreen extends StatefulWidget {
  final Client client;

  ClientDetailsScreen({Key? key, required this.client}) : super(key: key);

  @override
  _ClientDetailsScreenState createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _phoneController = TextEditingController(text: widget.client.phone);
    _addressController = TextEditingController(text: widget.client.address);
    _emailController = TextEditingController(text: widget.client.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality( // Use Directionality for RTL support
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تفاصيل العميل'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الاسم';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle saving the changes (e.g., send data to API)
                      print('Saving changes for client ID: ${widget.client.id}');
                      print('New name: ${_nameController.text}');
                      print('New phone: ${_phoneController.text}');
                      print('New address: ${_addressController.text}');
                      print('New email: ${_emailController.text}');

                      // Close the screen after saving
                      Navigator.pop(context);
                    }
                  },
                  child: Text('حفظ التغييرات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المديونيات والمدفوعات',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientPaymentsScreen(client: widget.client),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('إدارة المديونيات والمدفوعات هنا...'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سجل الشراء',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ClientPurchases(client: widget.client);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('عرض سجل الشراء هنا...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
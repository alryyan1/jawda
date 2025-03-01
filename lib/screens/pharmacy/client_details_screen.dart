import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for number formatting
import 'package:jawda/models/client.dart'; // Import Client model

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Client Details'),
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
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Debits and Credits',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () {
                    
                  }, icon: Icon(Icons.remove_red_eye))
                ],
              ),
              SizedBox(height: 8),
              // Placeholder for debit and credit management UI
              Text('Manage debits and credits here...'),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Purchase History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () {
                    
                  }, icon: Icon(Icons.remove_red_eye))
                ],
              ),
              SizedBox(height: 8),
              // Placeholder for purchase history UI
              Text('View purchase history here...'),
            ],
          ),
        ),
      ),
    );
  }
}
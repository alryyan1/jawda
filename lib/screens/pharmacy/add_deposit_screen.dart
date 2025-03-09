import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/providers/supplier_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddDepositScreen extends StatefulWidget {
  @override
  _AddDepositScreenState createState() => _AddDepositScreenState();
}

class _AddDepositScreenState extends State<AddDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billNumberController = TextEditingController();
  DateTime _billDate = DateTime.now();
  Supplier? _selectedSupplier;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Deposit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _billNumberController,
                decoration: InputDecoration(
                  labelText: 'Bill Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bill number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Bill Date: '),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _billDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );
                      if (pickedDate != null && pickedDate != _billDate) {
                        setState(() {
                          _billDate = pickedDate;
                        });
                      }
                    },
                    child: Text(DateFormat('yyyy-MM-dd').format(_billDate)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Consumer<SupplierProvider>(
                builder: (t, supplierProvider, child) {
                  return DropdownSearch<Supplier>(
                    compareFn: (item1, item2) => item1.id == item2.id,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    itemAsString: (Supplier u) => u.name,
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "Select Supplier",
                        hintText: "Select supplier in menu",
                        prefixIcon: Icon(Icons.local_shipping),
                      ),
                    ),
                    selectedItem: null,
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier  = value;
                      });
                    },
                    items: (filter, loadProps) {
                      // return supplierProvider.fetchSuppliers(context,filter);
                      return supplierProvider.fetchSuppliers(context, filter);
                    }, // Replace with your actual suppliers list
                  );
                },
              ),
              SizedBox(height: 16),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Create a new deposit object
                          final newDeposit = Deposit(
                            id: 0, // The backend should generate the ID
                            supplierId: _selectedSupplier!.id,
                            billNumber: _billNumberController.text,
                            billDate:
                                DateFormat('yyyy-MM-dd').format(_billDate),
                            complete: 0,
                            paid: 0,
                            userId: 1, // Replace with the current user's ID
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            paymentMethod: '',
                            discount: 0,
                            vatSell: 0,
                            vatCost: 0,
                            totalCost: 0,
                            totalPrice: 0,
                            isLocked: 0,
                            showAll: 1,
                            supplier: _selectedSupplier!,
                            user:null, // Replace with the current user's data
                          );

                          try {
                            // Add the deposit using the provider
                         final Deposit freshDeposit =   await Provider.of<DepositProvider>(context,
                                    listen: false)
                                .addDeposit(newDeposit, context);
                                  

                            // Close the screen after adding the deposit
                            Navigator.pop(context);
                          } catch (error) {
                            print('Error adding deposit: $error');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to add deposit: ${error.toString()}')),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add Deposit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

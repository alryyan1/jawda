import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:provider/provider.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item; // Nullable Item for adding a new item
  final int? id;
  AddEditItemScreen({Key? key, this.item, this.id}) : super(key: key);

  @override
  _AddEditItemScreenState createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _marketNameController = TextEditingController();
  final _scNameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _stripsController = TextEditingController();
  bool _isLoading = false;
  Category? _selectedCategory;
  Type? _selectedType;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with item data if editing an existing item
    if (widget.item != null) {
      _marketNameController.text = widget.item!.marketName;
      _scNameController.text = widget.item!.scName;
      _barcodeController.text = widget.item?.barcode ?? '';
      _selectedCategory = widget.item!.category;
      _stripsController.text = widget.item?.strips.toString() ?? '';
      _selectedType = widget.item!.type;
      
    }
  }

  @override
  void dispose() {
    _marketNameController.dispose();
    _scNameController.dispose();
    _barcodeController.dispose();
    _stripsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
      ),
      body: Consumer<ItemProvider>(
        builder: (context, itemProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _marketNameController,
                    decoration: InputDecoration(
                      labelText: 'Market Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shop),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a market name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _scNameController,
                    decoration: InputDecoration(
                      labelText: 'Scientific Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.science),
                    ),
                  ),
                  SizedBox(height: 16),
                      TextFormField(
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.barcode_reader),
                    ),
                  ),
                  SizedBox(height: 16),
                      TextFormField(
                    controller: _stripsController,
                    decoration: InputDecoration(
                      labelText: 'Strips',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.list),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownSearch<Category>(
                    compareFn: (item1, item2) => item1.id == item2.id,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                    ),
                    itemAsString: (Category u) => u.name,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "Select Category",
                        hintText: "Select category in menu",
                      ),
                    ),
                    selectedItem: _selectedCategory,
                    items: (filter, loadProps) {
                      return itemProvider.getCategories(filter, context);
                    }, // Make sure ItemProvider has a 'categories' property
                    onChanged: (Category? data) {
                      setState(() {
                        _selectedCategory = data;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownSearch<Type>(
                    compareFn: (item1, item2) => item1.id == item2.id,

                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                    ),
                    itemAsString: (Type u) => u.name,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "Select Type",
                        hintText: "Select type in menu",
                      ),
                    ),
                    selectedItem: _selectedType,
                    items: (filter, loadProps) {
                      return itemProvider.getTypes(filter, context);
                    }, // Make sure ItemProvider has a 'types' property
                    onChanged: (Type? data) {
                      setState(() {
                        _selectedType = data;
                      });
                    },
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                      child: itemProvider.isLoading
                          ? CircularProgressIndicator()
                          : Text(widget.item == null
                              ? 'Add Item'
                              : 'Save Changes'),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                             
                                final itemProvider = Provider.of<ItemProvider>(
                                    context,
                                    listen: false);

                                if (widget.item == null) {
                                  await itemProvider.addItem({
                                    'barcode': _barcodeController.text,
                                    'batch': "0",
                                    'cost_price': 0,
                                    'expire': "2025-03-03",
                                    'market_name': _marketNameController.text,
                                    'sc_name': _scNameController.text,
                                    'sell_price': 0,
                                    'strips': _stripsController.text,
                                    'drug_category_id':_selectedCategory?.id,
                                    'pharmacy_type_id':_selectedType?.id,
                                  }, context);
                                } else {
                                  await itemProvider.editItem({
                                    'barcode': _barcodeController.text,
                                    'batch': "0",
                                    'cost_price': 0,
                                    'expire': "2025-03-03",
                                    'market_name': _marketNameController.text,
                                    'sc_name': _scNameController.text,
                                    'sell_price': 0,
                                    'strips': _stripsController.text,
                                    'drug_category_id':_selectedCategory?.id,
                                    'pharmacy_type_id':_selectedType?.id,
                                  },context,widget.item?.id);
                                }

                                // Navigator.pop(context);
                              }
                            })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

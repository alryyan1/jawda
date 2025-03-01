import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/client.dart';
import 'package:jawda/models/shift.dart';
import 'package:jawda/providers/client_provider.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import 'package:jawda/screens/pharmacy/report_by_shift.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/pharmacy_models.dart';

// Import your models

class AddItemsToDeductScreen extends StatefulWidget {
  final Deduct deduct;

  AddItemsToDeductScreen({Key? key, required this.deduct}) : super(key: key);

  @override
  _AddItemsToDeductScreenState createState() => _AddItemsToDeductScreenState();
}

class _AddItemsToDeductScreenState extends State<AddItemsToDeductScreen> {
  Client? _selectedClient;
  List<Item> _selectedItems = [];
  List<Client> clients = [];
  List<Item> items = [];
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    Provider.of<ItemProvider>(context, listen: false).getItems('');
  }

  Future<void> _showItemDialog(BuildContext ctx, DeductItem item) async {
    int count = 1; // Initial count
    double totalPrice = item.price * item.box;
    bool _loading = false;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Details: ${item.item?.marketName}'),
          content: StatefulBuilder(
            // Use StatefulBuilder to update the dialog content
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Unit Price: ' + NumberFormat().format(item.price)),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: item.box.toString(),
                    decoration: InputDecoration(labelText: 'Count'),
                    onChanged: (value) async {
                      count = int.tryParse(value) ?? 1;
                      setState(() {
                         
                      totalPrice = item.price * count;
                      });
                      
                    },
                  ),
                  Text('Total Price: ${NumberFormat().format(totalPrice)}'),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: _loading ? CircularProgressIndicator() :  Text('Save'),
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
             try {
                        final dio = DioClient.getDioInstance(context);
                        var response = await dio.patch(
                            'deductedItem/${item.id}',
                            data: {'colName': 'box', 'val': count.toString()});
                        var deductDataAsJson = response.data['data'];
                        // context.watch<ShiftProvider>().updateAndNotify(deductDataAsJson); not working because its outside widget tree
                        ctx
                            .read<ShiftProvider>()
                            .updateAndNotify(deductDataAsJson);
                      } catch (e) {
                        throw Exception(e.toString());
                      }finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                     
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMultiSelectItem(Item item) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_selectedItems.contains(item)) {
            _selectedItems.remove(item);
          } else {
            _selectedItems.add(item);
          }
        });
        print('Tapped on item: ${item.marketName}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: _selectedItems.contains(item) ? Colors.blue.shade100 : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(item.marketName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _selectedDedduct = context.watch<ShiftProvider>().SelectedDeduct;
    return Scaffold(
      appBar: AppBar(
        title: Text(' No ${widget.deduct.number}'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async{
              final dio =  DioClient.getDioInstance(context);
              final response = await dio.get('deduct/invoice',queryParameters: {
                'id':_selectedDedduct?.id.toString(),
                'base64':'1'
              });
              var dataAsJson = response.data;
              final pdfData = base64Decode(cleanBase64(dataAsJson));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                // generateAndShowPdf(api, context, query)
                return MyPdfViewer(pdfData: pdfData, id: _selectedDedduct!.id.toString());
              },));
            },
          ),
        ],
      ),
      body: Consumer2<ClientProvider, ShiftProvider>(
        builder: (context, cleintProvider, shiftProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownSearch<Client>(
                    compareFn: (item1, item2) {
                      return item1.id == item2.id;
                    },
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    itemAsString: (Client u) => u.name,
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "Select Client",
                        hintText: "Select client in menu",
                      ),
                    ),
                    selectedItem: _selectedDedduct?.client,
                    items: (filter, loadProps) {
                      return cleintProvider.getClients(filter);
                    },
                    onChanged: (Client? data) async {
                      try {
                        final dio = DioClient.getDioInstance(context);
                        final response = await dio.patch(
                            'deduct/${_selectedDedduct?.id}',
                            data: {'colName': 'client_id', 'val': data!.id});
                        final json = response.data;
                        shiftProvider.updateAndNotify(json['data']);
                      } catch (e) {
                        throw Exception(e.toString());
                      }
                      // setState(() {
                      _selectedClient = data;
                      // });
                    },
                  ),
                  SizedBox(height: 16),
                  Consumer<ItemProvider>(builder: (context, value, child) {
                    return MultiSelectDialogField<Item>(
                      searchable: true,
                      items: value.items
                          .map((item) =>
                              MultiSelectItem<Item>(item, item.marketName))
                          .toList(),
                      selectedColor: Colors.blue.shade100,
                      onConfirm: (values) {
                        _selectedItems = values;
                        // print(value.items);
                      },
                      title: Text("Select Items"),
                      buttonText: Text(
                        "Select Items",
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Selected Items',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Consumer<ShiftProvider>(
                      builder: (context, shiftProvider, child) {
                    final selectedDeduct = shiftProvider.SelectedDeduct;
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: selectedDeduct!.deductedItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final deductItem = selectedDeduct!.deductedItems[index];
                        return ListTile(
                            // style: ListTileStyle.drawer,
                            leading: Icon(Icons.shopping_cart),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('U.Price ${deductItem.price} '),
                                Text('Box ${deductItem.box} '),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text(NumberFormat()
                                    .format(deductItem.price * deductItem.box)),
                                //delete icon btn
                                Expanded(
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        setState(() {
                                          _selectedItems.remove(deductItem);
                                        });
                                        await context
                                            .read<ShiftProvider>()
                                            .deleteDeductItem(deductItem,context);
                                      }),
                                )
                              ],
                            ),
                            title: Text(deductItem.item!.marketName),
                            onTap: () async {
                              await _showItemDialog(context, deductItem);
                            });
                      },
                    );
                  }),
                  ElevatedButton(
                    onPressed: _isLoading || _selectedDedduct?.complete == 1
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await context
                                .read<ShiftProvider>()
                                .saveDeductItems(_selectedItems, widget.deduct,context);
                            // Handle adding items logic here (e.g., send data to API)
                            // await _addItemsToDeduct();
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context)
                                .pop(); // Navigate back to previous screen when done
                            print(
                                'Adding items to deduct ID: ${widget.deduct.id}');
                            print('Selected client: ${_selectedClient?.name}');
                            print(
                                'Selected items: ${_selectedItems.map((item) => item.marketName).toList()}');
                          },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Add Items'), // i want to reach the notifier here what  the best way to do it
                  ),
                  widget.deduct.deductedItems.length > 0
                      ? DeductComplete(deduct: _selectedDedduct!)
                      : Text('No Items')
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _getItems() async {
    items = context.read<ItemProvider>().items;
  }
}

class DeductComplete extends StatelessWidget {
  final Deduct deduct;
  DeductComplete({super.key, required this.deduct});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShiftProvider>(builder: (context, shftProvider, child) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), border: Border.all()),
            child: Center(
              child: Text('Invoice'),
            ),
          ),
          ListTile(
            title: Text('Total'),
            trailing: Text(NumberFormat().format(deduct.totalPrice)),
          ),
          Divider(),
          SizedBox(
            width: double.infinity,
            child:deduct.complete == 1 ?  ElevatedButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
              onPressed: () async {
                try {
                  final dio = DioClient.getDioInstance(context);
                  final response = await dio.get(
                      'inventory/deduct/cancel/${deduct.id}',
                      );
                  shftProvider.updateAndNotify(response.data['data']);
                } on DioException catch (e) {
                  
                }
              },
              child: Text('Cancel'),
            ): ElevatedButton(
              onPressed: () async {
                try {
                  final dio = DioClient.getDioInstance(context);
                  final response = await dio.get(
                      'inventory/deduct/complete/${deduct.id}',
                      queryParameters: {'is_sell': '1'});
                  shftProvider.updateAndNotify(response.data['data']);
                } catch (e) {
                  throw Exception(e.toString());
                }
              },
              child: Text('COMPLETE'),
            ),
          )
        ],
      );
    });
  }
}

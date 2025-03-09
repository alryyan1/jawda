import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/providers/item_provider.dart';
import 'package:jawda/providers/shift_provider.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:provider/provider.dart'; // Import Item and Deposit models
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PurchaseItemsScreen extends StatefulWidget {
  final Deposit deposit;

  const PurchaseItemsScreen({Key? key, required this.deposit})
      : super(key: key);

  @override
  State<PurchaseItemsScreen> createState() => _PurchaseItemsScreenState();
}

class _PurchaseItemsScreenState extends State<PurchaseItemsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ItemProvider>().getItems('');
    getDeposit();
  }

   void getDeposit(){

    context.read<DepositProvider>().getDeposit(widget.deposit.id,context);
   }
  Future<void> _showItemDialog(BuildContext ctx, DepositItem item) async {
    int quantity = item.quantity; // Initial count
    bool _loading = false;
    int  cost = item.cost.toInt() ;
    int  rprice = item.sellPrice.toInt();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Details: ${item.item?.marketName}'),
          content: StatefulBuilder(
            // Use StatefulBuilder to update the dialog content
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: item.quantity.toString(),
                      decoration: InputDecoration(labelText: 'QYN'),
                      onChanged: (value) async {
                        quantity = int.tryParse(value) ?? 1;
                      },
                    ),
                       TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: item.cost.toString(),
                      decoration: InputDecoration(labelText: 'Cost'),
                      onChanged: (value) async {
                        cost = int.tryParse(value) ?? 1;
                
                      },
                    ),
                        TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: item.sellPrice.toString(),
                      decoration: InputDecoration(labelText: 'R.Price'),
                      onChanged: (value) async {
                        rprice = int.tryParse(value) ?? 1;
                
                      },
                    ),
                  ],
                ),
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
              child: _loading ? CircularProgressIndicator() : Text('Save'),
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                try {
                  final dio = DioClient.getDioInstance(context);
                  var response = await dio.patch('depositItems/updateMobile/${item.id}',
                      data: {'cost': cost.toString(), 'sell_price': rprice.toString(),'quantity':quantity.toString()});
                  var depositsAsJson = response.data['data'];
                  context.read<DepositProvider>().setSelectedDeposit(Deposit.fromJson(depositsAsJson));
                  // ctx.read<DepositProvider>().updateDepositItem(deductDataAsJson);
                  // context.read<SocketProvider>().sendMessage('update deduct', jsonEncode(deductDataAsJson));
                } catch (e) {
                  throw Exception(e.toString());
                } finally {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final depositProvider =
        Provider.of<DepositProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final dio = DioClient.getDioInstance(context);
              final response = await dio.get('deposit-invoice',
                  queryParameters: {
                    'base64': '1',
                    'id': widget.deposit.id.toString()
                  });
              if (response.statusCode == 200) {
                final pdfRaw = response.data;
                final cleanedRaw = cleanBase64(pdfRaw);
                final pdfUnit8 = base64Decode(cleanedRaw);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      MyPdfViewer(pdfData: pdfUnit8, id: widget.deposit.id.toString()),
                ));
              }
              // Navigate to AddItemScreen with the deposit as a parameter
            },
          ),
        ],
        title: Text('Bill #${widget.deposit.billNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supplier: ${widget.deposit.supplier.name}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface),
            ),
            SizedBox(height: 8),
            Text('Bill Date: ${widget.deposit.billDate}',
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
            Text('Payment Method: ${widget.deposit.paymentMethod}',
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
            SizedBox(height: 16),
            Text(
              'Items:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface),
            ),
            SizedBox(height: 16),
            MultiSelectDialogField<Item>(
              // chipDisplay: MultiSelectChipDisplay.none(),
              searchable: true,

              items: Provider.of<ItemProvider>(context)
                  .items
                  .map((item) => MultiSelectItem<Item>(item, item.marketName))
                  .toList(),
              selectedColor: Colors.blue.shade100,
              onConfirm: (values) async {
                await context
                    .read<DepositProvider>()
                    .saveDepositItems(values, widget.deposit, context);

                print(values.map((e) => e.marketName).toList());
              },
              title: Text("Select Items"),
              buttonText: Text(
                "Select Items",
                style: TextStyle(color: Colors.blue[800]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Items',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Consumer<DepositProvider>(
                builder: (context, depositProvider, child) {
              final selectedDeposit = depositProvider.selectedDeposit;
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: selectedDeposit.items?.length ?? 0,
                  shrinkWrap: false,
                  itemBuilder: (context, index) {
                    final depositItem = selectedDeposit.items![index];
                    return ListTile(
                        // style: ListTileStyle.drawer,
                        leading: Container(
                          child: Text("${index + 1}"),
                        ),
                        // isThreeLine: true,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('U.Price ${depositItem.cost} '),
                            // Text('Box ${deductItem.box} '),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(NumberFormat().format(
                                depositItem.cost * depositItem.quantity)),
                            //delete icon btn
                            Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    // setState(() {
                                    //   _selectedItems.remove(deductItem);
                                    // });
                                    // await context
                                    //     .read<ShiftProvider>()
                                    //     .deleteDeductItem(
                                    //         deductItem, context);
                                  }),
                            )
                          ],
                        ),
                        title: Text(depositItem.item!.marketName +
                            ' ' +
                            "(${depositItem.quantity.toString()})"),
                        onTap: () async {
                          await _showItemDialog(context, depositItem);
                        });
                  },
                ),
              );
            }),
            SizedBox(height: 8),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cost:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface)),
                Text(
                    NumberFormat('#,###.##', 'en_US')
                        .format(widget.deposit.totalCost ?? 0),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount:',
                    style: TextStyle(
                        fontSize: 16, color: colorScheme.onSurfaceVariant)),
                Text(NumberFormat('#,###.##', 'en_US').format(widget.deposit.discount),
                    style: TextStyle(
                        fontSize: 16, color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

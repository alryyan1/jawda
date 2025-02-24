import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/shift.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import 'package:pdfrx/pdfrx.dart';

class ShiftDeducts extends StatefulWidget {
  final int id;
  const ShiftDeducts({Key? key, required this.id}) : super(key: key);

  @override
  _ShiftDeductsState createState() => _ShiftDeductsState();
}

class _ShiftDeductsState extends State<ShiftDeducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Transactions'),
      ),
      body: FutureBuilder<Shift>(
        future: Shift.getShiftById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final Shift shift = snapshot.data!;
          return Column(
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Shift Details ${DateFormat('yyyy-MM-dd hh:mm a').format(shift.created_at)}'),
                    TextButton(
                        onPressed: ()async {
                          var pdf =  await generateAndShowPdf(
                              '/pharmacy/sellsReport', context, {'shift_id': shift.id.toString(),'base64':'1'});
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPdfViewer(id: shift.id.toString(),pdfData: pdf,);
                              },
                            ),
                          );
                        },
                        child: Text('PDF'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: shift.deducts.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(), // Add Divider
                  itemBuilder: (context, index) {
                    final deduct = shift.deducts[index];
                    return ListTile(
                      leading: Icon(Icons.person), // Add user icon on the left
                      title: Text('No: ${deduct.number}'), // Add deduct Id
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Total Paid: ${NumberFormat().format(deduct.totalPaid)} SDG',style: TextStyle(fontWeight: FontWeight.bold),), // Show the amount
                        ],
                      ),

                      trailing: IconButton(
                        icon: Icon(Icons.remove_red_eye), // Add details icon
                        onPressed: () {

                          showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: Text('Sold Items'),
                                content: ListView.separated(
                                  separatorBuilder: (context, index) {
                                     return Divider(); // Add Divider
 
                                  },
                                  itemCount: deduct.deductedItems.length,
                                  itemBuilder: (context, index) {
                                  
                                  final item = deduct.deductedItems[index];
                                  return ListTile(
                                    leading: Icon(Icons.add_box),
                                    title: Text( '${item.item!.marketName} '),
                                    subtitle: Text( "${NumberFormat().format(item.price)} 💵" ),
                                  );
                                },), // Show the amount in the dialog
                            ); 
                          },);
                          // Handle details button press (e.g., navigate to details screen)
                          print(
                              'Details button pressed for deduct ID: ${deduct.id}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/Shift.dart';
import 'package:jawda/models/shift_deduct_summary.dart';
import 'package:jawda/screens/pharmacy/shift_deducts.dart';

class ReportByShift extends StatefulWidget {
  const ReportByShift({super.key});

  @override
  State<ReportByShift> createState() => _ReportByShiftState();
}

class _ReportByShiftState extends State<ReportByShift> {
  final DateTime _date = DateTime.now();
  bool _loading = false;
  List<ShiftDeductSummary> _shifts = List.empty();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Report by shift'),
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                    initialDate: _date,
                    context: context,
                    firstDate: _date.subtract(Duration(days: 60)),
                    lastDate: DateTime(2040));
                if (selectedDate != null && selectedDate != _date) {
                  setState(() {
                    _loading = true;
                  });
                  _shifts = await Shift.getShiftDeductsSummaries(selectedDate); //
                  setState(() {
                    _loading = false;
                  });
                }
              },
              child: Text(
                DateFormat('yyyy-MM-dd').format(_date),
              ),
            ),
            Center(
                child: _loading
                    ? CircularProgressIndicator()
                    : ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: _shifts.length,
                      shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final ShiftDeductSummary shift = _shifts[index];
                          return ListTile(
                            trailing: IconButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return ShiftDeducts(id: shift.id);
                              },));
                            }, icon: Icon(Icons.remove_red_eye)),
                            title: Text(
                              DateFormat('yyyy-MM-dd hh:mm a ').format(shift.created_at),

                            ),
                            subtitle: Text("${NumberFormat().format(shift.fullTotal)} SDG",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
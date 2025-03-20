import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jawda/constansts.dart';
import 'package:jawda/models/petty_cash.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:jawda/services/sockets.dart';

class AddPettyCashScreen extends StatefulWidget {
  const AddPettyCashScreen({Key? key}) : super(key: key);

  @override
  _AddPettyCashScreenState createState() => _AddPettyCashScreenState();
}

class _AddPettyCashScreenState extends State<AddPettyCashScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _beneficiaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _beneficiaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(  // Wrap with Directionality for RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إضافة مصروفات نقدية'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'المبلغ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال المبلغ';
                    }
                    if (double.tryParse(value) == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _beneficiaryController,
                  decoration: InputDecoration(
                    labelText: 'المستفيد',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المستفيد';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,  // Align to the right for RTL
                  children: [
                    Text('التاريخ: '),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(intl.DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'البيان',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      final newExpense = Expense(
                        id: 0, // The backend should generate the ID
                        date: _selectedDate,
                        amount: _amountController.text,
                        beneficiary: _beneficiaryController.text,
                        description: _descriptionController.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        entry: null,
                        financeEntryId: 0,
                        userId: 0,
                        signatureFileName: "",
                     
                      );

                      try {
                        final dio =  DioClient.getDioInstance(context);
                        final response = await dio.post('petty-cash-permissions',data: jsonEncode({
                          "date": _selectedDate.toIso8601String(),
                          "amount": newExpense.amount,
                          "beneficiary": newExpense.beneficiary,
                          "description": newExpense.description,
                          "userId": 0, // Replace with the actual user ID
                        }));
                        if (response.statusCode == 201) {
                          final dataAsJson = response.data;
                          String message = "تمت اضافه اذن الصرف";
                          final newExpense = Expense.fromJson(dataAsJson['data']);
                          sendNotification(newExpense.id.toString(), message, 'اذن صرف جديد');
                          // Navigator.pop(context); // Go back to the list screen
                        }
                      } catch (error) {
                        print('Error adding expense: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('فشل في إضافة المصروف: ${error.toString()}')),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: _isLoading ? CircularProgressIndicator() : Text('إضافة مصروف'),
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
      ),
    );
  }
}
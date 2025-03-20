import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jawda/constansts.dart';
import 'package:jawda/models/petty_cash.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:http/http.dart' as http;

class PettyApproveScreen extends StatefulWidget {
  Expense? expense;
  String? id;
  void Function(Expense expense)? onUpdate;
  PettyApproveScreen(
      {Key? key, required this.expense, required this.onUpdate, this.id})
      : super(key: key);

  @override
  _PettyApproveScreenState createState() => _PettyApproveScreenState();
}

class _PettyApproveScreenState extends State<PettyApproveScreen> {
  bool _loading = false;
  bool _loadingManager = false;
  bool _loadingAuditor = false;
  DateTime? _managerApprovalTime;
  DateTime? _auditorApprovalTime;

  @override
  void initState() {
    super.initState();
    _managerApprovalTime = widget.expense?.managerApprovalTime;
    _auditorApprovalTime = widget.expense?.auditorApprovalTime;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id != null) {
        _fetchExpense(widget.id);
      }
    });
  }

  Future<void> _fetchExpense(String? id) async {
    setState(() {
      _loading = true;
    });

    try {
      final dio = DioClient.getDioInstance(context);

      final response = await dio.get('petty-cash-permissions/$id');

      if (response.statusCode == 200) {
        setState(() {
          final newExpense = Expense.fromJson(response.data);
          widget.expense = newExpense;
          _managerApprovalTime = newExpense.managerApprovalTime;
          _auditorApprovalTime = newExpense.auditorApprovalTime;
        });

        // final newExpense = Expense.fromJson(response.data['data']);
        if (widget.onUpdate != null) {
          widget.onUpdate!(widget.expense!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _approveExpense(
      {required String colName, required String name}) async {
    setState(() {
      if (colName == 'user_approved_time') {
        _loadingManager = true;
      } else {
        _loadingAuditor = true;
      }
    });

    try {
      final dio = DioClient.getDioInstance(context);

      final response = await dio
          .get('expense-approve/${widget.expense?.id}?colName=$colName');

      if (response.statusCode == 200) {
        setState(() {
          if (colName == 'user_approved_time') {
            _managerApprovalTime = DateTime.now();
          } else {
            _auditorApprovalTime = DateTime.now();
          }

          String message =
              "  تم اعتماد اذن الصرف رقم  ${widget.expense!.id} من قبل ${name} ";
          sendNotification(
              widget.expense!.id.toString(), message, 'اعتماد اذن الصرف');
        });

        final newExpense = Expense.fromJson(response.data['data']);
        if (widget.onUpdate != null) {
          widget.onUpdate!(newExpense);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to approve: ${response.statusCode}')));
      }
    } catch (e) {
      
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        if (colName == 'user_approved_time') {
          _loadingManager = false;
        } else {
          _loadingAuditor = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      // Use Directionality for RTL support
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اعتماد المصروفات'),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expense Details
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'تفاصيل المصروفات',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface),
                                ),
                                SizedBox(height: 8),
                                Text("اذن رقم  ${widget.expense?.id}",style: Theme.of(context).textTheme.displaySmall,),
                                Text(
                                  'المبلغ: ${intl.NumberFormat('#,###.##', 'ar_SA').format(double.parse(widget.expense?.amount ?? " 0.0"))}',
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                                Text('المستفيد: ${widget.expense?.beneficiary}',
                                    style: TextStyle(
                                        color: colorScheme.onSurfaceVariant)),
                                Text(
                                  'التاريخ: ${intl.DateFormat('yyyy-MM-dd').format(widget.expense?.date ?? DateTime(2025))}',
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  'البيان: ${widget.expense?.description}',
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Manager Approval
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'اعتماد المدير العام',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface),
                            ),
                            Text('أكرم عبد الوهاب',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant)),
                            if (_managerApprovalTime != null)
                              Text(
                                'تم الاعتماد في: ${intl.DateFormat('yyyy-MM-dd HH:mm').format(_managerApprovalTime!)}',
                                style: TextStyle(color: Colors.green),
                              ),
                            ElevatedButton(
                              onPressed: _loadingManager ||
                                      _managerApprovalTime != null
                                  ? null
                                  : () async {
                                      await _approveExpense(
                                        colName: 'user_approved_time',
                                        name: 'المدير العام',
                                      );
                                    },
                              child: _loadingManager
                                  ? CircularProgressIndicator()
                                  : Text('اعتماد'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Financial Auditor Approval
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'اعتماد المدقق المالي',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface),
                            ),
                            Text('محمد بشير',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant)),
                            if (_auditorApprovalTime != null)
                              Text(
                                'تم الاعتماد في: ${intl.DateFormat('yyyy-MM-dd HH:mm').format(_auditorApprovalTime!)}',
                                style: TextStyle(color: Colors.green),
                              ),
                            ElevatedButton(
                              onPressed: _loadingAuditor ||
                                      _auditorApprovalTime != null
                                  ? null
                                  : () async {
                                      await _approveExpense(
                                          colName: 'auditor_approved_time',
                                          name: 'المراجع');
                                    },
                              child: _loadingAuditor
                                  ? CircularProgressIndicator()
                                  : Text('اعتماد'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.secondary,
                                foregroundColor: colorScheme.onSecondary,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
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

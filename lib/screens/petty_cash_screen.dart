import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/petty_cash.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import 'package:jawda/screens/petty_approve_screen.dart';
import 'package:jawda/screens/pharmacy/add_deposit_screen.dart';
import 'package:jawda/screens/pharmacy/deposit_items_screen.dart';
import 'package:jawda/screens/signature_screen.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:provider/provider.dart';

class PettyCashScreen extends StatefulWidget {
  const PettyCashScreen({Key? key}) : super(key: key);

  @override
  _PettyCashScreenState createState() => _PettyCashScreenState();
}

class _PettyCashScreenState extends State<PettyCashScreen> {
  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  List<Expense> _expenses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  void _onScroll() {
    if (_isBottom && !_isLoadingMore && _hasMoreData) {
      _loadMoreData();
    }
  }

  Uint8List? _signatureImage;

  Future<void> uploadImage(Uint8List _data, int expenseId) async {
    //convert data from Uint8List to base64
    try {
      final base64 = base64Encode(_data);
      final dio = DioClient.getDioInstance(context);
      final response = await dio.post('saveSignatureImage/${expenseId}',
          data: {'signatureImage': base64});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //dispose
  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _addSignature(int expenseId) async {
    final signature = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignatureScreen()),
    );

    if (signature != null && signature is Uint8List) {
      await uploadImage(signature, expenseId);
      setState(() {
        _signatureImage = signature;
      });
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
    // Trigger load when reaching 90% of the bottom
  }

  bool loadingIntial = false;
  bool _loading = false;
  String? _errorMessage;

  Future<List<Expense>> _getData([int page = 1]) async {
    try {
      _loading = true;
      _errorMessage = null;
      //  notifyListeners();
      //dio
      final dio = DioClient.getDioInstance(context);
      final response = await dio.get('petty-cash-permissions',
          queryParameters: {'page': page.toString()});

      final dataAsJson = response.data;
      final depositsAsJson = dataAsJson['data'] as List<dynamic>;
      return depositsAsJson.map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      _errorMessage = 'Failed to fetch deposits: $e';
      print(_errorMessage);
      throw Exception(e.toString());
    } finally {
      _loading = false;
      //  notifyListeners();
    }
  }

  Future<void> _loadInitialData() async {
    // Load the initial data
    setState(() {
      loadingIntial = true;
    });
    final data = await _getData();
    if (mounted) {
      setState(() {
        _expenses = data;
        // _expenses
        loadingIntial = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;

    try {
      final newDeposits = await _getData(_currentPage);
      if (newDeposits != null && newDeposits.isNotEmpty) {
        setState(() {
          //   _deposits.addAll(newDeposits);
          _expenses.addAll(newDeposits);
        });
      } else {
        setState(() {
          _hasMoreData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load more data: ${e.toString()}'),
          ),
        );
      }

      _currentPage--; // Revert to the previous page
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  onExpenseUpdated(Expense newExpense) {
    setState(() {
      _expenses = _expenses.map((e) {
        if (e.id == newExpense.id) {
          return newExpense;
        } else {
          return e;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('اذونات الصرف'),
      ),
      body: loadingIntial
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.0),
                  itemCount: _expenses.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final expense = _expenses[index];
                    return InkWell(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return PettyApproveScreen(
                              expense: expense,
                              onUpdate: onExpenseUpdated,
                            );
                          },
                        ));
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: colorScheme.surface,
                        child: ListTile(
                          isThreeLine: true,
                          leading: IconButton(
                              onPressed: () async {
                                final dio = DioClient.getDioInstance(context);
                                final response = await dio.get(
                                    'pettycash2/${expense.id}',
                                    queryParameters: {
                                      'base64': '1',
                                      'id': expense.id.toString()
                                    });
                                if (response.statusCode == 200) {
                                  final pdfRaw = response.data;
                                  final cleanedRaw = cleanBase64(pdfRaw);
                                  final pdfUnit8 = base64Decode(cleanedRaw);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyPdfViewer(
                                        pdfData: pdfUnit8,
                                        id: expense.id.toString()),
                                  ));
                                }
                              },
                              icon: Icon(Icons.picture_as_pdf)),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'رقم الاذن (${expense.id})  ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface),
                              ),
                              Container(
                                height: 100,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        ' (${expense.description}) ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface),
                                      ),
                                      Divider(),
                                      Row(
                                        spacing: 4,
                                        children: [
                                          expense.managerApprovalTime != null
                                              ? Badge(
                                                padding: EdgeInsets.all(5),
                                                backgroundColor: Colors.green,
                                                  label: Text('اكرم عبد الوهاب'),
                                                )
                                              : SizedBox(),
                                                expense.auditorApprovalTime != null
                                              ? Badge(
                                                padding: EdgeInsets.all(5),
                                                  label: Text('محمد بشير'),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                      expense.pdfFile == null ? SizedBox() : ElevatedButton(
                              onPressed: () async {
                                final dio = DioClient.getDioInstance(context);
                                final response = await dio.get(
                                    'get-base64-petty/${expense.id}',
                                    queryParameters: {
                                      'base64': '1',
                                      'id': expense.id.toString()
                                    });
                                if (response.statusCode == 200) {
                                  final pdfRaw = response.data;
                                  final cleanedRaw = cleanBase64(pdfRaw);
                                  final pdfUnit8 = base64Decode(cleanedRaw);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyPdfViewer(
                                        pdfData: pdfUnit8,
                                        id: expense.id.toString()),
                                  ));
                                }
                              },
                              child: Text('المستند')),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Amount: ${NumberFormat('#,###.##', 'en_US').format(double.parse(expense.amount))}',
                            style:
                                TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.border_color_rounded),
                            onPressed: () {
                              _addSignature(expense.id);
                            },
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    );
                  },
                ),
                _isLoadingMore
                    ? Positioned(
                        child: CircularProgressIndicator(),
                        top: 20,
                        left: (MediaQuery.of(context).size.width / 2) - 10,
                      )
                    : SizedBox(),
              ],
            ),
    );
  }
}

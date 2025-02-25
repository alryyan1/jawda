
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/SaleDateInfo.dart';

class SaledateinfoList extends StatefulWidget {
  @override
  _SaledateinfoListState createState() => _SaledateinfoListState();
}

class _SaledateinfoListState extends State<SaledateinfoList> {
  List<Saledateinfo> _data = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; 
    });
    try {
      _data = await Saledateinfo.getData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Information'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    final previousAmount = index > 0 ? _data[index - 1].amount : null;
                    final difference = previousAmount != null ? item.amount - previousAmount : 0;

                    return Column(
                      children: [
                        ListTile(
                          
                          title: Text(DateFormat('yyyy-MM-dd').format(item.date)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Amount: ${NumberFormat('#,###').format(item.amount)}'),
                                  SizedBox(width: 5),
                                  if (previousAmount != null)
                                    Icon(
                                      difference > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: difference > 0 ? Colors.green : Colors.red,
                                    ),
                                  if (previousAmount != null)
                                    Text(
                                      '(${difference > 0 ? '+' : ''}${NumberFormat('#,###').format(difference)})',
                                      style: TextStyle(
                                        color: difference > 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                              Text('Count: ${item.count}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.details),
                                onPressed: () {
                                  // Handle details button press (navigate to details screen)
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                ),
    );
  }
}
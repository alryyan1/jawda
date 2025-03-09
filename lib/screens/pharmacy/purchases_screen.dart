import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/providers/deposit_provider.dart';
import 'package:jawda/screens/pharmacy/add_deposit_screen.dart';
import 'package:jawda/screens/pharmacy/deposit_items_screen.dart';
import 'package:provider/provider.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  // List<Deposit> _deposits = [];
  Future<List<Deposit>> _getData() async {
    final depositProvider =
        Provider.of<DepositProvider>(context, listen: false);
    return depositProvider.fetchDeposits(context, 1);
  }

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

  //dispose
  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
    // Trigger load when reaching 90% of the bottom
  }

  bool loadingIntial = false;

  Future<void> _loadInitialData() async {
    // Load the initial data
    setState(() {
      loadingIntial = true;
    });
    final data = await Provider.of<DepositProvider>(context, listen: false)
        .fetchDeposits(context, 1);
    if (mounted) {
      setState(() {
        // _deposits = data;
        Provider.of<DepositProvider>(context, listen: false)
            .setLoadedDeposits(data);
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
    final depositProvider =
        Provider.of<DepositProvider>(context, listen: false);
    try {
      final newDeposits =
          await depositProvider.fetchDeposits(context, _currentPage);
      if (newDeposits != null && newDeposits.isNotEmpty) {
        // setState(() {
        //   _deposits.addAll(newDeposits);
        // });
        depositProvider.addDeposits(newDeposits);
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _deposits = Provider.of<DepositProvider>(context).loadedDeposits;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Refresh the data
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddDepositScreen(),
              ));
            },
          )
        ],
        title: Text('Purchases'),
      ),
      body: loadingIntial
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.0),
                  itemCount: _deposits.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final deposit = _deposits[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: colorScheme.surface,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          child:
                              Icon(Icons.shopping_cart), // Use a relevant icon
                        ),
                        title: Text(
                          deposit.supplier.name + ' ' + deposit.id.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          'Amount: ${NumberFormat('#,###.##', 'en_US').format(deposit.totalCost ?? 0)}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            context
                                .read<DepositProvider>()
                                .setSelectedDeposit(deposit);
                            // Handle details button press (e.g., navigate to details screen)
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PurchaseItemsScreen(deposit: deposit),
                            ));
                            print(
                                'Details button pressed for deposit ID: ${deposit.id}');
                          },
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import '../models/finance_account.dart';

class AddEntryForm extends HookWidget {
  final VoidCallback onEntryAdded;

  AddEntryForm({Key? key, required this.onEntryAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final descriptionController = useTextEditingController();
    final dateState = useState(DateTime.now());
    final debitAccountState = useState<FinanceAccount?>(null);
    final creditAccountState = useState<FinanceAccount?>(null);
    final debitAmountController = useTextEditingController();
    final creditAmountController = useTextEditingController();

    final balanceErrorState = useState('');
    final isLoadingState = useState(false);
    final accountsState = useState<List<FinanceAccount>>([]);

    useEffect(() {
      Future<void> fetchAccounts() async {
        final url = Uri.parse('your_laravel_api_url/financeAccounts');  // Replace with your API endpoint
        try {
          final response = await http.get(url);

          if (response.statusCode == 200) {
            final List<dynamic> decodedData = json.decode(response.body);
            accountsState.value = decodedData.map((item) => FinanceAccount.fromJson(item)).toList();
          } else {
            print('Failed to load accounts: ${response.statusCode}');
          }
        } catch (error) {
          print('Error fetching accounts: $error');
        }
      }

      fetchAccounts();
      return () {};
    }, []);

    final isDebitOptionDisabled = useCallback((FinanceAccount option) {
      return creditAccountState.value?.id == option.id || option.children.isNotEmpty;
    }, [creditAccountState.value]);

    final isCreditOptionDisabled = useCallback((FinanceAccount option) {
      return debitAccountState.value?.id == option.id || option.children.isNotEmpty;
    }, [debitAccountState.value]);

    final submitHandler = useCallback(() async {
      // Validate balance before submission
      final double debitAmount = double.tryParse(debitAmountController.text) ?? 0;
      final double creditAmount = double.tryParse(creditAmountController.text) ?? 0;

      if (debitAmount != creditAmount) {
        balanceErrorState.value = 'Debits and credits must balance.';
        return;
      } else {
        balanceErrorState.value = '';
      }

      isLoadingState.value = true;
      try {
        final formattedDate = DateFormat('yyyy-MM-dd').format(dateState.value);

        final url = Uri.parse('your_laravel_api_url/createFinanceEntries');  // Replace with your API endpoint
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'description': descriptionController.text,
            'date': formattedDate,
            'debits': [
              {'account': debitAccountState.value?.id, 'amount': debitAmount.toString()}
            ],
            'credits': [
              {'account': creditAccountState.value?.id, 'amount': creditAmount.toString()}
            ],
          }),
        );

        if (response.statusCode == 200) {
          // Reset the form
          descriptionController.clear();
          dateState.value = DateTime.now();
          debitAccountState.value = null;
          creditAccountState.value = null;
          debitAmountController.clear();
          creditAmountController.clear();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Entry added successfully!'),
          ));
          onEntryAdded(); // Notify the parent to refresh the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add entry'),
          ));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred: $error'),
        ));
      } finally {
        isLoadingState.value = false;
      }
    }, [dateState.value, descriptionController.text, debitAccountState.value, creditAccountState.value, debitAmountController.text, creditAmountController.text]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Entry',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Entry Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('Date: '),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dateState.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                  );
                  if (pickedDate != null && pickedDate != dateState.value) {
                    dateState.value = pickedDate;
                  }
                },
                child: Text(DateFormat('yyyy-MM-dd').format(dateState.value)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Debit Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownSearch<FinanceAccount>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              disabledItemFn: isDebitOptionDisabled,
            ),
            itemAsString: (FinanceAccount u) => u.name,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Select Debit Account",
                hintText: "Select account",
              ),
            ),
            selectedItem: debitAccountState.value,
            items: accountsState.value,
            onChanged: (FinanceAccount? data) {
              debitAccountState.value = data;
            },
          ),
          TextFormField(
            controller: debitAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Debit Amount',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Credit Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownSearch<FinanceAccount>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              disabledItemFn: isCreditOptionDisabled,
            ),
            itemAsString: (FinanceAccount u) => u.name,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Select Credit Account",
                hintText: "Select account",
              ),
            ),
            selectedItem: creditAccountState.value,
            items: accountsState.value,
            onChanged: (FinanceAccount? data) {
              creditAccountState.value = data;
            },
          ),
          TextFormField(
            controller: creditAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Credit Amount',
              border: OutlineInputBorder(),
            ),
          ),
          if (balanceErrorState.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                balanceErrorState.value,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(
            onPressed: isLoadingState.value ? null : submitHandler,
            child: isLoadingState.value ? CircularProgressIndicator() : Text('Save'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/patient_models.dart';
import 'package:jawda/providers/lab_provider.dart';
import 'package:provider/provider.dart';
class LabTestsScreen extends StatefulWidget {
  @override
  _LabTestsScreenState createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends State<LabTestsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch tests when the widget is first built
    Future.microtask(() {
      final labProvider = Provider.of<LabProvider>(context, listen: false);
      labProvider.getTests(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Tests'),
        actions: [
          // Search bar
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TestSearchDelegate(
                    Provider.of<LabProvider>(context, listen: false)),
              );
            },
          ),
        ],
      ),
      body: Consumer<LabProvider>(
        builder: (context, labProvider, child) {
          if (labProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (labProvider.errorMessage != null) {
            return Center(child: Text(labProvider.errorMessage!));
          }

          if (labProvider.tests.isEmpty) {
            return Center(child: Text('No tests found.'));
          }

          return ListView.builder(
            itemCount: labProvider.tests.length,
            itemBuilder: (context, index) {
              final test = labProvider.tests[index];
              return ListTile(
                title: Text(test.mainTestName),
                subtitle: Text(NumberFormat().format(test.price)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the test
                    labProvider.deleteTest(test.id.toString());
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh the tests list when the button is pressed
          final labProvider = Provider.of<LabProvider>(context, listen: false);
          labProvider.getTests(context);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

// Custom Search Delegate for searching tests
class TestSearchDelegate extends SearchDelegate<String> {
  final LabProvider labProvider;

  TestSearchDelegate(this.labProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 'null');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    labProvider.searchTests(query);
    return Consumer<LabProvider>(
      builder: (context, labProvider, child) {
        return ListView.builder(
          itemCount: labProvider.tests.length,
          itemBuilder: (context, index) {
            final test = labProvider.tests[index];
            return ListTile(
              title: Text(test.mainTestName),
              subtitle: Text(NumberFormat().format(test.price)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    labProvider.searchTests(query);
    return Consumer<LabProvider>(
      builder: (context, labProvider, child) {
        return ListView.builder(
          itemCount: labProvider.tests.length,
          itemBuilder: (context, index) {
            final test = labProvider.tests[index];
            return ListTile(
              title: Text(test.mainTestName),
              subtitle: Text(NumberFormat().format(test.price)),
              onTap: () {
                close(context, test.mainTestName);
              },
            );
          },
        );
      },
    );
  }
}
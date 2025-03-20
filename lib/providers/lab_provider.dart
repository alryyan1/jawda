import 'package:flutter/material.dart';
import 'package:jawda/models/patient_models.dart';
import 'package:jawda/services/dio_client.dart';

class LabProvider with ChangeNotifier {
  String? _errorMessage;
  List<MainTest> _tests = [];
  bool _isLoading = false;
  List<MainTest> _filteredTests = []; // For search functionality
  String _searchQuery = '';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<MainTest> get tests => _tests;

  Future<void> getTests(BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners(); // Notify listeners that loading has started

      final dio = DioClient.getDioInstance(context);
      final response = await dio.get('tests');

      if (response.statusCode == 200) {
        final dataAsJson = response.data;
        _tests = (dataAsJson as List)
            .map((json) => MainTest.fromJson(json))
            .toList();
      } else {
        _errorMessage = 'Error fetching data';
      }
    } catch (e) {
      _errorMessage = 'Error fetching data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished
    }
  }
  void deleteTest(String testId) {
    _tests.removeWhere((test) => test.id == testId);
    _filteredTests.removeWhere((test) => test.id == testId);
    notifyListeners();
  }

  void searchTests(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredTests = _tests; // Show all tests if query is empty
    } else {
      _filteredTests = _tests
          .where((test) =>
              test.mainTestName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
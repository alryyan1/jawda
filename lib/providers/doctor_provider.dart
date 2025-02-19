import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/doctor.dart';

class DoctorProvider with ChangeNotifier {
  List<Doctor> _allDoctors = []; // Store all doctors fetched from API
  List<Doctor> _doctors = [];     // Store the doctors to display (filtered)
  bool _isLoading = false;
  String _searchKeyword = '';

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;

  Future<void> fetchDoctors() async {
    _isLoading = true;
      notifyListeners();

    final url = Uri.parse('http://192.168.100.70/laravel-react-app/public/api/doctors');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        _allDoctors = decodedData.map((item) => Doctor.fromJson(item)).toList();
        _filterDoctors(); // Initial filtering based on keyword
      } else {
        // Handle error (e.g., show a snackbar)
        print('Failed to load doctors: ${response.statusCode}');
        throw Exception('Failed to load doctors'); // Re-throw to be caught in the UI.
      }
    } catch (error) {
      // Handle network errors, etc.
      print('Error fetching doctors: $error');
      rethrow; // Re-throw to be caught in the UI.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchDoctors(String keyword) async {
    _searchKeyword = keyword;
    print(_searchKeyword);
    _filterDoctors(); // Filter based on the new keyword
  }

  void _filterDoctors() {
    if (_searchKeyword.isEmpty) {
      _doctors = List.from(_allDoctors); // Show all doctors if no keyword
    } else {
      _doctors = _allDoctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(_searchKeyword.toLowerCase()))
          .toList();
          print(_doctors);
    }
    notifyListeners();
  }

  Future<void> addDoctor(Doctor newDoctor) async {
    final url = Uri.parse('http://192.168.100.70/laravel-react-app/public/api/doctors');  // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newDoctor.toJson()),
      );

      if (response.statusCode == 201) { // Assuming 201 Created on success
        fetchDoctors(); // Refresh the list
        notifyListeners();
      } else {
        print('Failed to add doctor: ${response.statusCode}');
        throw Exception('Failed to add doctor');
      }
    } catch (error) {
      print('Error adding doctor: $error');
      rethrow;
    }
  }

  Future<void> updateDoctor(Doctor updatedDoctor) async {
    final url = Uri.parse('http://192.168.100.70/laravel-react-app/public/api/doctorsMobile/${updatedDoctor.id}'); // Replace with your API endpoint

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedDoctor.toJson()),
      );

      if (response.statusCode == 200) { // Assuming 200 OK on success
        // Update the doctor in the lists:
        final index = _allDoctors.indexWhere((doctor) => doctor.id == updatedDoctor.id);
        if (index != -1) {
          _allDoctors[index] = updatedDoctor;
        }
        _filterDoctors(); // Refresh the displayed list

        notifyListeners();
      } else {
        print('Failed to update doctor: ${response.statusCode}');
        throw Exception('Failed to update doctor');
      }
    } catch (error) {
      print('Error updating doctor: $error');
      rethrow;
    }
  }
  Future<void> deleteDoctor(int doctorId) async {
    final url = Uri.parse('http://192.168.100.70/laravel-react-app/public/api/doctors/$doctorId'); // Replace with your API endpoint

    try {
      final response = await http.delete(url);

      if (response.statusCode == 204) { // Assuming 204 No Content on success
        _allDoctors.removeWhere((doctor) => doctor.id == doctorId); // Remove from allDoctors as well
        _filterDoctors(); // Update displayed list after deletion
        notifyListeners();
      } else {
        print('Failed to delete doctor: ${response.statusCode}');
        throw Exception('Failed to delete doctor');
      }
    } catch (error) {
      print('Error deleting doctor: $error');
      rethrow;
    }
  }
}
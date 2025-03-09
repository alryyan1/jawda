import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/doctor_schedule.dart'; // Import intl

// Assuming you have these data classes (adjust as needed)

class BookingProvider with ChangeNotifier {
  List<DoctorSchedule> _schedules = [];

  List<DoctorSchedule> get schedules => _schedules;

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://your-laravel-api/api')); // Base URL
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  // Add Doctor related getter and setter from here

  Future<void> loadSchedules(int doctorId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Implement fetching existing schedules for the doctor from your API
      // and populate the `schedules` list.
      // Example:
      // schedules = await fetchDoctorSchedules(doctorId);
      // setState(() {});

      // For now, initialize with empty objects if there are no existing schedules:
      _schedules = [
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 1, timeSlot: TimeSlot.morning, startTime: '08:00', endTime: '12:00'),
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 2, timeSlot: TimeSlot.evening, startTime: '14:00', endTime: '18:00'),
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 3, timeSlot: TimeSlot.morning, startTime: '08:00', endTime: '12:00'),
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 4, timeSlot: TimeSlot.evening, startTime: '14:00', endTime: '18:00'),
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 5, timeSlot: TimeSlot.morning, startTime: '08:00', endTime: '12:00'),
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 6, timeSlot: TimeSlot.evening, startTime: '14:00', endTime: '18:00'),
        DoctorSchedule(
            id: 0, doctorId: doctorId, dayOfWeek: 7, timeSlot: TimeSlot.morning, startTime: '08:00', endTime: '12:00'),
      ];

    } catch (error) {
      _errorMessage = 'Failed to load schedule: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSchedule(int doctorId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dio.post('/doctors/$doctorId/schedules', data: schedules.map((s) => s.toJson()).toList());

      if (response.statusCode == 200) {
        // Handle success
      } else {
        _errorMessage = 'Failed to save schedule: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'Failed to save schedule: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSchedule(DoctorSchedule updatedSchedule) {
    //update schedule with some logic for example id
  }

  void setStartTime(int id, TimeOfDay startTime, BuildContext context) {
    _schedules = schedules.map((schedule) {
      if (schedule.id == id) {
        return schedule.copyWith(startTime: startTime.format(context).toString());
      }
      return schedule;
    }).toList();
    notifyListeners();
  }

  void setEndTime(int id, TimeOfDay endTime, BuildContext context) {
    _schedules = schedules.map((schedule) {
      if (schedule.id == id) {
        return schedule.copyWith(endTime: endTime.format(context).toString());
      }
      return schedule;
    }).toList();
    notifyListeners();
  }

  Future<List<String>> fetchAvailability(int doctorId, DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await _dio.get('/doctors/$doctorId/availability?date=$formattedDate');

    if (response.statusCode == 200) {
      List<dynamic> body = response.data;
      List<String> availability = body.cast<String>(); // Cast to List<String>
      return availability;
    } else {
      throw Exception('Failed to load availability');
    }
  }
  
}
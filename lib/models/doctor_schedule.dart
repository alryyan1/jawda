class DoctorSchedule {
  final int id;
  final int doctorId;
  final int dayOfWeek; // 1 (Monday) to 7 (Sunday), or 0 for no schedule
  final TimeSlot timeSlot;
  final String startTime; // Store only the time portion
  final String endTime;   // Store only the time portion

  DoctorSchedule({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.timeSlot,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'day_of_week': dayOfWeek,
      'time_slot': timeSlot.toString().split('.').last,
      'start_time': startTime,
      'end_time': endTime
    };
  }
  DoctorSchedule copyWith({
    int? dayOfWeek,
    TimeSlot? timeSlot,
    String? startTime,
    String? endTime,
  }) {
    return DoctorSchedule(
      id: id,
      doctorId: doctorId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      timeSlot: timeSlot ?? this.timeSlot,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
 

}

class Appointment {
  final int id;
  final int doctorId;
  final int patientId;
  final DateTime appointmentDateTime;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDateTime,
  });
}
enum TimeSlot { morning, evening }


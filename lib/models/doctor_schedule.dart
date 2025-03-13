class DoctorSchedule {
  final int id;
  final int doctorId;
  final int dayOfWeek; // 1 (Monday) to 7 (Sunday), or 0 for no schedule
  final TimeSlot timeSlot;

  DoctorSchedule({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.timeSlot,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'day_of_week': dayOfWeek,
      'time_slot': timeSlot.toString().split('.').last,
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
    );
  }
 factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      dayOfWeek: json['day_of_week'] as int,
      timeSlot: TimeSlot.values.firstWhere(
        (e) => e.toString().split('.').last == json['time_slot'],
        orElse: () => TimeSlot.morning, // Default value (change as needed)
      ),
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


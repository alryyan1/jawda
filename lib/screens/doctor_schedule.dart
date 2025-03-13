import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jawda/models/doctor.dart';
import 'package:jawda/models/doctor_schedule.dart';
import 'package:jawda/providers/doctor_provider.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:provider/provider.dart';

class DoctorScheduleManagerScreen extends StatefulWidget {
  const DoctorScheduleManagerScreen({Key? key}) : super(key: key);

  @override
  State<DoctorScheduleManagerScreen> createState() =>
      _DoctorScheduleManagerScreenState();
}

class _DoctorScheduleManagerScreenState
    extends State<DoctorScheduleManagerScreen> {
  Doctor? _selectedDoctor;

  @override
  void initState() {
    super.initState();
    Provider.of<DoctorProvider>(context, listen: false).fetchDoctors();
  }

  Future<void> _updateSchedule(
      BuildContext context, bool val, int day, String timeSlot) async {
    // final provider = Provider.of<DoctorProvider>(context, listen: false);

    if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Select a doctor')));
      return;
    }
    try {
      final dio = DioClient.getDioInstance(context);
      final response =
          dio.patch('updateDoctorScheduleMobile/${_selectedDoctor!.id}', data: {
        'day_of_week': day,
        'doctor_id': _selectedDoctor?.id,
        'time_slot': timeSlot,
        'val': val.toString()
      });
    } catch (e) {}
  }

  bool _evening = false;
  bool _morning = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DoctorProvider>(context);
    final List<String> daysOfWeek = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Doctor Schedule'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownSearch<Doctor>(
              compareFn: (item1, item2) => item1.id == item2.id,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              itemAsString: (Doctor u) => u.name,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Select Doctor",
                  hintText: "Select Doctor in menu",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              selectedItem: null,
              onChanged: (value) {
                setState(() {
                  _selectedDoctor = value;
                });
              },
              items: (filter, loadProps) {
                // return supplierProvider.fetchSuppliers(context,filter);
                return provider.fetchDoctors();
              }, // Replace with your actual suppliers list
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: _selectedDoctor == null  ?  Text('Select Doctor') :ListView.builder(
                  itemCount: daysOfWeek.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardSchedule(
                      isMorning: _selectedDoctor!.schedules.any( (e)=>e.dayOfWeek == index)  &&   
                      _selectedDoctor!.schedules.firstWhere((element) => element.dayOfWeek == index ).timeSlot.name == "morning",
                      isEvening: false,
                      doctor: _selectedDoctor,
                      dayName: daysOfWeek[index],
                        day: index + 1, onChecked: _updateSchedule);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CardSchedule extends StatefulWidget {
  final int day;
  final String dayName;
  final Doctor? doctor;
  final bool isMorning;
  final bool isEvening;
  final void Function(BuildContext context, bool val, int day, String timeSlot)
      onChecked;
  CardSchedule({super.key, required this.day, required this.onChecked,required this.dayName,required this.doctor,required this.isEvening,required this.isMorning});

  @override
  State<CardSchedule> createState() => _CardScheduleState();
}

class _CardScheduleState extends State<CardSchedule> {
   bool isMorning = false;
   bool isEvening = false;
   @override
  void initState() {
    super.initState();
    isMorning = widget.isMorning;
    isEvening = widget.isEvening;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Morning'),
                Checkbox(
                  // value: schedule.timeSlot == TimeSlot.morning,
                  value: isMorning,
                  onChanged: (bool? value) {
                    // update to enable and disable the boolean values for doctor to work or not
                    widget.onChecked(context, value!, widget.day, 'Morning');
                    setState(() {
                      isMorning = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Evening'),
                Checkbox(
                  // value: schedule.timeSlot == TimeSlot.evening,
                  value: isEvening,
                  onChanged: (bool? value) {
                    // update to enable and disable the boolean values for doctor to work or not
                    widget.onChecked(context, value!, widget.day, 'evening');
                    setState(() {
                      isEvening = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

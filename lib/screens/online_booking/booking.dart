import 'package:flutter/material.dart';
import 'package:jawda/models/doctor.dart';
import 'package:jawda/providers/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//Your code

class ManageDoctorScheduleScreen extends StatefulWidget {
  final Doctor doctor;

  ManageDoctorScheduleScreen({required this.doctor});

  @override
  _ManageDoctorScheduleScreenState createState() => _ManageDoctorScheduleScreenState();
}

class _ManageDoctorScheduleScreenState extends State<ManageDoctorScheduleScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookingProvider>(context, listen: false).loadSchedules(widget.doctor.id);
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${widget.doctor.name}\'s Schedule'),
      ),
      body: bookingProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingProvider.errorMessage.isNotEmpty
              ? Center(child: Text(bookingProvider.errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Doctor: ${widget.doctor.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('Select Working Days:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        children: [
                          for (int i = 0; i < 7; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: Text(DateFormat('EEEE').format(DateTime(0, 1, i + 3))),
                                selected: bookingProvider.schedules[i].dayOfWeek == i + 1,
                                onSelected: (bool selected) {
                                  //update doctor time with provider
                                  bookingProvider.updateSchedule(bookingProvider.schedules[i].copyWith(dayOfWeek: selected ? i + 1 : 0));
                                },
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Select Begin and End time:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay initialTime = TimeOfDay.now();
                                  final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initialTime);
                                  if (pickedTime != null) {
                                    //update doctor time with provider
                                    bookingProvider.setStartTime(1, pickedTime, context);
                                  }
                                },
                                child: Text('Select Begin Time'),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay initialTime = TimeOfDay.now();
                                  final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initialTime);
                                  if (pickedTime != null) {
                                    //update doctor time with provider
                                    bookingProvider.setEndTime(1, pickedTime, context);
                                  }
                                },
                                child: Text('Select End Time'),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            bookingProvider.saveSchedule(widget.doctor.id);
                          },
                          child: Text('Save Schedule'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
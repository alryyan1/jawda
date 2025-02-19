import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../models/doctor.dart';
import 'add_doctor_screen.dart';  // Create this file (see below)

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoctorProvider>(context, listen: false).fetchDoctors();
    });
    // Provider.of<DoctorProvider>(context, listen: false).fetchDoctors();
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
        title: const Text('Doctors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDoctorScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Doctors',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Provider.of<DoctorProvider>(context, listen: true ).searchDoctors(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                Provider.of<DoctorProvider>(context, listen: false).searchDoctors(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<DoctorProvider>(
              builder: (context, doctorProvider, child) {
                if (doctorProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (doctorProvider.doctors.isEmpty) {
                  return const Center(child: Text('No doctors found.'));
                } else {
                  return ListView.builder(
                    itemCount: doctorProvider.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctorProvider.doctors[index];
                      return DoctorListItem(doctor: doctor);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class DoctorListItem extends StatelessWidget {
  final Doctor doctor;

  const DoctorListItem({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Phone: ${doctor.phone}'),
                  Text('Cash Percentage: ${doctor.cashPercentage}%'),
                  // Add more doctor details here
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditDialog(context, doctor);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Doctor doctor) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: doctor.name);
    final phoneController = TextEditingController(text: doctor.phone);
    final cashPercentageController = TextEditingController(text: doctor.cashPercentage.toString());
    final companyPercentageController = TextEditingController(text: doctor.companyPercentage.toString());
    final staticWageController = TextEditingController(text: doctor.staticWage.toString());
    final labPercentageController = TextEditingController(text: doctor.labPercentage.toString());
    final specialistIdController = TextEditingController(text: doctor.specialistId.toString());
    final startController = TextEditingController(text: doctor.start.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Doctor"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the doctor\'s name.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the doctor\'s phone number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: cashPercentageController,
                    decoration: const InputDecoration(labelText: 'Cash Percentage'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the cash percentage.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: companyPercentageController,
                    decoration: const InputDecoration(labelText: 'Company Percentage'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the company percentage.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: staticWageController,
                    decoration: const InputDecoration(labelText: 'Static Wage'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the static wage.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: labPercentageController,
                    decoration: const InputDecoration(labelText: 'Lab Percentage'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the lab percentage.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: specialistIdController,
                    decoration: const InputDecoration(labelText: 'Specialist ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the specialist ID.';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid integer.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: startController,
                    decoration: const InputDecoration(labelText: 'Start'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the start value.';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid integer.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedDoctor = Doctor(
                    id: doctor.id,
                    name: nameController.text,
                    phone: phoneController.text,
                    cashPercentage: double.parse(cashPercentageController.text),
                    companyPercentage: double.parse(companyPercentageController.text),
                    staticWage: double.parse(staticWageController.text),
                    labPercentage: double.parse(labPercentageController.text),
                    specialistId: int.parse(specialistIdController.text),
                    start: int.parse(startController.text),
                    createdAt: doctor.createdAt,
                    updatedAt: doctor.updatedAt,
                  );

                  Provider.of<DoctorProvider>(context, listen: false).updateDoctor(updatedDoctor);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
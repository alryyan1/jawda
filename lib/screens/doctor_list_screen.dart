import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../models/doctor.dart';
import 'add_doctor_screen.dart';  // Create this file (see below)

class DoctorListScreen extends StatefulWidget {
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
        title: Text('Doctors'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
                  icon: Icon(Icons.search),
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
                  return Center(child: CircularProgressIndicator());
                } else if (doctorProvider.doctors.isEmpty) {
                  return Center(child: Text('No doctors found.'));
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

  const DoctorListItem({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Phone: ${doctor.phone}'),
                  Text('Cash Percentage: ${doctor.cashPercentage}%'),
                  // Add more doctor details here
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
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
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: doctor.name);
    final _phoneController = TextEditingController(text: doctor.phone);
    final _cashPercentageController = TextEditingController(text: doctor.cashPercentage.toString());
    final _companyPercentageController = TextEditingController(text: doctor.companyPercentage.toString());
    final _staticWageController = TextEditingController(text: doctor.staticWage.toString());
    final _labPercentageController = TextEditingController(text: doctor.labPercentage.toString());
    final _specialistIdController = TextEditingController(text: doctor.specialistId.toString());
    final _startController = TextEditingController(text: doctor.start.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Doctor"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the doctor\'s name.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the doctor\'s phone number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cashPercentageController,
                    decoration: InputDecoration(labelText: 'Cash Percentage'),
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
                    controller: _companyPercentageController,
                    decoration: InputDecoration(labelText: 'Company Percentage'),
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
                    controller: _staticWageController,
                    decoration: InputDecoration(labelText: 'Static Wage'),
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
                    controller: _labPercentageController,
                    decoration: InputDecoration(labelText: 'Lab Percentage'),
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
                    controller: _specialistIdController,
                    decoration: InputDecoration(labelText: 'Specialist ID'),
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
                    controller: _startController,
                    decoration: InputDecoration(labelText: 'Start'),
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
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedDoctor = Doctor(
                    id: doctor.id,
                    name: _nameController.text,
                    phone: _phoneController.text,
                    cashPercentage: double.parse(_cashPercentageController.text),
                    companyPercentage: double.parse(_companyPercentageController.text),
                    staticWage: double.parse(_staticWageController.text),
                    labPercentage: double.parse(_labPercentageController.text),
                    specialistId: int.parse(_specialistIdController.text),
                    start: int.parse(_startController.text),
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
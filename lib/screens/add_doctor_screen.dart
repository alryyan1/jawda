import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../models/doctor.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cashPercentageController = TextEditingController();
  final _companyPercentageController = TextEditingController();
  final _staticWageController = TextEditingController();
  final _labPercentageController = TextEditingController();
  final _specialistIdController = TextEditingController();
  final _startController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cashPercentageController.dispose();
    _companyPercentageController.dispose();
    _staticWageController.dispose();
    _labPercentageController.dispose();
    _specialistIdController.dispose();
    _startController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor\'s name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor\'s phone number.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cashPercentageController,
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
                controller: _companyPercentageController,
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
                controller: _staticWageController,
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
                controller: _labPercentageController,
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
                controller: _specialistIdController,
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
                controller: _startController,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newDoctor = Doctor(
                      id: 0, // The backend should generate the ID
                      name: _nameController.text,
                      phone: _phoneController.text,
                      cashPercentage: double.parse(_cashPercentageController.text),
                      companyPercentage: double.parse(_companyPercentageController.text),
                      staticWage: double.parse(_staticWageController.text),
                      labPercentage: double.parse(_labPercentageController.text),
                      specialistId: int.parse(_specialistIdController.text),
                      start: int.parse(_startController.text),
                      schedules: []
                    );

                    Provider.of<DoctorProvider>(context, listen: false).addDoctor(newDoctor);
                    Navigator.pop(context); // Go back to the list screen
                  }
                },
                child: const Text('Add Doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
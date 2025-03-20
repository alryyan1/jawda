import 'package:flutter/material.dart';
import 'package:jawda/models/patient_models.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import dropdown_search
import '../providers/doctor_provider.dart';
import '../models/doctor.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

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
  final _startController = TextEditingController();
  Specialist? _selectedSpecialist; // Store selected specialist

  @override
  void initState() {
    super.initState();
    Provider.of<DoctorProvider>(context, listen: false).fetchSpecialists(context,'');
    _cashPercentageController.text = "75";
    _companyPercentageController.text = "50";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cashPercentageController.dispose();
    _companyPercentageController.dispose();
    _staticWageController.dispose();
    _labPercentageController.dispose();
    _startController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(  // Wrap with Directionality for RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة طبيب جديد'),
        ),
        body: Consumer<DoctorProvider>(
          builder: (context, doctorProvider, child) {
            if (doctorProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (doctorProvider.errorMessage != null) {
              return Center(child: Text('خطأ: ${doctorProvider.errorMessage}'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم الطبيب.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم هاتف الطبيب.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: _cashPercentageController,
                      decoration: const InputDecoration(labelText: 'نسبة الكاش'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال نسبة الكاش.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'الرجاء إدخال رقم صحيح.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _companyPercentageController,
                      decoration: const InputDecoration(labelText: 'نسبة الشركة'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال نسبة الشركة.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'الرجاء إدخال رقم صحيح.';
                        }
                        return null;
                      },
                    ),
             
                  

                    DropdownSearch<Specialist>(
                      compareFn: (item1, item2) => item1.id == item2.id,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                      ),
                      itemAsString: (Specialist u) => u.name,
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "اختر التخصص",
                          hintText: "اختر التخصص من القائمة",
                        ),
                      ),
                      selectedItem: _selectedSpecialist,
                      items: (filter, loadProps) {
                         return doctorProvider.fetchSpecialists(context, filter);
                      },
                      onChanged: (Specialist? data) {
                        setState(() {
                          _selectedSpecialist = data;
                        });
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
                            staticWage: 0.0,
                            labPercentage: 0.0,
                            specialistId: _selectedSpecialist!.id,
                            start: 1,
                              schedules: [], // or Get it from View or API
                          );

                          Provider.of<DoctorProvider>(context, listen: false).addDoctor(newDoctor);
                          Navigator.pop(context); // Go back to the list screen
                        }
                      },
                      child: const Text('إضافة طبيب'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
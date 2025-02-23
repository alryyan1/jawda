import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io' as io; // Import dart:io
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/screens/laundry_screen.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import '../models/finance_account.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:pdfrx/pdfrx.dart'; // Import pdfrx
void main() {
  runApp(const LaundryApp());
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LaundryScreen(),
    );
  }
}

class LaundryScreen extends StatefulWidget {
  const LaundryScreen({super.key});

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  DateTime? _selectedDate;
  String? _selectedBranch;
  bool _isButtonEnabled = false;
  String? _selectedBranchImage; //store image
    bool _isLoading = false;
  Uint8List? _pdfData; // Store PDF data
  bool _isPdfLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await  showDatePicker(
                    initialDate: _selectedDate,
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 60)),
                    lastDate: DateTime(2040));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  String cleanBase64(String base64String) {
    // Remove everything before the actual base64 data
    RegExp exp = RegExp(r'base64,(.*)');
    Match? match = exp.firstMatch(base64String);

    if (match != null) {
      return match.group(1)!.trim();
    }

    return base64String
        .replaceAll(RegExp(r'\s+'), '') // Remove whitespaces & newlines
        .trim();
  }
Future<Uint8List?> _generateAndShowPdf(String reportName,DateTime? selectedDate) async {
    setState(() {
      _isPdfLoading = true;
      _pdfData = null; // Reset previous PDF data
    });
final pathVariable =  _selectedBranch =='Branch One' ?  'kitchen-laravel/public/api' : 'two/new-branch/public/api';
    final url = Uri(
        scheme: schema,
        host: host,
        path: pathVariable + '/${reportName}',
        queryParameters: {'date':DateFormat('yyyy-MM-dd').format(selectedDate!)});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = json.decode(response.body);
        final String base64Pdf = response.body;
        var cleaned = cleanBase64(base64Pdf);
        // print(base64Pdf);

        setState(() {
          _pdfData = base64Decode(cleaned);
        });
      } else {
        print('Failed to generate PDF: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF')),
        );
      }
    } catch (error) {
      print('Error generating PDF: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while generating PDF')),
      );
    } finally {
      setState(() {
        _isPdfLoading = false;
      });
    }
    return _pdfData;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              
              'assets/laundry-1.jpg',
             
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'RAIN CLOUD',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(_selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                  ),
                  const SizedBox(height: 20),

                  // Branch Selection using Icon Buttons with Images
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBranchButton(
                        imagePath: 'assets/branch1.png', // Replace with your image
                        branchName: 'Branch One',
                        isSelected: _selectedBranch == 'Branch One',
                      ),
                      _buildBranchButton(
                        imagePath: 'assets/branch2.png', // Replace with your image
                        branchName: 'Branch Two',
                        isSelected: _selectedBranch == 'Branch Two',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), 
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () async {
                          if(_selectedDate != null) {

                              final pdfData =   await _generateAndShowPdf(
                                    'newAndDeliveredReport',_selectedDate); // Pass accountId
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return MyPdfViewer(pdfData: pdfData);
                                },));
                          }
                            print('Date: $_selectedDate, Branch: $_selectedBranch');
                            
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled ? Colors.white : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child:_isPdfLoading ? CircularProgressIndicator() : const Text('Generate'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build each branch button
  Widget _buildBranchButton({
    required String imagePath,
    required String branchName,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBranch = branchName;
          _selectedBranchImage = imagePath; // store image
          _isButtonEnabled = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.lightBlueAccent : Colors.transparent, // Light blue border when selected
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 80, // Adjust size as needed
                height: 80,
                fit: BoxFit.contain,
              ),
              Text(
                branchName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
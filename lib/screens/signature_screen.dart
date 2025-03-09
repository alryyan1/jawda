import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:universal_html/html.dart' as html;

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  Color _selectedColor = Colors.black; // Initial ink color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Pad'),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: _selectedColor,
                        onColorChanged: (Color color) {
                          setState(() => _selectedColor = color);
                        },
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Got it'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: SfSignaturePad(
            key: _signaturePadKey,
            backgroundColor: Colors.grey[100]!,
            strokeColor: _selectedColor,
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: Text('Clear Signature'),
            onPressed: () {
              _signaturePadKey.currentState?.clear();
            },
          ),
          ElevatedButton(
            child: Text('Save Signature'),
            onPressed: () async {
              final image = await _signaturePadKey.currentState?.toImage();

              if (image != null) {
                final data = await image.toByteData(format: ImageByteFormat.png);
                if (data != null) {
                  final bytes = data.buffer.asUint8List();
                  Navigator.pop(context, bytes); // Return the image data
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
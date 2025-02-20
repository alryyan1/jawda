
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class MyPdfViewer extends StatelessWidget {
  Uint8List? pdfData;
  final String id;
   MyPdfViewer({super.key, required this.pdfData,required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: PdfViewer.data(
        
        sourceName: id,
        pdfData!,
      ),
    ));
  }
}

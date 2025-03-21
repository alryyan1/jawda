import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Import flutter foundation for kIsWeb
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus
import 'package:path_provider/path_provider.dart'; // Import path_provider

class MyPdfViewer extends StatefulWidget {
  Uint8List? pdfData;
  final String id;

  MyPdfViewer({Key? key, required this.pdfData, required this.id}) : super(key: key);

  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _preparePdfForSharing();
  }

  Future<void> _preparePdfForSharing() async {
    if (widget.pdfData != null) {
      if (kIsWeb) {
        // Web: No need to save the file locally.
        _localPath = null; // No local path for web
      } else {
        // Mobile: Save the file to local storage.
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/finance_account_${widget.id}.pdf');
        await file.writeAsBytes(widget.pdfData!);
        setState(() {
          _localPath = file.path;
        });
      }
    }
  }

  Future<void> _sharePdf() async {
    if (widget.pdfData == null) {
      // Handle the case where PDF data is not available.
      return;
    }

  else if (_localPath != null) {
      // Mobile: Share the local file
      await Share.shareXFiles([XFile(_localPath!)], text: 'Sharing Finance Account PDF');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Wrap with Scaffold to add AppBar
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _sharePdf,
          ),
        ],
      ),
      body: Container(
        child: (widget.pdfData != null)
            ? PdfViewer.data(
                sourceName: widget.id,
                widget.pdfData!,
              )
            : Center(child: Text('No PDF data available')),
      ),
    );
  }
}
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:numsai/utils/widget_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  final Uint8List file;
  final String fileName;

  const PDFViewer({super.key, required this.file, required this.fileName});

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  Uint8List? file;
  String fileName = '';

  @override
  void initState() {
    file = widget.file;
    fileName = widget.fileName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UtilsWidgets.buildAppBar(context, fileName),
        body: Center(
          child: SfPdfViewer.memory(file!),
        ));
  }
}

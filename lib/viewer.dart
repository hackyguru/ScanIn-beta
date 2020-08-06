import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new FullScreenPdf());
}

class FullScreenPdf extends StatefulWidget {
  final String pdfPath;

  const FullScreenPdf({Key key, this.pdfPath}) : super(key: key);

  @override
  _FullScreenPdfState createState() => _FullScreenPdfState();
}

class _FullScreenPdfState extends State<FullScreenPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.share),
            ),
            onTap: () async {
              await ShareExtend.share(widget.pdfPath, "file");
            },
          )
        ],
        title: Text("Pdf View"),
      ),
      body: PdfDocumentLoader(
        filePath: widget.pdfPath,
        pageNumber: 1,
      ),
    );
  }
}

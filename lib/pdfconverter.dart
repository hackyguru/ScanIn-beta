import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:images_to_pdf/images_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'home.dart';
import 'taskmodel.dart';
import 'loading.dart';
import 'package:flutter/services.dart';
import 'imagefull.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new PdfConvertScreen(temp));
}

class PdfConvertScreen extends StatefulWidget {
  final File file;

  const PdfConvertScreen(this.file) : super();

  @override
  _PdfConvertScreenState createState() => _PdfConvertScreenState();
}

class _PdfConvertScreenState extends State<PdfConvertScreen> {
  String _status = "Not created";

  FileStat _pdfStat;
  File _pdf;

  bool _generating = false;

  Future<void> _createPdf() async {
    try {
      this.setState(() => _generating = true);

      final tempDir = await getApplicationSupportDirectory();
      await new Directory('${tempDir.path}/smartscan').create(recursive: true);
      _pdf = File(path.join('${tempDir.path}/smartscan/${DateTime.now()}.pdf'));

      print(_pdf.path);

      this.setState(() => _status = 'Preparing images...');
      final images = [widget.file];

      this.setState(() => _status = 'Generating PDF');
      await ImagesToPdf.createPdf(
        pages: images
            .map(
              (file) => PdfPage(
                imageFile: file,
                compressionQuality: 0.5,
              ),
            )
            .toList(),
        output: _pdf,
      );

//      this.setState(() {
//        wh.pdfFile = output;
//        _status = 'PDF Generated (${_pdfStat.size ~/ 1024}kb)';
//      });
      currentTask = TaskModel(name: name);
      todoHelper.insertTask(currentTask);
      _pdfStat = await _pdf.stat();
      if (_pdf != null) {
        await writePdfToDevice(_pdf);
      }
    } catch (e) {
      print(e.toString());
      this.setState(() => _status = 'Failed to generate pdf: $e".');
    } finally {
      this.setState(() => _generating = false);
    }
  }

  Future<void> _openPdf() async {
    if (_pdf != null) {
      try {
        final bytes = await _pdf.readAsBytes();
        await Printing.sharePdf(
            bytes: bytes, filename: path.basename(_pdf.path));
      } catch (e) {
        _status = 'Failed to open pdf: $e".';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _createPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            widget.file == null
                ? Container()
                : Center(
                    child: Image.file(
                    widget.file,
                    fit: BoxFit.cover,
                  )),
            if (_pdf != null)
              Positioned(
                top: 550,
                left: 20,
                child: GestureDetector(
                  onTap: _openPdf,
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text("Share PDF"),
                    ),
                  ),
                ),
              )
            else
              Positioned(
                top: 550,
                left: 20,
                child: InkWell(
                  onTap: _createPdf,
                  child: Container(
                    height: 50,
                    width: 100,
                    child: Center(
                      child: Text("Generate PDF"),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ),
            Positioned(
              top: 550,
              right: 20,
              child: FloatingActionButton(
                heroTag: "fdsfdsa",
                splashColor: Colors.orange,
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loader()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ));
  }

  writePdfToDevice(File output) async {
    final directory = await getDownloadsDirectory();
    final file = File("${directory.path}/${DateTime.now()}.pdf");
    await file.writeAsBytes(await output.readAsBytes());

    showDialog(context: context, child: Text("file written"));
  }
}

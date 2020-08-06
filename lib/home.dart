import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'taskmodel.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'imagefull.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/services.dart';
import 'viewer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(DocIt());
  });
}

class DocIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File image;

  future() async {
    List<TaskModel> list = await todoHelper.getAllTask();
    setState(() {
      tasks = list;
    });
  }

  Future getImagefromgallery() async {
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Full(
                    file: image,
                  )));
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DocIt()),
          (Route<dynamic> route) => false);
    }
  }

  Future getImagefromcamera() async {
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      image = File(await EdgeDetection.detectEdge);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Full(
                    file: image,
                  )));

      if (!mounted) return;
    } catch (e) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DocIt()),
        (Route<dynamic> route) => false,
      );
      print("error");
      Text(
        "you have not given permision",
        style: TextStyle(fontSize: 30),
      );
    }
  }

  void requestScanHistory() async {
    final tempDir = await getApplicationSupportDirectory();
    var dir = Directory(tempDir.path + "/smartscan");
    print(tempDir.path);
    print(dir.path);

    setState(() {
      history = dir.listSync(recursive: false);
    });

    print(history.length);
    print(tasks.length);
  }

  @override
  void initState() {
    try {
      requestScanHistory();
    } catch (e) {
      print((e));
    }

    super.initState();

    future();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
              color: Color(4280563301),
            ),
            child: Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 60),
                    child: Text("Hello ",
                        style: GoogleFonts.lobster(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text("There !",
                        style: GoogleFonts.lobster(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ]),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 240),
            child: Image.asset(
              "assets/scan.png",
              width: 350,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 180, top: 220),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await getImagefromgallery();
                    image != null
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Full(
                                      file: image,
                                    )),
                            (Route<dynamic> route) => false,
                          )
                        : Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DocIt()));
                  },
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                GestureDetector(
                    onTap: () async {
                      await getImagefromcamera();
                      image != null
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Full(
                                        file: image,
                                      )),
                              (Route<dynamic> route) => false,
                            )
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DocIt()));
                    },
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Icon(Icons.camera),
                      ),
                    ))
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 290, left: 15),
              child: Text(
                "Your Files",
                style: GoogleFonts.fredokaOne(
                    color: Color(4284835173), fontSize: 35),
              )),
          Container(
            padding: EdgeInsets.only(top: 330),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var item = history[index];

                    return Align(
                        alignment: Alignment.center,
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 350,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(4293651435),
                            ),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 150,
                                    height: 100,
                                    child: PdfDocumentLoader(
                                      filePath: item.path,
                                      pageNumber: 1,
                                      backgroundFill: true,
                                    ),
                                  ),
                                ),
                                Column(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 50, top: 30),
                                    child: Text("${tasks[index].name}"),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenPdf(
                                                    pdfPath: item.path,
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 60),
                                      child: Row(
                                        children: <Widget>[
                                          Text('View PDF'),
                                          Icon(Icons.arrow_forward)
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  )
                                ])
                              ],
                            ),
                          ),
                        ));
                  },
                  itemCount: history.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

var now = new DateTime.now();
var formatter = new DateFormat.yMMMd();
String name = formatter.format(now);

TodoHelper todoHelper = TodoHelper();

List<TaskModel> tasks = [];

TaskModel currentTask;
List<FileSystemEntity> history = List();

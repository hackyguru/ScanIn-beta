import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:example/pdfconverter.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'dart:io';
import 'package:flutter/services.dart';


void main(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new Full());
}

class Full extends StatefulWidget {
  final File file;
  const Full({Key key, this.file}) : super(key: key);

  @override
  _FullState createState() => _FullState();
}

class _FullState extends State<Full> {
 

  @override
  void initState() {
    temp = widget.file;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            temp == null
                ? Container()
                : Center(
                    child: Image.file(
                    temp,
                  )),
            Positioned(
              top: 550,
              left: 20,
              child: FloatingActionButton(
                heroTag: "fdssaww",
                onPressed: () {
                  croppedimage();
                },
                child: Icon(Icons.crop),
              ),
            ),
            Positioned(
              top: 550,
              right: 20,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (contetx) => PdfConvertScreen(temp)),(Route<dynamic> route) => false,);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    width: 100,
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Next",
                            style: TextStyle(fontSize: 20),
                          ),
                         
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }

  Future croppedimage() async {
    final cropped = await ImageCropper.cropImage(sourcePath: widget.file.path);

    temp = cropped;

    setState(() {
      temp = cropped ?? widget.file;
    });
  }
}
 File temp;
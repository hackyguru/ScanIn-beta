import 'dart:io';

import 'package:flutter/material.dart';
import 'package:example/Utilities/constants.dart';
import 'package:example/Utilities/cropper.dart';
import 'package:example/Utilities/file_operations.dart';
import 'package:example/Widgets/Image_Card.dart';
import 'package:example/screens/home_screen.dart';
import 'package:example/screens/pdf_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class ViewDocument extends StatefulWidget {
  static String route = "ViewDocument";

  ViewDocument({this.dirPath});

  final String dirPath;

  @override
  _ViewDocumentState createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> imageFilesWithDate = [];
  List<String> imageFilesPath = [];

  FileOperations fileOperations;

  String dirName;

  String fileName;

  bool _statusSuccess;

  void getImages() {
    imageFilesPath = [];
    imageFilesWithDate = [];

    Directory(dirName)
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      List<String> temp = entity.path.split(" ");
      imageFilesWithDate.add({
        "file": entity,
        "creationDate": DateTime.parse("${temp[3]} ${temp[4]}")
      });

      setState(() {
        imageFilesWithDate
            .sort((a, b) => a["creationDate"].compareTo(b["creationDate"]));
        for (var image in imageFilesWithDate) {
          if (!imageFilesPath.contains(image['file'].path))
            imageFilesPath.add(image["file"].path);
        }
      });
    });
  }

  void imageEditCallback() {
    getImages();
  }

  Future<void> displayDialog(BuildContext context) async {
    String displayText;
    (_statusSuccess)
        ? displayText = "Success. File stored in the OpenScan folder."
        : displayText = "Failed to generate pdf. Try Again.";
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(displayText)),
    );
  }

  @override
  void initState() {
    super.initState();
    fileOperations = FileOperations();
    dirName = widget.dirPath;
    getImages();
    fileName =
        dirName.substring(dirName.lastIndexOf("/") + 1, dirName.length - 1);
  }

  Future<dynamic> createImage() async {
    File image = await fileOperations.openCamera();
    if (image != null) {
      Cropper cropper = Cropper();
      var imageFile = await cropper.cropImage(image);
      if (imageFile != null) return imageFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: RichText(
            text: TextSpan(
              text: 'View ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: 'Document',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                _statusSuccess = await fileOperations.saveToAppDirectory(
                  context: context,
                  fileName: fileName,
                  images: imageFilesWithDate,
                );
                Directory storedDirectory =
                    await getApplicationDocumentsDirectory();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFScreen(
                      path: '${storedDirectory.path}/$fileName.pdf',
                    ),
                  ),
                );
              },
            ),
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                      context: context, builder: _buildBottomSheet);
                },
              );
            }),
          ],
        ),
        body: RefreshIndicator(
          backgroundColor: primaryColor,
          color: secondaryColor,
          onRefresh: () async {
            getImages();
          },
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: primaryColor),
            child: ListView.builder(
              itemCount: ((imageFilesWithDate.length) / 2).round(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ImageCard(
                        imageFile:
                            File(imageFilesWithDate[index * 2]["file"].path),
                        imageFileEditCallback: imageEditCallback,
                      ),
                      if (index * 2 + 1 < imageFilesWithDate.length)
                        ImageCard(
                          imageFile: File(
                              imageFilesWithDate[index * 2 + 1]["file"].path),
                          imageFileEditCallback: imageEditCallback,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    FileOperations fileOperations = FileOperations();
    Size size = MediaQuery.of(context).size;
    String folderName =
        dirName.substring(dirName.lastIndexOf('/') + 1, dirName.length - 1);
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: Text(
              folderName,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.blue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(
            thickness: 0.2,
            indent: 8,
            endIndent: 8,
            color: Colors.white,
          ),
          ListTile(
            leading: Icon(Icons.add_a_photo, color: Colors.orange),
            title: Text(
              'Add Image',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Navigator.pop(context);
              var image = await createImage();
              setState(() {});
              await fileOperations.saveImage(
                image: image,
                i: imageFilesWithDate.length + 1,
                dirName: dirName,
              );
              getImages();
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_android, color: Colors.orange),
            title: Text('Save PDF To Device',
                style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      title: Text('Save To Device'),
                      content: TextField(
                        onChanged: (value) {
                          fileName = '$value ScanIn';
                        },
                        controller: TextEditingController(
                            text: fileName.substring(8, fileName.length)),
                        cursorColor: secondaryColor,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          prefixStyle: TextStyle(color: Colors.white),
                          suffixText: ' ScanIn.pdf',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor)),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            String savedDirectory;
                            savedDirectory = await fileOperations.saveToDevice(
                              context: context,
                              fileName: fileName,
                              images: imageFilesWithDate,
                            );
                            String displayText;
                            (savedDirectory != null)
                                ? displayText = "Saved at $savedDirectory"
                                : displayText =
                                    "Failed To Save PDF. Try Again.";

                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                backgroundColor: primaryColor,
                                duration: Duration(seconds: 1),
                                content: Container(
                                  decoration: BoxDecoration(),
                                  alignment: Alignment.center,
                                  height: 20,
                                  width: size.width * 0.3,
                                  child: Text(
                                    displayText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                )));

                            Navigator.pop(context);
                          },
                          child: Text(
                            'Save',
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.orange),
            title: Text('Share as PDF', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      title: Text('Share as PDF'),
                      content: TextField(
                        onChanged: (value) {
                          fileName = '$value ScanIn';
                        },
                        controller: TextEditingController(
                            text: fileName.substring(8, fileName.length)),
                        cursorColor: secondaryColor,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          prefixStyle: TextStyle(color: Colors.white),
                          suffixText: ' ScanIn.pdf',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor)),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            _statusSuccess =
                                await fileOperations.saveToAppDirectory(
                              context: context,
                              fileName: fileName,
                              images: imageFilesWithDate,
                            );
                            Directory storedDirectory =
                                await getApplicationDocumentsDirectory();
                            ShareExtend.share(
                                '${storedDirectory.path}/$fileName.pdf',
                                'file');
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Share',
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.image,
              color: Colors.orange,
            ),
            title:
                Text('Share as image', style: TextStyle(color: Colors.white)),
            onTap: () {
              ShareExtend.shareMultiple(imageFilesPath, 'file');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            title: Text(
              'Delete All',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    title: Text(
                      'Delete',
                    ),
                    content: Text('Do you really want to delete file?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Directory(dirName).deleteSync(recursive: true);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => DocIt()),
                              (route) => false);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

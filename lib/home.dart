import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'imagefull.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:permission_handler/permission_handler.dart';
import 'view_doc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(DocIt());
  });
}

class DocIt extends StatelessWidget {
  static String route = "HomeScreen";

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
  List<Map<String, dynamic>> imageDirectories = [];
  var imageDirPaths = [];
  var imageDirModDate = [];
  var imageCount = 0;

  Future getDirectoryNames() async {
    Directory appDir = await getExternalStorageDirectory();
    Directory appDirPath = Directory("${appDir.path}");
    appDirPath
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      String path = entity.path;
      if (!imageDirPaths.contains(path) &&
          path !=
              '/storage/emulated/0/Android/data/com.example.openscan/files/Pictures') {
        imageDirPaths.add(path);
        Directory(path)
            .list(recursive: false, followLinks: false)
            .listen((FileSystemEntity entity) {
          imageCount++;
        });
        FileStat fileStat = FileStat.statSync(path);
        imageDirectories.add({
          'path': path,
          'modified': fileStat.modified,
          'size': fileStat.size,
          'count': imageCount
        });
      }
      imageDirectories.sort((a, b) => a['modified'].compareTo(b['modified']));
      imageDirectories = imageDirectories.reversed.toList();
    });
    return imageDirectories;
  }

  void askPermission() async {
    await _requestPermission();
  }

  @override
  void initState() {
    super.initState();
    getData();
    askPermission();
    _onRefresh();
  }

  Future _onRefresh() async {
    imageDirectories = await getDirectoryNames();
    setState(() {});
  }

  Future<bool> _requestPermission() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void getData() {
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String folderName;
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
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Full()));
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
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Full()));
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
              child: FutureBuilder(
                  future: getDirectoryNames(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Theme(
                      data: Theme.of(context)
                          .copyWith(accentColor: Color(0xFF333333)),
                      child: ListView.builder(
                        itemCount: imageDirectories.length,
                        itemBuilder: (context, index) {
                          folderName = imageDirectories[index]['path']
                              .substring(
                                  imageDirectories[index]['path']
                                          .lastIndexOf('/') +
                                      1,
                                  imageDirectories[index]['path'].length - 1);
                          return FocusedMenuHolder(
                            onPressed: null,
                            menuWidth: size.width * 0.44,
                            child: ListTile(
                              // TODO : Add sample image
                              leading: Icon(
                                Icons.landscape,
                                size: 30,
                              ),
                              title: Text(
                                folderName,
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.visible,
                              ),
                              subtitle: Text(
                                'Last Modified: ${imageDirectories[index]['modified'].day}-${imageDirectories[index]['modified'].month}-${imageDirectories[index]['modified'].year}',
                                style: TextStyle(fontSize: 11),
                              ),
                              trailing: Icon(
                                Icons.arrow_right,
                                size: 30,
                                color: Color(0xFF333333),
                              ),
                              onTap: () async {
                                getDirectoryNames();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewDocument(
                                      dirPath: imageDirectories[index]['path'],
                                    ),
                                  ),
                                ).whenComplete(() => () {
                                      print('Completed');
                                    });
                              },
                            ),
                            menuItems: [
                              FocusedMenuItem(
                                title: Text('Delete'),
                                trailingIcon: Icon(Icons.delete),
                                backgroundColor: Colors.redAccent,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        title: Text('Delete'),
                                        content: Text(
                                            'Do you really want to delete file?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancel'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Directory(imageDirectories[index]
                                                      ['path'])
                                                  .deleteSync(recursive: true);
                                              Navigator.pop(context);
                                              getData();
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home.dart';
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new Loader());
}

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Load(),
    );
  }
}

class Load extends StatefulWidget {
  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 4),
        () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DocIt()),  (Route<dynamic> route) => false,
                  
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ));
  }
}

import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new Screen());
}

class Screen extends StatelessWidget {
  static String route = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scr(),
    );
  }
}

class Scr extends StatefulWidget {
  @override
  _ScrState createState() => _ScrState();
}

class _ScrState extends State<Scr> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 6),
        () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DocIt()),
              (Route<dynamic> route) => false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4281545523),
      body: Column(children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Image.asset(
            "assets/logog.jpeg",
            height: 650,
            width: 700,
          ),
        ))
      ]),
    );
  }
}

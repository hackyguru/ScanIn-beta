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
        const Duration(seconds: 5),
        () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DocIt()),
              (Route<dynamic> route) => false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(000000),
      body: Column(children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 200),
            child: Image.asset(
              "assets/best.gif",
              width: 200,
            ),
          ),
        ),
        Expanded(
            child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: RichText(
              text: TextSpan(
            children: [
              TextSpan(text: "A Product of ", style: TextStyle(fontSize: 17)),
              TextSpan(
                  text: "Cybrin",
                  style: TextStyle(color: Colors.green[200], fontSize: 17))
            ],
          )),
        ))
      ]),
    );
  }
}

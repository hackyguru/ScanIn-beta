import 'package:example/Widgets/Image_Card.dart';
import 'package:flutter/material.dart';
import 'Utilities/constants.dart';
import 'dart:ui';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(About());

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AboutScreen());
  }
}

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  _launchURL() async {
    const url = 'https://www.linkedin.com/in/dhanush-vardhan-30bb881b0/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchjoin() async {
    const url = 'https://www.cybrin.com/join.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 500,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Container(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset("assets/topout.jpeg")),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: size.width * .9,
                padding: EdgeInsets.only(top: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    text: 'Scan-In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    children: <TextSpan>[
                      new TextSpan(
                          text:
                              " is a opensource document scanning app and is a alternative for Chinise document-scanning apps .We faciliate users by giving them all the features that famous Chinise apps give with atmost privacy without storing any backend data .This app enables users to scan hard copies od documents and convert them to PDF .We dont add any watermark or label in the pdf",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  child: Text(
                "Developer",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 20,
              ),
              Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 170,
                    height: 220,
                    color: primaryColor,
                    child: GestureDetector(
                      onTap: () async {
                        await _launchURL();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage('assets/dhan.jpeg'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Dhanush",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 50),
                              child: Row(
                                children: [
                                  Text(
                                    "More Info",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Icons.arrow_forward, color: Colors.white)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async => await launchjoin(),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 7, 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Image.asset(
                              'assets/com.png',
                              scale: 3.5,
                            ),
                          ),
                          Text(
                            "Join our start up",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

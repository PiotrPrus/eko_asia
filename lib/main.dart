import 'package:ekoasia/ChooseCityScreen.dart';
import 'package:ekoasia/Styles.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eko Asia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _WelcomePageWidget(),
    );
  }
}

class _WelcomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: backgroundGreen),
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 100, bottom: 40),
          child: Image(
            image: AssetImage('assets/images/asiaImage.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Eko Asia',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryGrey)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'Cześć, jestem tu, by pomóc ci w segregacji odpadów.',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textPrimaryGrey),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 100),
          child: RaisedButton(
            color: primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 12, right: 24, bottom: 12),
              child: Text(
                'START',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChooseCityScreen()),
              );
            },
          ),
        )
      ]),
    ));
  }
}

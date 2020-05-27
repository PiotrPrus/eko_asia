import 'package:ekoasia/ChooseCityScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eko Asia',
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
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Start'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChooseCityScreen()),
              );
            },
          ),
        ));
  }
}

import 'package:ekoasia/askAboutProductScreen.dart';
import 'package:ekoasia/recordSearchScreen.dart';
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
        home: LocationAppPage(title: 'Select your location'),
        routes: {
          RecordSearchScreen.routeName: (context) => RecordSearchScreen(),
          AskAboutProduct.routeName: (context) => AskAboutProduct(),
        });
  }
}

class LocationAppPage extends StatefulWidget {
  LocationAppPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LocationAppPageState createState() => _LocationAppPageState();
}

class _LocationAppPageState extends State<LocationAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RecordSearchScreen.routeName,
                        arguments: ChosenCity("gdansk"));
                  },
                  child: Text('Gdańsk', style: TextStyle(fontSize: 20)),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AskAboutProduct.routeName);
                  },
                  child: Text('Krakow', style: TextStyle(fontSize: 20)),
                )
              ]),
        ));
  }
}

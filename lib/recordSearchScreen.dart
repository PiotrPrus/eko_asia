import 'package:flutter/material.dart';

class ChosenCity {
  final String cityName;

  ChosenCity(this.cityName);
}

class RecordSearchScreen extends StatelessWidget {
  static const routeName = '/recordSearch';


  @override
  Widget build(BuildContext context) {

    final ChosenCity args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Record and Search"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: Text('You have selected ${args.cityName}'),
        ),
      ),
    );
  }
}
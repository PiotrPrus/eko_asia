import 'package:ekoasia/recordSearchScreen.dart';
import 'package:flutter/material.dart';

import 'ChosenCity.dart';

class ChooseCityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your location"),
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Wybierz w jakim mieście jesteś',
          style: TextStyle(
            fontSize: 50,
            color: Colors.grey
          ),
          textAlign: TextAlign.center),
          IconButton(
            iconSize: 225,
            icon: Image.asset('assets/images/gdansk_button.png'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RecordSearchScreen(city: ChosenCity('gdansk'),)));
              print("gdansk pressed");
            },
          ),
          IconButton(
            iconSize: 225,
            icon: Image.asset('assets/images/krakow_button.png'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RecordSearchScreen(city: ChosenCity('krakow'),)));
              print("krakow pressed");
            },
          )
        ],
      )),
    );
  }

}
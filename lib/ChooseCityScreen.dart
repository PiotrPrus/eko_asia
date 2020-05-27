import 'package:ekoasia/Styles.dart';
import 'package:ekoasia/recordSearchScreen.dart';
import 'package:flutter/material.dart';

import 'ChosenCity.dart';

class ChooseCityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundGrey,
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Wybierz w jakim mieście jesteś',
              style: TextStyle(
                fontSize: 22,
                color: textPrimaryGrey,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center),
            ),
            IconButton(
              iconSize: 250,
              icon: Image.asset('assets/images/gdansk_button.png'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RecordSearchScreen(city: ChosenCity('gdansk', 'gd'),)));
                print("gdansk pressed");
              },
            ),
            IconButton(
              iconSize: 250,
              icon: Image.asset('assets/images/krakow_button.png'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RecordSearchScreen(city: ChosenCity('krakow', 'kr'),)));
                print("krakow pressed");
              },
            )
          ],
        )),
      ),
    );
  }

}
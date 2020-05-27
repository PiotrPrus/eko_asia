import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'ChosenCity.dart';

class RecordSearchScreen extends StatelessWidget {
  static const routeName = '/recordSearch';

  @override
  Widget build(BuildContext context) {
    final ChosenCity args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Record and Search"),
      ),
      body: Center(child: PlayerWidget(city: args)),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  PlayerWidget({Key key, this.city}) : super(key: key);

  final ChosenCity city;

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final _player = AudioCache(prefix: 'sounds/');

  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchTextController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("Searched text: ${_searchTextController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('You have selected ${widget.city.cityName}'),
        RaisedButton(
          onPressed: () {
            _playLocal();
          },
          child: Text('Play test sound', style: TextStyle(fontSize: 20)),
        ),
        IconButton(
          padding: EdgeInsets.all(24.0),
          icon: Image.asset('assets/images/micIcon.png'),
          iconSize: 100,
          onPressed: () {},
        ),
        SizedBox(height: 100),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: TextField(controller: _searchTextController)),
            FlatButton(
              onPressed: () {
                //search
              },
              child: Text('Search', style: TextStyle(fontSize: 20)),
            ),
          ],
        )
      ],
    );
  }

  _playLocal() async {
    _player.play('audio.mp3');
  }
}

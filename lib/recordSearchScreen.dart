import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
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
        child: PlayerWidget(city: args)
      ),
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
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        // Navigate back to first screen when tapped.
      },
      child: Text('You have selected ${widget.city.cityName}'),
    );
  }

  }
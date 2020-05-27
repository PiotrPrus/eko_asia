import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

import 'ChosenCity.dart';
import 'recordSearchScreen.dart';

class AskAboutProduct extends StatelessWidget {
  static const routeName = '/askAsia';

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

class _PlayerWidgetState extends State<PlayerWidget> {
  final player = AudioCache(prefix: 'sounds/');

  _playLocal() async {
    player.play('audio.mp3');
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
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'ChosenCity.dart';

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
          child: ListenAndSearchWidget(city: args)
      ),
    );
  }
}

class ListenAndSearchWidget extends StatefulWidget {
  ListenAndSearchWidget({Key key, this.city}) : super(key: key);

  final ChosenCity city;

  @override
  _ListenAndSearchState createState() => _ListenAndSearchState();
  }


class _ListenAndSearchState extends State<ListenAndSearchWidget> {
  bool _hasSpeech = false;
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }
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
          onPressed: () {
            if (_hasSpeech) {
              print("microphone tapped");
            } else {
              initSpeechState();
            }
          },
        )
      ],
    );
  }
}
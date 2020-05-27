import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'ChosenCity.dart';
import 'DedicatedBin.dart';
import 'NetworkService.dart';

class RecordSearchScreen extends StatelessWidget {
  final ChosenCity city;
  RecordSearchScreen({Key key, @required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record and Search"),
      ),
      body: Center(child: PlayerWidget(city: city)),
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
  bool _hasSpeech = false;
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();
  final _player = AudioCache(prefix: 'sounds/');
  final _searchTextController = TextEditingController();

  final _bins = <Bin>[];

  final networkService = NetworkService();

  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _searchTextController,
                decoration: InputDecoration(
                  labelText: "Co wyrzucasz",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Wprowadź co wyrzucasz!';
                  }
                  return null;
                },
              ),
            ),
            FlatButton(
              onPressed: () async {
                var itemName = _searchTextController.text;
                _searchTextController.text = "";
                getDedicatedBins(itemName);
              },
              child: Text('Szukaj', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        IconButton(
          padding: EdgeInsets.all(24.0),
          icon: Image.asset('assets/images/micIcon.png'),
          iconSize: 100,
          onPressed: () {
            if (_hasSpeech) {
              _searchTextController.text = "";
              if (speech.isListening) {
                speech.stop();
              } else {
                startListening();
              }
            } else {
              initSpeechState();
            }
          },
        ),
        Expanded(child: _buildBinsInstruction())
      ],
    );
  }

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

  void startListening() {
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: "pl",
        cancelOnError: true,
        partialResults: false);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() async {
      String lastWords = "${result.recognizedWords}";
      // TODO: Send the words to firebase to get the result.
      print(lastWords.toLowerCase());
      _searchTextController.text = lastWords.toLowerCase();
      getDedicatedBins(lastWords);
    });
  }

  Future<void> getDedicatedBins(String itemName) async {
    var response =
        await networkService.fetchBinResponse(widget.city.cityCode, itemName);
    response.bins.forEach((e) => debugPrint("${e.namePl} ${e.products}"));

    setState(() {
      _bins.clear();
      _bins.addAll(
          response.bins.where((element) => element.products != null).toList());
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

  Widget _buildBinsInstruction() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _bins.length,
        itemBuilder: /*1*/ (context, i) {
          return _binRow(_bins[i]);
        });
  }

  Widget _binRow(Bin bin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: bin.products.map((e) => new Text(e, style: TextStyle(fontSize: 20))).toList(),
        ),
        Image(
            image: AssetImage(_imagePath(bin)),
            height: 200,
            width: 200,
            fit: BoxFit.fitWidth),
      ],
    );
  }

  String _imagePath(Bin bin) {
    switch (bin.name) {
      case "Other":
        // TODO: grafika
        return "assets/images/odpady-niebezpieczne.png";
      case "Paper":
        return "assets/images/kontener-na-papier.png";
      case "Glass":
        return "assets/images/kontener-na-szklo.png";
      case "Plastic & metal":
        return "assets/images/kontener-na-plastik.png";
      case "Organic":
        return "assets/images/kontener-bio.png";
      case "Oversized":
        // TODO: grafika
        return "assets/images/odpady-niebezpieczne.png";
      case "Drugs":
        // TODO: grafika
        return "assets/images/odpady-niebezpieczne.png";
      default:
        {
          return "assets/images/odpady-niebezpieczne.png";
        }
    }
  }

  _playLocal() async {
    _player.play('audio.mp3');
  }
}

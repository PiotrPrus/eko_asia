import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekoasia/BinResponse.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'ChosenCity.dart';
import 'NetworkService.dart';
import 'Product.dart';

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

  final _bins = <Product>[];

  final networkService = NetworkService();

  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(_printLatestValue);
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
              print("START!");
              _searchTextController.text = "";
              if(speech.isListening) {
                speech.stop();
              } else {
                startListening();
              }
            } else {
              print("INIT!");

              initSpeechState();
            }
          },
        ),
        SizedBox(height: 100),
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
              onPressed: () {
                print("STOP!");
                print(networkService.fetchBinResponse());
//                speech.stop();
              },
              child: Text('Search', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        Expanded(
            child:  _buildBinsInstruction()
        )

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
    setState(() {
      String lastWords = "${result.recognizedWords}";
      // TODO: Send the words to firebase to get the result.
      print(lastWords.toLowerCase());
      getData(lastWords.toLowerCase());
      _searchTextController.text = lastWords.toLowerCase();
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

  _printLatestValue() {
    print("Searched text: ${_searchTextController.text}");
  }

  Widget _buildBinsInstruction() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _bins.length,
        itemBuilder: /*1*/ (context, i) {
          return _binRow(_bins[i]);
        });
  }

  Widget _binRow(Product bin) {
    return ListTile(
      title: Text(bin.binType),
    );
  }

  void getData(String searchTerm) {
    databaseReference
        .collection("testProducts")
        .where('keywords', arrayContains: searchTerm)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
//        snapshot.documents.forEach((f) => print('${f.data}}'));
        var bins = snapshot.documents.map((snapshot) => Product.fromSnapshot(snapshot));
        print(bins.map((e) => e.name));

        setState(() {
          _bins.clear();
          _bins.addAll(bins);
        });
    });
  }

  _playLocal() async {
    _player.play('audio.mp3');
  }
}

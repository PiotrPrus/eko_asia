import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekoasia/BinResponse.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  bool _hasSpeech = false;
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();
  final _player = AudioCache(prefix: 'sounds/');
  final _searchTextController = TextEditingController();
  final _bins = <BinResponse>[];
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
              startListening();
            } else {
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
                getData();
//                if (_formKey.currentState.validate()) { }
              },
              child: Text('Search', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
//        _buildBinsInstruction()
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
        localeId: _currentLocaleId,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      String lastWords = "${result.recognizedWords} - ${result.finalResult}";
      // TODO: Send the words to firebase to get the result.
      print(lastWords);
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
        itemBuilder: /*1*/ (context, i) {
          return _binRow(_bins[i]);
        });
  }

  Widget _binRow(BinResponse bin) {
    return ListTile(
      title: Text(bin.binName()),
    );
  }

  void getData() {
//    final dbRef = FirebaseDatabase.instance.reference().child("test");
//
//    dbRef.once().then((DataSnapshot snapshot) {
//      print('Data : ${snapshot.value}');
//    });
    databaseReference
        .collection("bins")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  _playLocal() async {
    _player.play('audio.mp3');
  }
}

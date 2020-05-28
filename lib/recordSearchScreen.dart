import 'dart:async';
import 'dart:io';
import 'package:ekoasia/Styles.dart';
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
  AssetImage _micImage;

  bool noProductFound = false;

  final _bins = <Bin>[];

  final networkService = NetworkService();

  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _micImage = AssetImage('assets/images/mic_inactive.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 100, bottom: 20),
            child: Text(
              'Co chcesz wyrzucić?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(24.0),
            icon: Image(image: _micImage),
            iconSize: 120,
            onPressed: () {
              updateMicImage();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.search, size: 40),
                  onPressed: () async {
                    var itemName = _searchTextController.text;
                    _searchTextController.text = "";
                    getServerResponse(itemName);
                  },
                ),
              ),
            ],
          ),
          Expanded(
              child: noProductFound
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Niestety nie wiemy gdzie to wyrzucic :(",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : _buildBinsInstruction())
        ],
      ),
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

  void updateMicImage() {
    setState(() {
      if (_hasSpeech) {
        if (speech.isListening) {
          _micImage = AssetImage('assets/images/mic_listening.png');
        } else {
          _micImage = AssetImage('assets/images/mic_active.png');
        }
      } else {
        _micImage = AssetImage('assets/images/mic_inactive.png');
      }
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
      print(lastWords.toLowerCase());
      _searchTextController.text = lastWords.toLowerCase();
      getServerResponse(lastWords);
    });
  }

  Future<void> getServerResponse(String itemName) async {
    setState(() {
      noProductFound = false;
    });

    var trimmedText = itemName
        .toLowerCase()
        .replaceAll("hej", '')
        .replaceAll("ekoasia", '')
        .replaceAll("gdzie", '')
        .replaceAll("wyrzucę", '')
        .replaceAll("wyrzuce", '')
        .replaceAll("wyrzucic", '')
        .replaceAll("wyrzucić", '')
        .replaceAll("co", '')
        .replaceAll("zrobić", '')
        .trim();

    print(trimmedText);

    try {
      var response = await networkService.fetchBinResponse(
          widget.city.cityCode, trimmedText);
      if (response.questions != null) {
        var question = response.questions.first;
        _showMyDialog(question, trimmedText);
      } else {
        updateListWithBins(response);
      }
    } catch (e) {
      _bins.clear();
      setState(() {
        noProductFound = true;
      });
    }
  }

  void updateListWithBins(DedicatedBin response) {
    response.bins.forEach((e) => debugPrint("${e.namePl} ${e.products}"));

    var responseList =
        response.bins.where((element) => element.products != null).toList();

    //TODO: Fix for multiple answers
    if (responseList.length == 1) {
      _playSoundResponse(responseList.first);
    }

    setState(() {
      _bins.clear();
      _bins.addAll(responseList);
    });
  }

  Future<void> _showMyDialog(Question question, String itemName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(question.title),
          actions: question.answers
              .map((answer) => answerButton(answer, question.id, itemName))
              .toList(),
        );
      },
    );
  }

  FlatButton answerButton(Answers answer, String questionId, String itemName) {
    return FlatButton(
        child: Text(answer.title),
        onPressed: () async {
          Navigator.of(context).pop();
          var response =
              await networkService.sendAnswer(questionId, answer.id, itemName);
          updateListWithBins(response);
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
          children: bin.products
              .map((e) => Text(e, style: TextStyle(fontSize: 20)))
              .toList(),
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
        return "assets/images/odpady-zmieszane.png";
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

  _playSoundResponse(Bin bin) async {
    switch (bin.name) {
      case "Other":
        _player.play('ZMIESZANE.mp3');
        break;
      case "Paper":
        _player.play('PAPIER.mp3');
        break;
      case "Glass":
        _player.play('SZKLO.mp3');
        break;
      case "Plastic & metal":
        _player.play('METAL-PLASTIK.mp3');
        break;
      case "Organic":
        _player.play('BIO.mp3');
        break;
      default:
        _player.play('PSZOK.mp3');
        break;
    }
  }
}

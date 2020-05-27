import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekoasia/BinResponse.dart';
import 'package:firebase_database/firebase_database.dart';
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

  final _bins = <BinResponse>[];

  final databaseReference = Firestore.instance;

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
                child: TextFormField(controller: _searchTextController,
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

  Widget _buildBinsInstruction() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          return _binRow(_bins[i]);
        });
  }

  Widget _binRow(BinResponse bin) {
    return ListTile(
      title: Text(
        bin.binName()
      ),
    );
  }

  void getData(){

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

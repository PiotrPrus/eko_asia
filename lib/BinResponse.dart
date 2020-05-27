import 'package:cloud_firestore/cloud_firestore.dart';

import 'Product.dart';

class BinResponse {
  String documentID;
  String name;

  List<Product> products = new List<Product>();

  String binName() {
    return "Happy Bin";
  }

  BinResponse({this.name, this.products});

  BinResponse.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        name = snapshot['name'];
}



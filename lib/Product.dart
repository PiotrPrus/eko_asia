
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String documentID;

  String name;
  String binType;

  String binName() {
    return "Happy Bin";
  }

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        name = snapshot['name'],
        binType = snapshot['binType'];
}

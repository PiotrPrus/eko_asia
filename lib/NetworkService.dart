import 'dart:convert';
import 'dart:io';
import 'package:ekoasia/DedicatedBin.dart';
import 'package:http/http.dart' as http;

class NetworkService {

  final String endpoint = "us-central1-ekoasia-6514e.cloudfunctions.net";
  final String wastePath  = "/throwWaste";

  Future<DedicatedBin> fetchBinResponse() async {
    var queryParameters = {
      'location': 'gd',
      'name': 'maska',
    };

    print(endpoint);
    var uri =
    Uri.https(endpoint, wastePath, queryParameters);
    print(uri);

    var response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return DedicatedBin.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
}
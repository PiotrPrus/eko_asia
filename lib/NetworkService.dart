import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkService {

  final String endpoint = "us-central1-ekoasia-6514e.cloudfunctions.net";
  final String wastePath  = "/throwWaste";

  Future<void> fetchBinResponse() async {
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

    print(response.body);
  }
}
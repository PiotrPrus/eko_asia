import 'dart:convert';
import 'dart:io';
import 'package:ekoasia/DedicatedBin.dart';
import 'package:http/http.dart' as http;

class NetworkService {

  final String endpoint = "us-central1-ekoasia-6514e.cloudfunctions.net";
  final String wastePath  = "/throwWaste";
  final String answerQuestion = "/answerQuestion";

  Future<DedicatedBin> fetchBinResponse(String location, String itemName) async {
    var queryParameters = {
      'location': location,
      'name': itemName.toLowerCase(),
    };

    var uri = Uri.https(endpoint, wastePath, queryParameters);
    print(uri);

    var response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      JsonCodec codec = new JsonCodec();

      try{
        print(response.body);

        var decoded = codec.decode(response.body);
        return DedicatedBin.fromJson(decoded);
      } catch(e) {
        print("Fetch BinResponse Mapping Error: $e");
        throw Exception('Failed to load album');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<DedicatedBin> sendAnswer(String questionId, int answerId, String itemName) async {
    var queryParameters = {
      'questionid': questionId,
      'answerid': answerId.toString(),
      'name': itemName.toLowerCase()
    };

    var uri = Uri.https(endpoint, answerQuestion, queryParameters);

    print(uri);

    var response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      JsonCodec codec = new JsonCodec();

      try {
        print(response.body);

        var decoded = codec.decode(response.body);
        return DedicatedBin.fromJson(decoded);
      } catch (e) {
        print("Send Answer Mapping Error: $e");
        throw Exception('Failed to load album');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
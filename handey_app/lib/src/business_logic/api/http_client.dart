import 'dart:convert';
import 'package:http/http.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  final String baseUrl = 'http://localhost:8080';
  String accessToken = '';

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal();

  Future<Map<String, dynamic>> getRequest(String url,
      {bool tokenYn: false}) async {
    Response response;
    if (tokenYn) {
      var headers = {'ACCESS_TOKEN': accessToken};
      response = await get(Uri.parse(baseUrl + url), headers: headers);

    } else {
      response = await get(Uri.parse(baseUrl + url));

    }
    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${response.body}');

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body,
      {bool tokenYn: false}) async {
    Response response;
    var headers;
    if (tokenYn) {
      headers = {'Content-Type': 'application/json', 'ACCESS_TOKEN': accessToken};
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await post(Uri.parse(baseUrl + url),
        body: jsonEncode(body), headers: headers);
    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${response.body}');
    return jsonDecode(response.body);
  }
}
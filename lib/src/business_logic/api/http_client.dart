import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  final String baseUrl = 'http://10.0.2.2:8080';
  // final String baseUrl = 'http://192.168.61.1:8000';
  // final String baseUrl = 'http://localhost:8000';
  // final String baseUrl = 'http://91ed-1-235-76-56.ngrok.io';

  String accessToken = '';

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal();

  Future<Map<String, dynamic>> getRequest(String url,
      {bool tokenYn: false}) async {
    http.Response response;
    if (tokenYn) {
      var headers = {'ACCESS_TOKEN': accessToken};
      response = await http.get(Uri.parse(baseUrl + url), headers: headers);

    } else {
      response = await http.get(Uri.parse(baseUrl + url));

    }
    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${utf8.decode(response.bodyBytes)}');

    /// print(utf8.decode(response.bodyBytes));
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body,
      {bool tokenYn: false}) async {
    http.Response response;
    var headers;
    if (tokenYn) {
      headers = {'Content-Type': 'application/json', 'ACCESS_TOKEN': accessToken};
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.post(Uri.parse(baseUrl + url),
        body: jsonEncode(body), headers: headers);
    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> putRequest(
      String url, Map<String, dynamic> body, {bool tokenYn: false}) async {
    http.Response response;
    var headers;
    if (tokenYn) {
      headers = {'Content-Type': 'application/json', 'ACCESS_TOKEN': accessToken};
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.put(Uri.parse(baseUrl + url),
        body: jsonEncode(body), headers: headers);
    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteRequest(
      String url, {bool tokenYn: false}) async {
    http.Response response;
    var headers;
    if (tokenYn) {
      headers = {'Content-Type': 'application/json', 'ACCESS_TOKEN': accessToken};
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.delete(Uri.parse(baseUrl + url), headers: headers);

    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${response.body}');

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> patchRequest(
      String url, {bool tokenYn: false}) async {
    http.Response response;
    var headers;
    if (tokenYn) {
      headers = {'Content-Type': 'application/json', 'ACCESS_TOKEN': accessToken};
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.patch(Uri.parse(baseUrl + url), headers: headers);

    print('url : ${baseUrl + url}');
    print('statusCode : ${response.statusCode}');
    print('response body : ${response.body}');

    return jsonDecode(response.body);
  }

  // Future<bool> getBoolRequest(String url,
  //     {bool tokenYn: false}) async {
  //   http.Response response;
  //   if (tokenYn) {
  //     var headers = {'ACCESS_TOKEN': accessToken};
  //     response = await http.get(Uri.parse(baseUrl + url), headers: headers);
  //
  //   } else {
  //     response = await http.get(Uri.parse(baseUrl + url));
  //
  //   }
  //   print('url : ${baseUrl + url}');
  //   print('statusCode : ${response.statusCode}');
  //   print('response body : ${response.body}');
  //
  //   return jsonDecode(response.body);
  // }
}
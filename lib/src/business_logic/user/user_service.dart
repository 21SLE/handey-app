import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/user/user_model.dart';

class UserService {
  HttpClient _httpClient = HttpClient();

  /// 회원가입
  Future<Map<String, dynamic>> signUp(UserModel userModel) async {
    Map<String, dynamic> data =
      await _httpClient.postRequest('/register', userModel.toJson());

    print(data);
    // if (response.statusCode == 200) {
    //   print(reponse.body);
    // } else {
    //   print('A network error occurred');
    // }
    return data;
  }

  /// 로그인
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    Map<String, dynamic> data = await _httpClient
        .postRequest('/login', {'email': email, 'password': password});
    return data;
  }

  Future<UserModel> getUserInfo(int userId) async {
    Map<String, dynamic> data =
    await _httpClient.getRequest('/user/$userId/info', tokenYn: true);

    if (data != null) {
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> checkEmailDuplication(String email) async {
    print('user service checkEmailDuplication');
    bool data = await _httpClient.getBoolRequest('/register/duplication?email=$email');
    print(data);
    return data;
  }
}
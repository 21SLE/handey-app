import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/user/user_model.dart';
import 'package:handey_app/src/business_logic/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel user = UserModel();
  UserService _userService = UserService();

  Future<Map<String, dynamic>> signUp(UserModel userModel) async {
    return await _userService.signUp(userModel);
  }

  Future<bool> signIn({@required String email, @required String password}) async {
    Map<String, dynamic> data = await _userService.signIn(email, password);
    if(data != null) {
      HttpClient httpClient = HttpClient();
      httpClient.accessToken = data['accessToken'];
      user.userId = data['userId'];
      user.email = email;
      user = await getUserInfo(user.userId);
      return true;
    }
    else {
      return false;
    }
  }

  Future<UserModel> getUserInfo(int userId) async {
    return await _userService.getUserInfo(userId);
  }
}
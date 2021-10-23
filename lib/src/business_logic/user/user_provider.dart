import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/api/http_client.dart';
import 'package:handey_app/src/business_logic/user/user_model.dart';
import 'package:handey_app/src/business_logic/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel user = UserModel();
  UserService _userService = UserService();

  Future<bool> signUp(UserModel userModel) async {
    Map<String, dynamic> data =  await _userService.signUp(userModel);
    if(data != null && data['succeed'])
      return true;
    else
      return false;
  }

  Future<bool> signIn({@required String email, @required String password}) async {
    Map<String, dynamic> data = await _userService.signIn(email, password);
    if(data != null && data['succeed']) {
      HttpClient httpClient = HttpClient();
      httpClient.accessToken = data['accessToken'];
      this.user = await getUserInfo(data['userId']);
      this.user.userId = data['userId'];
      this.user.email = email;
      print(this.user);
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> checkEmailDuplication(String email) async {
    print('user provider checkEmailDuplication');
    return await _userService.checkEmailDuplication(email);
  }


  Future<UserModel> getUserInfo(int userId) async {
    return await _userService.getUserInfo(userId);
  }

  void userNotifyListeners() {
    notifyListeners();
  }
}
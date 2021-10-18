import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';

class SignUp extends StatelessWidget {
  ScreenSize size;
  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text(
          '회원가입'
        ),
      ),
    );
  }
}

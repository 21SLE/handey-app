import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/text_style.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ScreenSize size;
  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTitleText(),
        ],
      )
    );
  }

  Padding buildTitleText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(20)),
      child: Text(
        '로그인 페이지',
        style: rTxtStyle,
      ),
    );
  }
}

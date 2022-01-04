import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/handey_app.dart';
import 'package:handey_app/src/view/utils/popup_custom.dart';
import 'package:handey_app/src/view/utils/popup_returnYn.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final String _baseUrl = 'http://10.0.2.2:3000';

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: size.getSize(200),
            child: DrawerHeader(
              child: Text(
                'HANDEY',
                style: rTxtStyle.copyWith(
                  fontSize: size.getSize(30),
                  color: Color.fromRGBO(254, 192, 1, 1),
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
          ListTile(
            title: Text('설정', style: rTxtStyle.copyWith(fontSize: size.getSize(16)),),
            onTap: () {
              Navigator.pop(context);
              // _launchURL(context, _baseUrl + '/setting');
            },
          ),
          ListTile(
            title: Text('도움말', style: rTxtStyle.copyWith(fontSize: size.getSize(16)),),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('휴지통', style: rTxtStyle.copyWith(fontSize: size.getSize(16)),),
            onTap: () {
              Navigator.pop(context);
              _launchURL(context, _baseUrl + '/trash');
            },
          ),
          ListTile(
            title: Text('정보', style: rTxtStyle.copyWith(fontSize: size.getSize(16)),),
            onTap: () {
              Navigator.pop(context);
              // _launchURL(context, _baseUrl + '/info');
            },
          ),
          ListTile(
            title: Text('로그아웃', style: rTxtStyle.copyWith(fontSize: size.getSize(16)),),
            onTap: () async {
              bool result = await showCustomPopUpYn(
                context: context,
                title: '로그아웃\n하시겠습니까?',
                cancelText: '취소',
                confirmText: '확인'
              );
              if(result)
                returnToLoginPage(context: context, pageRef: HandeyApp());
            },
          )
        ],
      ),
    );
  }
}

void returnToLoginPage({BuildContext context, Widget pageRef}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => pageRef),
          (Route<dynamic> route) => false);
}

void _launchURL(BuildContext context, String url) async =>
    await canLaunch(url)
        ? await launch(url)
        : showCustomPopUp(
        context: context,
        title: '해당 페이지를\n열 수 없습니다.',
        confirmText: '확인');
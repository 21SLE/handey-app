import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

class CostumedAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    String userName = Provider.of<UserProvider>(context, listen: false).user.userName;

    return AppBar(
      leadingWidth: 0,
      leading: Container(),
      backgroundColor: Colors.white,
      title: Text(userName + '님 환영합니다.',
          style: rTxtStyle.copyWith(fontSize: size.getSize(16))),
    );
  }
}

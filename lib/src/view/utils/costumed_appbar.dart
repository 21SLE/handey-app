import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';

class CostumedAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return AppBar(
      leadingWidth: 0,
      leading: Container(),
      backgroundColor: Colors.white,
      title: Text('홍길동님 환영합니다.',
          style: rTxtStyle.copyWith(fontSize: size.getSize(16))),
      actions: [
        Icon(Icons.menu, size: size.getSize(20)),
        Space(width: 11)
      ],
    );
  }
}

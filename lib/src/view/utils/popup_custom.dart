import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';

showCustomPopUp(
    {BuildContext context, String title, String content, String confirmText}) async {
  ScreenSize size = ScreenSize();
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            width: size.getSize(280),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.getSize(18)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Space(height: 34),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      inherit: false,
                      fontSize: 16,
                      color: Colors.black
                  ),
                ),
                Space(height: 23),
                Divider(thickness: 1),
                Space(height: 17),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmText ?? '확인',
                          style: TextStyle(
                              inherit: false,
                              fontSize: 16,
                              color: Colors.yellow
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Space(height: 18),
              ],
            ),
          ),
        ),
      );
    },
  );
}

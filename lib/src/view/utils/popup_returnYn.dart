import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';

showCustomPopUpYn(
    {BuildContext context,
      String title,
      String cancelText,
      confirmText}) async {
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
        child: Material(
          type: MaterialType.transparency,
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
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            height: size.getSize(54),
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(cancelText, style: rTxtStyle.copyWith(color: Colors.grey))
                          ),
                        ),
                      ),
                      Container(
                          height: size.getSize(54.0), width: 1, color: Colors.grey),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            height: size.getSize(54),
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(confirmText, style: rTxtStyle.copyWith(color: Colors.yellow))
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

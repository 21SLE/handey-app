import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';

class Space extends StatelessWidget {
  final double width;
  final double height;

  Space({this.width = 0.0, this.height = 0.0});

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return SizedBox(
      width: size.getSize(width),
      height: size.getSize(height),
    );
  }
}

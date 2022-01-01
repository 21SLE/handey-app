import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';

class ToDoCheckBtn extends StatelessWidget {
  ToDoCheckBtn({@required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
      child: Icon(Icons.check_circle_outline_outlined,size:size.getSize(22.0), color: value ? Color(0xFFFDDC42) : Color(0xFFB6B6B6))
    );
  }
}

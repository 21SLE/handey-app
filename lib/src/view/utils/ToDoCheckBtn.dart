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
      child: Container(
        width: size.getSize(20.0),
        height: size.getSize(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: size.getSize(5.0),
            color: value ? Colors.yellow : Colors.grey.withOpacity(0.3)
          ),
        ),
      ),
    );
  }
}

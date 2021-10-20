import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            CalendarWidget(),
          ],
        )
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      width: size.getSize(300.0),
      height: size.getSize(54.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.getSize(6)),
          color: Colors.yellow),
    );
  }
}


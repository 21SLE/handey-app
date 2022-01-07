import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/utils/colors.dart';


import 'package:handey_app/src/view/utils/screen_size.dart';
OutlineInputBorder outlineInputBorder() {
  ScreenSize size = ScreenSize();
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(size.getSize(6.0)),
      borderSide: BorderSide(color: Colors.grey, width: 2.0));
}

OutlineInputBorder outlineFocusedBorder() {
  ScreenSize size = ScreenSize();
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(size.getSize(6.0)),
      borderSide: BorderSide(color: regularYellow, width: 2.0));
}

UnderlineInputBorder underlineInputBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(width: 2.0, color: Colors.grey),
  );
}

UnderlineInputBorder underlineFocusedBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(width: 2.0, color: regularYellow),
  );
}

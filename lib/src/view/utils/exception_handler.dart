import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/view/error_404.dart';
import 'package:handey_app/src/view/error_500.dart';

void handleException(context, int code) {
  if (code == 400) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return Error404();
      }));
    });
  }

  if (code == 500) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return Error500();
      }));
    });
  }
}
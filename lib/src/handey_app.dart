import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/todo/todo_provider.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/login.dart';
import 'package:provider/provider.dart';

class HandeyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ToDoProvider()),
      ],
      child: MaterialApp(
        title: 'HandeyApp',
        theme: ThemeData(
          // fontFamily: 'AppleSDGothicNeo',
          primarySwatch: Colors.yellow,
        ),
        home: Login(),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/business_logic/todo/todo_model.dart';
import 'package:handey_app/src/business_logic/todo/todo_service.dart';

class ToDoProvider extends ChangeNotifier {
  ToDoBoxModel toDoBox = ToDoBoxModel();
  ToDoService _toDoService = ToDoService();
  List<ToDoBoxModel> toDoBoxList;

  Future<List<ToDoBoxModel>> getToDoBoxList(int userId) async {
    toDoBoxList = await _toDoService.getToDoBoxList(userId);

    return toDoBoxList;
  }

  Future<bool> updateToDoElmCompleted(int toDoElmId) async {
    bool data = await _toDoService.updateToDoElmCompleted(toDoElmId);
    return data;
  }
}
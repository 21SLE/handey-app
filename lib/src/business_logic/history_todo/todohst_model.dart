class ToDoHistoryModel {
  int id;
  String title;
  String saveDt;
  List<ToDoElmHistoryModel> toDoElmHstList;

  ToDoHistoryModel({this.id, this.title, this.saveDt, this.toDoElmHstList});

  ToDoHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    saveDt = json['saveDt'];
    if (json['toDoElmHstList'] != null) {
      toDoElmHstList = new List<ToDoElmHistoryModel>.empty(growable: true);
      json['toDoElmHstList'].forEach((v) {
        toDoElmHstList.add(new ToDoElmHistoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['saveDt'] = this.saveDt;
    if (this.toDoElmHstList != null) {
      data['toDoElmHstList'] =
          this.toDoElmHstList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToDoElmHistoryModel {
  int id;
  bool completed;
  String content;

  ToDoElmHistoryModel({this.id, this.completed, this.content});

  ToDoElmHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    completed = json['completed'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['completed'] = this.completed;
    data['content'] = this.content;
    return data;
  }
}

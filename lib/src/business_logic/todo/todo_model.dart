class ToDoBoxModel {
  int id;
  String title;
  int index;
  bool fixed;
  List<ToDoElmModel> toDoElmList;

  ToDoBoxModel({this.id, this.title, this.index, this.fixed, this.toDoElmList});

  ToDoBoxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    index = json['index'];
    fixed = json['fixed'];
    if (json['toDoElmList'] != null) {
      toDoElmList = new List<ToDoElmModel>.empty(growable: true);
      json['toDoElmList'].forEach((v) {
        toDoElmList.add(new ToDoElmModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['index'] = this.index;
    data['fixed'] = this.fixed;
    if (this.toDoElmList != null) {
      data['toDoElmList'] = this.toDoElmList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToDoElmModel {
  int id;
  String content;
  bool completed;

  ToDoElmModel({this.id, this.content, this.completed});

  ToDoElmModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['completed'] = this.completed;
    return data;
  }
}

class HistoryBoxModel {
  String saveDt;
  List<ToDoBoxHstModel> toDoBoxHstList;
  List<FwBoxHstModel> fwBoxHstList;

  HistoryBoxModel({this.saveDt, this.toDoBoxHstList, this.fwBoxHstList});

  HistoryBoxModel.fromJson(Map<String, dynamic> json) {
    saveDt = json['saveDt'];
    if (json['toDoBoxHstList'] != null) {
      toDoBoxHstList = new List<ToDoBoxHstModel>.empty(growable: true);
      json['toDoBoxHstList'].forEach((v) {
        toDoBoxHstList.add(new ToDoBoxHstModel.fromJson(v));
      });
    }
    if (json['fwBoxList'] != null) {
      fwBoxHstList = new List<FwBoxHstModel>.empty(growable: true);
      json['fwBoxList'].forEach((v) {
        fwBoxHstList.add(new FwBoxHstModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saveDt'] = this.saveDt;
    if (this.toDoBoxHstList != null) {
      data['toDoBoxHstList'] =
          this.toDoBoxHstList.map((v) => v.toJson()).toList();
    }
    if (this.fwBoxHstList != null) {
      data['fwBoxList'] = this.fwBoxHstList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToDoBoxHstModel {
  int id;
  String title;
  String saveDt;
  List<ToDoElmHstModel> toDoElmHstList;

  ToDoBoxHstModel({this.id, this.title, this.saveDt, this.toDoElmHstList});

  ToDoBoxHstModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    saveDt = json['saveDt'];
    if (json['toDoElmHstList'] != null) {
      toDoElmHstList = new List<ToDoElmHstModel>.empty(growable: true);
      json['toDoElmHstList'].forEach((v) {
        toDoElmHstList.add(new ToDoElmHstModel.fromJson(v));
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

class ToDoElmHstModel {
  int id;
  bool completed;
  String content;

  ToDoElmHstModel({this.id, this.completed, this.content});

  ToDoElmHstModel.fromJson(Map<String, dynamic> json) {
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

class FwBoxHstModel {
  int id;
  String title;
  String saveDt;
  List<FwElmHstModel> fwElmList;

  FwBoxHstModel({this.id, this.title, this.saveDt, this.fwElmList});

  FwBoxHstModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    saveDt = json['saveDt'];
    if (json['fwElmList'] != null) {
      fwElmList = new List<FwElmHstModel>.empty(growable: true);
      json['fwElmList'].forEach((v) {
        fwElmList.add(new FwElmHstModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['saveDt'] = this.saveDt;
    if (this.fwElmList != null) {
      data['fwElmList'] = this.fwElmList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FwElmHstModel {
  int id;
  String content;

  FwElmHstModel({this.id, this.content});

  FwElmHstModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    return data;
  }
}

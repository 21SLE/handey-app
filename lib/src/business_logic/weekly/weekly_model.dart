class WeeklyBoxModel {
  int id;
  String title;
  List<WeeklyElmModel> weeklyElmList;

  WeeklyBoxModel({this.id, this.title, this.weeklyElmList});

  WeeklyBoxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['weeklyElmList'] != null) {
      weeklyElmList = new List<WeeklyElmModel>.empty(growable: true);
      json['weeklyElmList'].forEach((v) {
        weeklyElmList.add(new WeeklyElmModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.weeklyElmList != null) {
      data['weeklyElmList'] =
          this.weeklyElmList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeeklyElmModel {
  int id;
  String content;
  bool completed;

  WeeklyElmModel({this.id, this.content, this.completed});

  WeeklyElmModel.fromJson(Map<String, dynamic> json) {
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

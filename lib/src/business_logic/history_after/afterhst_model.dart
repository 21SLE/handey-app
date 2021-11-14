class AfterHistoryModel {
  int id;
  String content;
  String histDate;
  bool subtitle;

  AfterHistoryModel({this.id, this.content, this.histDate, this.subtitle});

  AfterHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    histDate = json['hist_date'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['hist_date'] = this.histDate;
    data['subtitle'] = this.subtitle;
    return data;
  }
}

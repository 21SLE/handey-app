class ScheduleEventModel {
  String content;
  dynamic startDt;
  dynamic endDt;

  ScheduleEventModel({this.content, this.startDt, this.endDt});

  ScheduleEventModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    startDt = json['startDt'];
    endDt = json['endDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['startDt'] = this.startDt;
    data['endDt'] = this.endDt;
    return data;
  }
}

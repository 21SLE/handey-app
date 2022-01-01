class FwBoxModel {
  int id;
  String title;
  String saveDt;
  List<FwElmModel> fwElmList;

  FwBoxModel({this.id, this.title, this.saveDt, this.fwElmList});

  FwBoxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    saveDt = json['saveDt'];
    if (json['fwElmList'] != null) {
      fwElmList = new List<FwElmModel>.empty(growable: true);
      json['fwElmList'].forEach((v) {
        fwElmList.add(new FwElmModel.fromJson(v));
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

class FwElmModel {
  int id;
  String content;

  FwElmModel({this.id, this.content});

  FwElmModel.fromJson(Map<String, dynamic> json) {
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

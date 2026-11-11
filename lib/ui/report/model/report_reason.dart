class ReportReason {
  String? sId;
  String? title;
  String? createdAt;
  String? updatedAt;

  ReportReason({this.sId, this.title, this.createdAt, this.updatedAt});

  ReportReason.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

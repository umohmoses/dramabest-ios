import 'dart:convert';

NewReleasesVideoModel newReleasesVideoModelFromJson(String str) => NewReleasesVideoModel.fromJson(json.decode(str));
String newReleasesVideoModelToJson(NewReleasesVideoModel data) => json.encode(data.toJson());

class NewReleasesVideoModel {
  NewReleasesVideoModel({
    bool? status,
    String? message,
    List<NewReleasesVideos>? videos,
  }) {
    _status = status;
    _message = message;
    _videos = videos;
  }

  NewReleasesVideoModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['videos'] != null) {
      _videos = [];
      json['videos'].forEach((v) {
        _videos?.add(NewReleasesVideos.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<NewReleasesVideos>? _videos;
  NewReleasesVideoModel copyWith({
    bool? status,
    String? message,
    List<NewReleasesVideos>? videos,
  }) =>
      NewReleasesVideoModel(
        status: status ?? _status,
        message: message ?? _message,
        videos: videos ?? _videos,
      );
  bool? get status => _status;
  String? get message => _message;
  List<NewReleasesVideos>? get videos => _videos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_videos != null) {
      map['videos'] = _videos?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

NewReleasesVideos videosFromJson(String str) => NewReleasesVideos.fromJson(json.decode(str));
String videosToJson(NewReleasesVideos data) => json.encode(data.toJson());

class NewReleasesVideos {
  NewReleasesVideos({
    String? id,
    String? name,
    String? thumbnail,
    String? languageName,
    num? totalViews,
  }) {
    _id = id;
    _name = name;
    _thumbnail = thumbnail;
    _languageName = languageName;
    _totalViews = totalViews;
  }

  NewReleasesVideos.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _thumbnail = json['thumbnail'];
    _totalViews = json['totalViews'];
    _languageName = json['languageName'];
  }
  String? _id;
  String? _name;
  String? _thumbnail;
  String? _languageName;
  num? _totalViews;
  NewReleasesVideos copyWith({
    String? id,
    String? name,
    String? thumbnail,
    String? languageName,
    num? totalViews,
  }) =>
      NewReleasesVideos(
        id: id ?? _id,
        name: name ?? _name,
        thumbnail: thumbnail ?? _thumbnail,
        languageName: languageName ?? _languageName,
        totalViews: views ?? _totalViews,
      );
  String? get id => _id;
  String? get name => _name;
  String? get thumbnail => _thumbnail;
  String? get languageName => _languageName;
  num? get views => _totalViews;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['thumbnail'] = _thumbnail;
    map['languageName'] = _languageName;
    map['views'] = _totalViews;
    return map;
  }
}

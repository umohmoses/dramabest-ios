import 'dart:convert';

GetMoviesSeriesModel getMoviesSeriesModelFromJson(String str) => GetMoviesSeriesModel.fromJson(json.decode(str));
String getMoviesSeriesModelToJson(GetMoviesSeriesModel data) => json.encode(data.toJson());

class GetMoviesSeriesModel {
  GetMoviesSeriesModel({
    bool? status,
    String? message,
    List<GetMoviesSeriesData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  GetMoviesSeriesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GetMoviesSeriesData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<GetMoviesSeriesData>? _data;
  GetMoviesSeriesModel copyWith({
    bool? status,
    String? message,
    List<GetMoviesSeriesData>? data,
  }) =>
      GetMoviesSeriesModel(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );
  bool? get status => _status;
  String? get message => _message;
  List<GetMoviesSeriesData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

GetMoviesSeriesData dataFromJson(String str) => GetMoviesSeriesData.fromJson(json.decode(str));
String dataToJson(GetMoviesSeriesData data) => json.encode(data.toJson());

class GetMoviesSeriesData {
  GetMoviesSeriesData({
    String? id,
    String? thumbnail,
  }) {
    _id = id;
    _thumbnail = thumbnail;
  }

  GetMoviesSeriesData.fromJson(dynamic json) {
    _id = json['_id'];
    _thumbnail = json['thumbnail'];
  }
  String? _id;
  String? _thumbnail;
  GetMoviesSeriesData copyWith({
    String? id,
    String? thumbnail,
  }) =>
      GetMoviesSeriesData(
        id: id ?? _id,
        thumbnail: thumbnail ?? _thumbnail,
      );
  String? get id => _id;
  String? get thumbnail => _thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['thumbnail'] = _thumbnail;
    return map;
  }
}

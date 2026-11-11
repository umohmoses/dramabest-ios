import 'dart:convert';

MostSearchedModel mostSearchedModelFromJson(String str) => MostSearchedModel.fromJson(json.decode(str));

String mostSearchedModelToJson(MostSearchedModel data) => json.encode(data.toJson());

class MostSearchedModel {
  bool? status;
  String? message;
  int? total;
  List<MostSearchedList>? data;

  MostSearchedModel({
    this.status,
    this.message,
    this.total,
    this.data,
  });

  factory MostSearchedModel.fromJson(Map<String, dynamic> json) => MostSearchedModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        data: json["data"] == null ? [] : List<MostSearchedList>.from(json["data"]!.map((x) => MostSearchedList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MostSearchedList {
  String? id;
  MovieSeriesId? movieSeriesId;
  int? count;
  DateTime? lastSearchedAt;

  MostSearchedList({
    this.id,
    this.movieSeriesId,
    this.count,
    this.lastSearchedAt,
  });

  factory MostSearchedList.fromJson(Map<String, dynamic> json) => MostSearchedList(
        id: json["_id"],
        movieSeriesId: json["movieSeriesId"] == null ? null : MovieSeriesId.fromJson(json["movieSeriesId"]),
        count: json["count"],
        lastSearchedAt: json["lastSearchedAt"] == null ? null : DateTime.parse(json["lastSearchedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "movieSeriesId": movieSeriesId?.toJson(),
        "count": count,
        "lastSearchedAt": lastSearchedAt?.toIso8601String(),
      };
}

class MovieSeriesId {
  String? id;
  String? name;

  MovieSeriesId({
    this.id,
    this.name,
  });

  factory MovieSeriesId.fromJson(Map<String, dynamic> json) => MovieSeriesId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

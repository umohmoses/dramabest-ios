import 'dart:convert';

CategoryWiseModel categoryWiseModelFromJson(String str) => CategoryWiseModel.fromJson(json.decode(str));

String categoryWiseModelToJson(CategoryWiseModel data) => json.encode(data.toJson());

class CategoryWiseModel {
  bool? status;
  String? message;
  List<Video>? videos;

  CategoryWiseModel({
    this.status,
    this.message,
    this.videos,
  });

  factory CategoryWiseModel.fromJson(Map<String, dynamic> json) => CategoryWiseModel(
        status: json["status"],
        message: json["message"],
        videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
      };
}

class Video {
  String? id;
  String? name;
  String? description;
  String? thumbnail;
  DateTime? releaseDate;
  bool? isAddedToList;
  int? totalViews;
  String? languageName;

  Video({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.releaseDate,
    this.isAddedToList,
    this.totalViews,
    this.languageName,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        releaseDate: json["releaseDate"] == null ? null : DateTime.parse(json["releaseDate"]),
        isAddedToList: json["isAddedToList"],
        totalViews: json["totalViews"],
        languageName: json["languageName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "thumbnail": thumbnail,
        "releaseDate": releaseDate?.toIso8601String(),
        "isAddedToList": isAddedToList,
        "totalViews": totalViews,
        "languageName": languageName,
      };
}

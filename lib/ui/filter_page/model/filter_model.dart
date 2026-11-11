import 'dart:convert';

FilterWiseDataModel filterWiseDataModelFromJson(String str) => FilterWiseDataModel.fromJson(json.decode(str));

String filterWiseDataModelToJson(FilterWiseDataModel data) => json.encode(data.toJson());

class FilterWiseDataModel {
  bool? status;
  String? message;
  int? totalCount;
  List<FilterData>? filterData;

  FilterWiseDataModel({
    this.status,
    this.message,
    this.totalCount,
    this.filterData,
  });

  factory FilterWiseDataModel.fromJson(Map<String, dynamic> json) => FilterWiseDataModel(
        status: json["status"],
        message: json["message"],
        totalCount: json["totalCount"],
        filterData: json["filterData"] == null ? [] : List<FilterData>.from(json["filterData"]!.map((x) => FilterData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalCount": totalCount,
        "filterData": filterData == null ? [] : List<dynamic>.from(filterData!.map((x) => x.toJson())),
      };
}

class FilterData {
  String? id;
  String? name;
  String? description;
  String? banner;
  String? thumbnail;
  int? type;
  DateTime? releaseDate;
  bool? isTrending;
  String? categoryId;
  String? category;
  String? languageId;
  String? languageName;

  FilterData({
    this.id,
    this.name,
    this.description,
    this.banner,
    this.thumbnail,
    this.type,
    this.releaseDate,
    this.isTrending,
    this.categoryId,
    this.category,
    this.languageId,
    this.languageName,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) => FilterData(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        banner: json["banner"],
        thumbnail: json["thumbnail"],
        type: json["type"],
        releaseDate: json["releaseDate"] == null ? null : DateTime.parse(json["releaseDate"]),
        isTrending: json["isTrending"],
        categoryId: json["categoryId"],
        category: json["category"],
        languageId: json["languageId"],
        languageName: json["languageName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "banner": banner,
        "thumbnail": thumbnail,
        "type": type,
        "releaseDate": releaseDate?.toIso8601String(),
        "isTrending": isTrending,
        "categoryId": categoryId,
        "category": category,
        "languageId": languageId,
        "languageName": languageName,
      };
}

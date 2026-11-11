import 'dart:convert';

AllCategoryModel allCategoryModelFromJson(String str) => AllCategoryModel.fromJson(json.decode(str));

String allCategoryModelToJson(AllCategoryModel data) => json.encode(data.toJson());

class AllCategoryModel {
  bool? status;
  String? message;
  int? total;
  List<CategoryList>? data;

  AllCategoryModel({
    this.status,
    this.message,
    this.total,
    this.data,
  });

  factory AllCategoryModel.fromJson(Map<String, dynamic> json) => AllCategoryModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        data: json["data"] == null ? [] : List<CategoryList>.from(json["data"]!.map((x) => CategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryList {
  String? id;
  String? name;
  String? image;

  CategoryList({
    this.id,
    this.name,
    this.image,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
      };
}

import 'dart:convert';

LanguageListModel languageListModelFromJson(String str) => LanguageListModel.fromJson(json.decode(str));

String languageListModelToJson(LanguageListModel data) => json.encode(data.toJson());

class LanguageListModel {
  bool? status;
  String? message;
  int? total;
  List<Language>? data;

  LanguageListModel({
    this.status,
    this.message,
    this.total,
    this.data,
  });

  factory LanguageListModel.fromJson(Map<String, dynamic> json) => LanguageListModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        data: json["data"] == null ? [] : List<Language>.from(json["data"]!.map((x) => Language.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Language {
  String? id;
  String? name;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Language({
    this.id,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["_id"],
        name: json["name"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

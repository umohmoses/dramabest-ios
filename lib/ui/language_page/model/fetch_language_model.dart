import 'dart:convert';
import 'package:story_box/localization/models/language_info.dart';

FetchLanguageModel fetchLanguageModelFromJson(String str) => FetchLanguageModel.fromJson(json.decode(str));

String fetchLanguageModelToJson(FetchLanguageModel data) => json.encode(data.toJson());

class FetchLanguageModel {
  bool? status;
  String? message;
  List<LanguageInfo>? docs;
  int? total;

  FetchLanguageModel({
    this.status,
    this.message,
    this.docs,
    this.total,
  });

  factory FetchLanguageModel.fromJson(Map<String, dynamic> json) => FetchLanguageModel(
        status: json["status"],
        message: json["message"],
        docs: json["docs"] == null ? [] : List<LanguageInfo>.from(json["docs"]!.map((x) => LanguageInfo.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "docs": docs == null ? [] : List<dynamic>.from(docs!.map((x) => x.toJson())),
        "total": total,
      };
}

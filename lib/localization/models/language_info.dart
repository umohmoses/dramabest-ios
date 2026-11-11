// class LanguageInfo {
//   final String code;
//   final String name;
//   final String nativeName;
//   final String icon;
//   final bool isDefault;
//
//   LanguageInfo({
//     required this.code,
//     required this.name,
//     required this.nativeName,
//     this.icon = "",
//     this.isDefault = false,
//   });
//
//   factory LanguageInfo.fromJson(Map<String, dynamic> json) {
//     final String languageCode = json['languageCode'] ?? json['code'] ?? '';
//     return LanguageInfo(
//       code: languageCode,
//       name: json['name'] ?? json['languageTitle'] ?? "",
//       nativeName: json['nativeName'] ?? json['native_name'] ?? json['localLanguageTitle'] ?? "",
//       icon: json['languageIcon'] ?? "",
//       isDefault: json['isDefault'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'code': code, 'name': name, 'nativeName': nativeName, 'icon': icon, 'isDefault': isDefault};
//   }
// }

class LanguageInfo {
  final String id;
  final String languageTitle;
  final String languageCode;
  final String localLanguageTitle;
  final String languageIcon;
  final int errorCount;
  final bool isActive;
  final bool isDefault;
  final Map<String, String> translations; // fetchAll થી આવે
  final DateTime createdAt;
  final DateTime updatedAt;

  LanguageInfo({
    this.id = "",
    this.languageTitle = "",
    this.languageCode = "",
    this.localLanguageTitle = "",
    this.languageIcon = "",
    this.errorCount = 0,
    this.isActive = false,
    this.isDefault = false,
    this.translations = const {},
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime(1970),
        updatedAt = updatedAt ?? DateTime(1970);

  factory LanguageInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LanguageInfo();

    // translations — fetchAll response માં હોય છે
    Map<String, String> parsedTranslations = {};
    if (json["translations"] is Map) {
      (json["translations"] as Map).forEach((k, v) {
        parsedTranslations[k.toString()] = v?.toString() ?? "";
      });
    }

    return LanguageInfo(
      id: json["_id"]?.toString() ?? "",
      languageTitle: json["languageTitle"]?.toString() ?? "",
      languageCode: json["languageCode"]?.toString() ?? "",
      localLanguageTitle: json["localLanguageTitle"]?.toString() ?? "",
      languageIcon: json["languageIcon"]?.toString() ?? "",
      errorCount: _toInt(json["errorCount"]),
      isActive: _toBool(json["isActive"]),
      isDefault: _toBool(json["isDefault"]),
      translations: parsedTranslations,
      createdAt: _toDate(json["createdAt"]),
      updatedAt: _toDate(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "languageTitle": languageTitle,
        "languageCode": languageCode,
        "localLanguageTitle": localLanguageTitle,
        "languageIcon": languageIcon,
        "errorCount": errorCount,
        "isActive": isActive,
        "isDefault": isDefault,
        "translations": translations,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value.toString() == "1") return true;
    if (value.toString() == "0") return false;
    return value.toString().toLowerCase() == "true";
  }

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime(1970);
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime(1970);
    }
  }
}

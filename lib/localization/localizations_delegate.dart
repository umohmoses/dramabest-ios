import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:story_box/localization/models/language_info.dart';
import 'package:story_box/localization/models/language_model.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

// class AppLanguages extends Translations {
//   final box = GetStorage();
//   final String _langDataPrefix = 'lang_data_';
//   final String _langListKey = 'supported_langs_list';
//
//   /// Returns the code of the language marked as default (isDefault == true).
//   String get _defaultLangCode {
//     final cachedList = box.read(_langListKey);
//     if (cachedList != null && cachedList is List) {
//       try {
//         final langs = cachedList.map((e) => LanguageInfo.fromJson(e)).toList();
//         final def = langs.cast<LanguageInfo?>().firstWhere(
//               (l) => l?.isDefault == true,
//               orElse: () => langs.isNotEmpty ? langs.first : null,
//             );
//         return def?.code ?? '';
//       } catch (_) {}
//     }
//     return '';
//   }
//
//   @override
//   Map<String, Map<String, String>> get keys {
//     Map<String, Map<String, String>> translationsMap = {};
//
//     // 1. Load Default Language (isDefault == true) as fallback
//     final String defCode = _defaultLangCode;
//     if (defCode.isNotEmpty) {
//       var defData = box.read(_langDataPrefix + defCode);
//       if (defData != null) {
//         try {
//           final languageModel = LanguageModel.fromJson(defData);
//           // Use the default language as the fallback locale key
//           translationsMap['${defCode}_US'] = languageModel.translations;
//         } catch (e) {
//           Utils.showLog("Failed to parse cached translations for default ($defCode): $e");
//         }
//       }
//     }
//
//     // 2. Load Current Selected Language
//     String currentLang = Get.locale?.languageCode ?? Preference.selectedLanguage;
//     String currentCountry = Get.locale?.countryCode ?? Preference.selectedCountryCode;
//     String localeKey = "${currentLang}_$currentCountry";
//
//     if (currentLang.isNotEmpty && currentLang != defCode) {
//       var langData = box.read(_langDataPrefix + currentLang);
//       if (langData != null) {
//         try {
//           final languageModel = LanguageModel.fromJson(langData);
//           translationsMap[localeKey] = languageModel.translations;
//         } catch (e) {
//           Utils.showLog("Failed to parse cached translations for $localeKey: $e");
//         }
//       }
//     }
//
//     return translationsMap;
//   }
// }

class AppLanguages extends Translations {
  final box = GetStorage();
  final String _langDataPrefix = 'lang_data_';
  final String _langListKey = 'supported_langs_list';

  /// Returns the code of the language marked as default (isDefault == true).
  String get _defaultLangCode {
    final cachedList = box.read(_langListKey);
    if (cachedList != null && cachedList is List) {
      try {
        final langs = cachedList.map((e) => LanguageInfo.fromJson(e)).toList();
        final def = langs.cast<LanguageInfo?>().firstWhere(
              (l) => l?.isDefault == true,
              orElse: () => langs.isNotEmpty ? langs.first : null,
            );
        return def?.languageCode ?? '';
      } catch (_) {}
    }
    return '';
  }

  @override
  Map<String, Map<String, String>> get keys {
    Map<String, Map<String, String>> translationsMap = {};

    // 1. Load Default Language (isDefault == true) as fallback
    final String defCode = _defaultLangCode;
    if (defCode.isNotEmpty) {
      var defData = box.read(_langDataPrefix + defCode);
      if (defData != null) {
        try {
          final languageModel = LanguageModel.fromJson(defData);
          // Use the default language as the fallback locale key
          translationsMap['${defCode}_US'] = languageModel.translations;
        } catch (e) {
          Utils.showLog("Failed to parse cached translations for default ($defCode): $e");
        }
      }
    }

    // 2. Load Current Selected Language
    String currentLang = Get.locale?.languageCode ?? Preference.selectedLanguage;
    if (currentLang.isEmpty) currentLang = Constant.languageEn;

    String currentCountry = Get.locale?.countryCode ?? Preference.selectedCountryCode;
    if (currentCountry.isEmpty) currentCountry = Constant.countryCodeEn;

    String localeKey = "${currentLang}_$currentCountry";

    if (currentLang.isNotEmpty && currentLang != defCode) {
      var langData = box.read(_langDataPrefix + currentLang);
      if (langData != null) {
        try {
          final languageModel = LanguageModel.fromJson(langData);
          translationsMap[localeKey] = languageModel.translations;
        } catch (e) {
          Utils.showLog("Failed to parse cached translations for $localeKey: $e");
        }
      }
    }

    return translationsMap;
  }
}

// import 'package:get/get.dart';
// import 'package:story_box/localization/languages/language_ar.dart';
// import 'package:story_box/localization/languages/language_bn.dart';
// import 'package:story_box/localization/languages/language_de.dart';
// import 'package:story_box/localization/languages/language_en.dart';
// import 'package:story_box/localization/languages/language_es.dart';
// import 'package:story_box/localization/languages/language_fr.dart';
// import 'package:story_box/localization/languages/language_hi.dart';
// import 'package:story_box/localization/languages/language_id.dart';
// import 'package:story_box/localization/languages/language_it.dart';
// import 'package:story_box/localization/languages/language_ko.dart';
// import 'package:story_box/localization/languages/language_pt.dart';
// import 'package:story_box/localization/languages/language_ru.dart';
// import 'package:story_box/localization/languages/language_sw.dart';
// import 'package:story_box/localization/languages/language_ta.dart';
// import 'package:story_box/localization/languages/language_te.dart';
// import 'package:story_box/localization/languages/language_tr.dart';
// import 'package:story_box/localization/languages/language_ur.dart';
// import 'package:story_box/localization/languages/language_zh.dart';
//
// class AppLanguages extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//         "ar_DZ": arSA,
//         "bn_In": bnIN,
//         "de_De": deDE,
//         "zh_CN": zhCN,
//         "en_US": enUS,
//         "fr_Fr": frFR,
//         "hi_IN": hiIN,
//         "it_In": itIT,
//         "id_ID": idID,
//         "ko_KR": koKR,
//         "pt_PT": ptPT,
//         "ru_RU": ruRU,
//         "es_ES": esES,
//         "sw_KE": swKE,
//         "tr_TR": trTR,
//         "te_IN": teIN,
//         "ta_IN": taIN,
//         "ur_PK": urPK,
//       };
// }
//
// final List<LanguageModel> languages = [
//   LanguageModel("dz", "Arabic (العربية)", 'ar', 'DZ'),
//   LanguageModel("🇮🇳", "Bengali (বাংলা)", 'bn', 'IN'),
//   LanguageModel("🇨🇳", "Chinese Simplified (中国人)", 'zh', 'CN'),
//   LanguageModel("🇺🇸", "English (English)", 'en', 'US'),
//   LanguageModel("🇫🇷", "French (français)", 'fr', 'FR'),
//   LanguageModel("🇩🇪", "German (Deutsche)", 'de', 'DE'),
//   LanguageModel("🇮🇳", "Hindi (हिंदी)", 'hi', 'IN'),
//   LanguageModel("🇮🇹", "Italian (Italian)", 'it', 'IT'),
//   LanguageModel("🇮🇩", "Indonesian (bahasa indo)", 'id', 'ID'),
//   LanguageModel("🇰🇵", "Korean (한국인)", 'ko', 'KR'),
//   LanguageModel("🇵🇹", "Portuguese (Portuguese)", 'pt', 'PT'),
//   LanguageModel("🇷🇺", "Russian (русский)", 'ru', 'RU'),
//   LanguageModel("🇪🇸", "Spanish (Espalier)", 'es', 'ES'),
//   LanguageModel("🇰🇪", "Swahili (Kiswahili)", 'sw', 'KE'),
//   LanguageModel("🇹🇷", "Turkish (Türk)", 'tr', 'TR'),
//   LanguageModel("🇮🇳", "Telugu (తెలుగు)", 'te', 'IN'),
//   LanguageModel("🇮🇳", "Tamil (தமிழ்)", 'ta', 'IN'),
//   LanguageModel("🇵🇰", "(اردو) Urdu", 'ur', 'PK'),
// ];
//
// class LanguageModel {
//   LanguageModel(
//     this.symbol,
//     this.language,
//     this.languageCode,
//     this.countryCode,
//   );
//
//   String language;
//   String symbol;
//   String countryCode;
//   String languageCode;
// }

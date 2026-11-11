import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/localization/models/language_info.dart';
import 'package:story_box/localization/models/language_model.dart';
import 'package:story_box/localization/models/localization_version.dart';
import 'package:story_box/ui/language_page/api/fetch_language_api.dart';
import 'package:story_box/ui/language_page/model/fetch_language_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class LocalizationService extends GetxService {
  final _storage = GetStorage();
  final String _versionKey = 'lang_version';
  final String _langDataPrefix = 'lang_data_';
  final String _langListKey = 'supported_langs_list';

  List<LanguageInfo> supportedLanguages = [];

  /// Returns the language code of the language marked as default (isDefault == true).
  /// Falls back to the first language in the list, or empty string if list is empty.
  String get defaultLanguageCode {
    if (supportedLanguages.isEmpty) return '';
    try {
      return supportedLanguages.firstWhere((l) => l.isDefault).languageCode;
    } catch (_) {
      return supportedLanguages.first.languageCode;
    }
  }

  Future<LocalizationService> init() async {
    Utils.showLog("LocalizationService >>> init()");

    // STEP 1: Load cached language list first (so UI has something immediately)
    _loadCachedLanguageList();

    // STEP 2: Fetch languages from API to get isDefault flag
    // This is the FIRST API call — it gives us isDefault per language
    await fetchInitialLanguages();

    // STEP 3: Determine which language to use
    // Priority: Preference (user previously selected) > API default > fallback constant
    String currentLang = Preference.selectedLanguage;
    String currentCountry = Preference.selectedCountryCode;

    if (currentLang.isEmpty) {
      // No language saved in Preference — use API default (but DON'T save to Preference)
      // Preference is only set when user manually changes language via switchLanguage()
      final String defCode = defaultLanguageCode;
      if (defCode.isNotEmpty) {
        currentLang = defCode;
        currentCountry = _getCountryCodeForLanguage(defCode);
        Utils.showLog("LocalizationService >>> No saved language. Using API default: $currentLang ($currentCountry)");
      } else {
        // API also didn't give us a default — ultimate fallback
        currentLang = Constant.languageEn;
        currentCountry = Constant.countryCodeEn;
        Utils.showLog("LocalizationService >>> No API default found. Falling back to: $currentLang ($currentCountry)");
      }
    }

    if (currentCountry.isEmpty) {
      currentCountry = _getCountryCodeForLanguage(currentLang);
      if (currentCountry.isEmpty) currentCountry = Constant.countryCodeEn;
    }

    Utils.showLog("LocalizationService >>> Using language: $currentLang, country: $currentCountry");

    // STEP 4: Load cached translations for the determined language
    _loadCachedTranslations(
      targetLangCode: currentLang,
      targetCountryCode: currentCountry,
    );

    // STEP 5: Set locale so GetX uses the correct language
    Get.updateLocale(Locale(currentLang, currentCountry));

    // STEP 6: Sync translations (fetch/update from server)
    final bool isFirstLaunch = _storage.read(_versionKey) == null || _storage.read(_langDataPrefix + currentLang) == null;

    if (isFirstLaunch) {
      // Await so translations are ready before runApp()
      await syncTranslations();
    } else {
      // Background update on subsequent launches
      syncTranslations();
    }

    return this;
  }

  /// Fetch languages from fetchLanguages API (findActive endpoint).
  /// This API returns isDefault flag per language — used to determine default language.
  /// This is called FIRST in init() before anything else.
  Future<void> fetchInitialLanguages() async {
    try {
      Utils.showLog("fetchInitialLanguages >>> calling API...");
      final fetchLanguageModel = await FetchLanguageApi.callApi(start: 1, limit: 100);

      if (fetchLanguageModel?.docs != null && (fetchLanguageModel?.docs?.isNotEmpty ?? false)) {
        supportedLanguages = fetchLanguageModel!.docs!;

        // Cache the language list
        _storage.write(
          _langListKey,
          supportedLanguages.map((e) => e.toJson()).toList(),
        );

        Utils.showLog("fetchInitialLanguages >>> ${supportedLanguages.length} languages fetched");
        Utils.showLog("fetchInitialLanguages >>> default language: $defaultLanguageCode");

        // Log all languages with isDefault flag for debugging
        for (var lang in supportedLanguages) {
          Utils.showLog("  - ${lang.languageCode} (${lang.languageTitle}) isDefault=${lang.isDefault}");
        }
      } else {
        Utils.showLog("fetchInitialLanguages >>> no languages returned from API");
      }
    } catch (e) {
      Utils.showLog("fetchInitialLanguages >>> failed: $e");
      // If API fails, we still have cached data from _loadCachedLanguageList()
    }
  }

  /// Get country code for a language code from supportedLanguages list.
  /// Returns empty string if not found.
  String _getCountryCodeForLanguage(String langCode) {
    try {
      // final lang = supportedLanguages.firstWhere(
      //   (l) => l.languageCode == langCode,
      // );
      // If LanguageInfo has a country code field, use it.
      // Otherwise derive from language code (e.g., "hi" -> "IN", "en" -> "US")
      return _deriveCountryCode(langCode);
    } catch (_) {
      return _deriveCountryCode(langCode);
    }
  }

  /// Derive country code from language code
  String _deriveCountryCode(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'en':
        return 'US';
      case 'hi':
        return 'IN';
      case 'gu':
        return 'IN';
      case 'ta':
        return 'IN';
      case 'te':
        return 'IN';
      case 'ml':
        return 'IN';
      case 'kn':
        return 'IN';
      case 'bn':
        return 'IN';
      case 'mr':
        return 'IN';
      case 'pa':
        return 'IN';
      case 'ur':
        return 'PK';
      case 'es':
        return 'ES';
      case 'fr':
        return 'FR';
      case 'de':
        return 'DE';
      case 'pt':
        return 'BR';
      case 'ar':
        return 'SA';
      case 'ja':
        return 'JP';
      case 'ko':
        return 'KR';
      case 'zh':
        return 'CN';
      default:
        return 'US';
    }
  }

  /// Instantly load translations from GetStorage into GetX memory.
  /// Pass [targetLangCode] and [targetCountryCode] to force loading a specific language
  /// (used during language switch when Get.locale is still the old locale).
  void _loadCachedTranslations({String? targetLangCode, String? targetCountryCode}) {
    String langCode = targetLangCode ?? Get.locale?.languageCode ?? Preference.selectedLanguage;
    if (langCode.isEmpty) langCode = Constant.languageEn;

    String countryCodeVal = targetCountryCode ?? Get.locale?.countryCode ?? Preference.selectedCountryCode;
    if (countryCodeVal.isEmpty) countryCodeVal = Constant.countryCodeEn;

    final String localeKey = "${langCode}_$countryCodeVal";
    Utils.showLog("_loadCachedTranslations: langCode=$langCode, localeKey=$localeKey");

    final cachedData = _storage.read(_langDataPrefix + langCode);
    if (cachedData != null && cachedData is Map) {
      if (cachedData.containsKey('code') && !cachedData.containsKey('doc')) {
        Utils.showLog("Detected old-format cache for $langCode. Clearing.");
        _storage.remove(_langDataPrefix + langCode);
        return;
      }

      try {
        final languageModel = LanguageModel.fromJson(Map<String, dynamic>.from(cachedData));

        final cachedLangCode = languageModel.code;
        if (cachedLangCode.isNotEmpty && cachedLangCode != langCode) {
          Utils.showLog("Cache mismatch: expected $langCode but got $cachedLangCode. Clearing.");
          _storage.remove(_langDataPrefix + langCode);
          return;
        }

        final translations = languageModel.translations;
        if (translations.isEmpty) {
          Utils.showLog("Empty translations for $langCode. Skipping.");
          return;
        }

        Get.appendTranslations({localeKey: translations});
        Utils.showLog("_loadCachedTranslations >>> $langCode loaded (${translations.length} keys)");
      } catch (e) {
        Utils.showLog("_loadCachedTranslations >>> parse failed for $langCode: $e");
      }
    }
  }

  void _loadCachedLanguageList() {
    final cachedData = _storage.read(_langListKey);
    if (cachedData != null && cachedData is List) {
      try {
        supportedLanguages = cachedData.map((e) => LanguageInfo.fromJson(e)).toList();
        Utils.showLog("_loadCachedLanguageList >>> ${supportedLanguages.length} languages, default: $defaultLanguageCode");
      } catch (e) {
        Utils.showLog("_loadCachedLanguageList >>> failed: $e");
      }
    }
  }

  /// Check version and fetch new translations if necessary
  Future<void> syncTranslations() async {
    try {
      Utils.showLog("syncTranslations >>> checking version");
      final versionRes = await http.get(
        Uri.parse(ApiConstant.getBaseURL() + ApiConstant.fetchLatestLanguageVersion),
        headers: {"key": ApiConstant.SECRET_KEY},
      );

      if (versionRes.statusCode == 200) {
        final versionData = LocalizationVersion.fromJson(jsonDecode(versionRes.body));
        final onlineVersion = versionData.version;
        final localVersion = _storage.read(_versionKey);
        Utils.showLog("syncTranslations >>> local=$localVersion, online=$onlineVersion");

        if (localVersion != onlineVersion || supportedLanguages.isEmpty) {
          Utils.showLog("syncTranslations >>> update required, fetching...");

          // Re-fetch language list
          await fetchSupportedLanguages();

          // Fetch default language translations
          final String defCode = defaultLanguageCode;
          if (defCode.isNotEmpty) {
            await fetchAndCacheLanguage(defCode);

            // If user hasn't selected a language yet, apply the API default locale (but don't save to Preference)
            if (Preference.selectedLanguage.isEmpty) {
              final String defCountry = _getCountryCodeForLanguage(defCode);
              Get.updateLocale(Locale(defCode, defCountry));
            }
          }

          // Fetch currently selected language if different from default
          final String currentLang = Get.locale?.languageCode ?? Preference.selectedLanguage;
          if (currentLang.isNotEmpty && currentLang != defCode) {
            await fetchAndCacheLanguage(currentLang);
          }

          _storage.write(_versionKey, onlineVersion);
        } else {
          // Version matches — guard against missing cache
          final String defCode = defaultLanguageCode;
          if (defCode.isNotEmpty && _storage.read(_langDataPrefix + defCode) == null) {
            await fetchAndCacheLanguage(defCode);
          }

          final String currentLang = Get.locale?.languageCode ?? Preference.selectedLanguage;
          if (currentLang.isNotEmpty && currentLang != defCode && _storage.read(_langDataPrefix + currentLang) == null) {
            await fetchAndCacheLanguage(currentLang);
          }
        }
      }
    } catch (e) {
      Utils.showLog("syncTranslations >>> failed: $e (using cache fallback)");
    }
  }

  /// Uses fetchAll endpoint to get languages with translations
  Future<void> fetchSupportedLanguages() async {
    try {
      final url = "${ApiConstant.getBaseURL()}${ApiConstant.fetchAll}?module=app";
      final res = await http.get(Uri.parse(url), headers: {"key": ApiConstant.SECRET_KEY});

      if (res.statusCode == 200) {
        final fetchLanguageModel = FetchLanguageModel.fromJson(jsonDecode(res.body));

        if (fetchLanguageModel.docs != null && (fetchLanguageModel.docs?.isNotEmpty ?? false)) {
          // Merge with existing supportedLanguages to preserve isDefault flag
          final Map<String, LanguageInfo> existingMap = {
            for (var l in supportedLanguages) l.languageCode: l,
          };

          for (var doc in fetchLanguageModel.docs!) {
            if (existingMap.containsKey(doc.languageCode)) {
              // Keep the isDefault from fetchInitialLanguages, merge translations
              final existing = existingMap[doc.languageCode]!;
              existingMap[doc.languageCode] = LanguageInfo(
                id: existing.id.isNotEmpty ? existing.id : doc.id,
                languageTitle: existing.languageTitle.isNotEmpty ? existing.languageTitle : doc.languageTitle,
                languageCode: existing.languageCode,
                localLanguageTitle: existing.localLanguageTitle.isNotEmpty ? existing.localLanguageTitle : doc.localLanguageTitle,
                languageIcon: existing.languageIcon.isNotEmpty ? existing.languageIcon : doc.languageIcon,
                errorCount: existing.errorCount,
                isActive: existing.isActive,
                isDefault: existing.isDefault, // Keep isDefault from findActive API
                translations: doc.translations.isNotEmpty ? doc.translations : existing.translations,
                createdAt: existing.createdAt,
                updatedAt: existing.updatedAt,
              );
            } else {
              existingMap[doc.languageCode] = doc;
            }
          }

          supportedLanguages = existingMap.values.toList();
          _storage.write(_langListKey, supportedLanguages.map((e) => e.toJson()).toList());
          Utils.showLog("fetchSupportedLanguages >>> ${supportedLanguages.length} languages, default: $defaultLanguageCode");
        }
      } else {
        Utils.showLog("fetchSupportedLanguages >>> failed: ${res.statusCode}");
      }
    } catch (e) {
      Utils.showLog("fetchSupportedLanguages >>> exception: $e");
    }
  }

  /// Download specific language from API and inject into GetX
  Future<void> fetchAndCacheLanguage(String langCode) async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConstant.getBaseURL()}${ApiConstant.fetchLanguageTranslations}?languageCode=$langCode&module=app"),
        headers: {"key": ApiConstant.SECRET_KEY},
      );

      if (res.statusCode == 200) {
        final rawJson = jsonDecode(res.body);
        final languageModel = LanguageModel.fromJson(rawJson);

        // 1. Persist to GetStorage
        _storage.write(_langDataPrefix + langCode, languageModel.toJson());

        // 2. Inject into GetX memory
        String countryCodeVal = Get.locale?.countryCode ?? Preference.selectedCountryCode;
        if (countryCodeVal.isEmpty) countryCodeVal = _getCountryCodeForLanguage(langCode);
        if (countryCodeVal.isEmpty) countryCodeVal = Constant.countryCodeEn;

        final String localeKey = "${langCode}_$countryCodeVal";
        Get.appendTranslations({localeKey: languageModel.translations});

        // 3. Update version if present
        if (languageModel.version.isNotEmpty) {
          _storage.write(_versionKey, languageModel.version);
        }

        // 4. Force UI refresh only for active locale
        if (Get.locale?.languageCode == langCode) {
          Get.updateLocale(Get.locale!);
        }

        Utils.showLog("fetchAndCacheLanguage >>> '$langCode' applied (key: $localeKey)");
      } else {
        Utils.showLog("fetchAndCacheLanguage >>> failed for '$langCode': ${res.statusCode}");
      }
    } catch (e) {
      Utils.showLog("fetchAndCacheLanguage >>> exception for '$langCode': $e");
    }
  }

  /// Call this when the user manually switches language in settings
  Future<void> switchLanguage(String langCode, String countryCode) async {
    if (countryCode.isEmpty) countryCode = _getCountryCodeForLanguage(langCode);
    if (countryCode.isEmpty) countryCode = Constant.countryCodeEn;

    final Locale newLocale = Locale(langCode, countryCode);

    // Save to Preference so it persists across app restarts
    await Preference.onSetSelectedLanguage(langCode);
    await Preference.onSetSelectedCountryCode(countryCode);

    // Fetch latest translations
    await fetchAndCacheLanguage(langCode);

    // Load from cache into GetX
    _loadCachedTranslations(targetLangCode: langCode, targetCountryCode: countryCode);

    // Update locale — triggers UI rebuild
    Get.updateLocale(newLocale);
  }
}

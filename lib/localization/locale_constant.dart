import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/localization/localization_service.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

Future<Locale> getLocale() async {
  String languageCode = Preference.selectedLanguage;
  String countryCode = Preference.selectedCountryCode;

  // If Preference is empty, use API default language from LocalizationService
  if (languageCode.isEmpty) {
    try {
      final locService = Get.find<LocalizationService>();
      final defCode = locService.defaultLanguageCode;
      if (defCode.isNotEmpty) {
        languageCode = defCode;
      }
    } catch (_) {
      // LocalizationService not yet registered — fall through to constant
    }
  }

  Utils.showLog("Selected Language => $languageCode >>> $countryCode");
  return _locale(languageCode, countryCode);
}

Locale _locale(String languageCode, String countryCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, countryCode.isNotEmpty ? countryCode : Constant.countryCodeEn)
      : Locale(Constant.languageEn, Constant.countryCodeEn);
}

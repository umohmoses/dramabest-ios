import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/localization/localization_service.dart';
import 'package:story_box/localization/models/language_info.dart';
import 'package:story_box/ui/language_page/api/fetch_language_api.dart';
import 'package:story_box/ui/language_page/model/fetch_language_model.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class LanguageController extends GetxController {
  LanguageInfo? languageInfo;
  String? languageCode;
  String? countryCode;

  // Pagination state
  RxList<LanguageInfo> languages = <LanguageInfo>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;

  int start = 1;
  int limit = 20;
  bool hasMore = true;

  FetchLanguageModel? fetchLanguageModel;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    init();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      loadMoreLanguages();
    }
  }

  final List countryFlags = [
    AppAsset.icArabia,
    AppAsset.icBangladesh,
    AppAsset.icChinese,
    AppAsset.icUnitedStates,
    AppAsset.icFrance,
    AppAsset.icGermany,
    AppAsset.icIndia,
    AppAsset.icItalian,
    AppAsset.icIndonesia,
    AppAsset.icJapan,
    AppAsset.icKorean,
    AppAsset.icIndia,
    AppAsset.icBrazil,
    AppAsset.icRussian,
    AppAsset.icSpain,
    AppAsset.icSwahili,
    AppAsset.icTurkey,
    AppAsset.icIndia,
    AppAsset.icIndia,
    AppAsset.icPakistan,
  ];

  void init() async {
    languageCode = Preference.selectedLanguage;
    countryCode = Preference.selectedCountryCode;

    await fetchInitialLanguages();

    if (languages.isNotEmpty) {
      try {
        languageInfo = languages.firstWhere((element) => element.languageCode == languageCode, orElse: () => languages.first);
      } catch (e) {
        languageInfo = languages.first;
      }
    }
    update(["onChangeLanguage"]);
  }

  Future<void> fetchInitialLanguages() async {
    try {
      isLoading.value = true;
      start = 1;
      hasMore = true;
      languages.clear();

      fetchLanguageModel = await FetchLanguageApi.callApi(start: start, limit: limit);

      if (fetchLanguageModel?.docs != null && (fetchLanguageModel?.docs?.isNotEmpty ?? false)) {
        languages.addAll(fetchLanguageModel!.docs!);

        if (fetchLanguageModel!.docs!.length < limit) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      Utils.showLog("Fetch Initial Languages Failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreLanguages() async {
    if (isMoreLoading.value || !hasMore || isLoading.value) return;

    try {
      isMoreLoading.value = true;
      start += limit;

      fetchLanguageModel = await FetchLanguageApi.callApi(start: start, limit: limit);

      if (fetchLanguageModel?.docs != null && (fetchLanguageModel?.docs?.isNotEmpty ?? false)) {
        languages.addAll(fetchLanguageModel!.docs!);

        if (fetchLanguageModel!.docs!.length < limit) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      Utils.showLog("Load More Languages Failed: $e");
      start -= limit;
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchInitialLanguages();
  }

  void onChangeLanguage(LanguageInfo value) async {
    languageInfo = value;

    // Fallback country code if not available in LanguageInfo
    final targetCountryCode = "US"; // Assuming US/EN default for now, can be improved

    Preference.onSetSelectedLanguage(languageInfo!.languageCode);
    Preference.onSetSelectedCountryCode(targetCountryCode);

    final localizationService = Get.find<LocalizationService>();
    await localizationService.switchLanguage(languageInfo!.languageCode, targetCountryCode);

    update(["onChangeLanguage"]);
  }
}

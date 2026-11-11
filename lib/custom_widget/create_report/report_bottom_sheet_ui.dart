import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/create_report/create_report_api.dart';
import 'package:story_box/custom_widget/create_report/fetch_report_api.dart';
import 'package:story_box/custom_widget/create_report/fetch_report_model.dart';
import 'package:story_box/custom_widget/create_report/report_bottom_sheet_shimmer_ui.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class ReportBottomSheetUi {
  static RxInt selectedReportType = 0.obs;

  static RxBool isLoading = false.obs;

  static FetchReportModel? fetchReportModel;

  static List<Data> reportTypes = [];

  static Future<void> onSendReport({
    required String eventId,
  }) async {
    Utils.showToast(Get.context!, EnumLocal.txtReportSending.name.tr);
    Get.back();

    final response = await CreateReportApi.callApi(
      loginUserId: Preference.userId,
      reportReason: reportTypes[selectedReportType.value].title ?? "",
      eventId: eventId,
    );

    if (response != null && response) {
      Utils.showToast(Get.context!, EnumLocal.txtReportSendSuccess.name.tr);
    } else {
      Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
    }
  }

  static Future<void> onGetReports() async {
    Utils.showLog("message>>>>>>>>>> onGetReports");
    if (reportTypes.isEmpty) {
      Utils.showLog("Message>>>>>>>>>> reportTypes.isEmpty");
      isLoading.value = true;
      fetchReportModel = await FetchReportApi.callApi();

      if (fetchReportModel?.data != null) {
        reportTypes.addAll(fetchReportModel?.data ?? []);
      }
      isLoading.value = false;
    }
  }

  static void show({
    required BuildContext context,
    required String eventId,
    required int eventType,
  }) async {
    onGetReports();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColor.transparent,
      builder: (context) => Container(
        height: 500,
        width: Get.width,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: AppColor.bgGreyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 65,
              color: AppColor.grey.withValues(alpha: .1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4,
                        width: 35,
                        decoration: BoxDecoration(
                          color: AppColor.colorTextDarkGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      10.height,
                      Text(
                        EnumLocal.txtReport.name.tr,
                        style: AppFontStyle.styleW700(AppColor.colorWhite, 17),
                      ),
                    ],
                  ).paddingOnly(left: 50),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(right: 20),
                      child: Center(
                        child: Image.asset(
                          width: 22,
                          AppAsset.icClose,
                          color: AppColor.colorWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => isLoading.value
                  ? Expanded(child: ReportBottomSheetShimmerUi())
                  : Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: reportTypes.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => selectedReportType.value = index,
                              child: Container(
                                height: 46,
                                color: AppColor.transparent,
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    Obx(() => ReportRadioButtonUi(isSelected: selectedReportType.value == index)),
                                    12.width,
                                    Text(
                                      reportTypes[index].title ?? "",
                                      style: AppFontStyle.styleW500(AppColor.colorWhite, 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
            Obx(
              () => Visibility(
                visible: !isLoading.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColor.colorWhite,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            EnumLocal.txtCancel.name.tr,
                            style: AppFontStyle.styleW700(AppColor.colorBlack, 16),
                          ),
                        ),
                      ),
                      15.width,
                      GestureDetector(
                        onTap: () async {
                          await onSendReport(
                            eventId: eventId,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [AppColor.primaryColor, AppColor.colorSecondary]),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            EnumLocal.txtReport.name.tr,
                            style: AppFontStyle.styleW700(AppColor.colorWhite, 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportRadioButtonUi extends StatelessWidget {
  const ReportRadioButtonUi({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: AppColor.transparent,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? null : AppColor.transparent,
              gradient: isSelected ? LinearGradient(colors: [AppColor.primaryColor, AppColor.colorSecondary]) : null,
            ),
            child: Container(
              height: 20,
              width: 20,
              // margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? null : AppColor.transparent,
                border: Border.all(color: isSelected ? AppColor.colorWhite : AppColor.grey.withValues(alpha: 0.5), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO => Static Reports Types With Multi Language...

//   static List reportTypes = [
//     "",
//     EnumLocal.txtItIsSpam.name.tr,
//     EnumLocal.txtNudityOrSexualActivity.name.tr,
//     EnumLocal.txtHateSpeechOrSymbols.name.tr,
//     EnumLocal.txtViolenceOrDangerousOrganization.name.tr,
//     EnumLocal.txtFalseInformation.name.tr,
//     EnumLocal.txtBullyingOrHarassment.name.tr,
//     EnumLocal.txtScamOrFraud.name.tr,
//     EnumLocal.txtIntellectualPropertyViolation.name.tr,
//     EnumLocal.txtSuicideOrSelfInjury.name.tr,
//     EnumLocal.txtDrugs.name.tr,
//     EnumLocal.txtEatingDisorders.name.tr,
//     EnumLocal.txtSomethingElse.name.tr,
//     EnumLocal.txtChildAbuse.name.tr,
//     EnumLocal.txtOthers.name.tr,
//   ];

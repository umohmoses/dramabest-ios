import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/report/controller/report_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key});

  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.colorBlack,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            color: AppColor.transparent,
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.colorWhite,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          EnumLocal.report.name.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: GetBuilder<ReportController>(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  EnumLocal.youAreReportingTheBillionaire.name.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                16.height,
                Text(
                  EnumLocal.reasonForReporting.name.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColor.colorIconGrey,
                  ),
                ),
                16.height,
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.reportReason.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final reasonData = controller.reportReason[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          controller.selectReason(index);
                          controller.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    controller.selectedReason == controller.reportReason[index] ? AppColor.colorButtonPink : AppColor.colorIconGrey.withValues(alpha: .2),
                              )),
                          child: Row(
                            children: [
                              Text(
                                "${reasonData.title}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              controller.selectedReason == controller.reportReason[index]
                                  ? Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.colorButtonPink,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColor.colorWhite,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (controller.showTextField)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: controller.othersController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      maxLength: 300,
                      cursorColor: AppColor.primaryColor,
                      decoration: InputDecoration(
                        hintText: EnumLocal.pleaseEnterAReasonForReporting.name.tr,
                        hintStyle: const TextStyle(color: AppColor.colorIconGrey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: AppColor.lightBlack,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                Text(
                  EnumLocal.emailAddress.name.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                16.height,
                TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppColor.primaryColor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: EnumLocal.optionalPleaseEnterSoWeCanContactYou.name.tr,
                    hintStyle: const TextStyle(color: AppColor.colorIconGrey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: AppColor.lightBlack,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                16.height,
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.0),
                    ),
                    backgroundColor: controller.isSubmitEnabled
                        ? AppColor.colorButtonPink // Enabled color
                        : const Color(0xff454446),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: Text(
                    EnumLocal.submit.name.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/report/api/report_api.dart';
import 'package:story_box/ui/report/model/report_reason.dart';

class ReportController extends GetxController {
  List<ReportReason> reportReason = [];
  ReportReason? selectedReason;
  bool showTextField = false;
  TextEditingController othersController = TextEditingController();
  bool isSubmitEnabled = false;

  @override
  void onInit() {
    getReportReasonApi();
    othersController.addListener(() {
      checkSubmitButtonState();
      update();
    });
    super.onInit();
  }

  @override
  void onClose() {
    othersController.dispose();
    super.onClose();
  }

  Future<void> getReportReasonApi() async {
    reportReason = await ReportApi.callApi();

    if (reportReason.isNotEmpty) {
      reportReason.add(
        ReportReason(
          sId: 'others',
          title: 'Others',
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        ),
      );
    }

    update();
  }

  void selectReason(int index) {
    selectedReason = reportReason[index];
    showTextField = selectedReason?.title == 'Others';
    checkSubmitButtonState();
    update();
  }

  void checkSubmitButtonState() {
    if (selectedReason == null) {
      isSubmitEnabled = false;
    } else if (selectedReason?.title == 'Others') {
      isSubmitEnabled = othersController.text.length > 10;
    } else {
      isSubmitEnabled = true;
    }
    update();
  }
}

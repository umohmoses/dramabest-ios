import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:story_box/ads/google_reward_ad.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/deep_link/share_manager/pure_flutter_share_service.dart';
import 'package:story_box/ui/earn_reward_page/api/earn_coin_from_check_in_api.dart';
import 'package:story_box/ui/earn_reward_page/api/earn_coin_from_watch_ad_api.dart';
import 'package:story_box/ui/earn_reward_page/api/get_ad_reward_api.dart';
import 'package:story_box/ui/earn_reward_page/api/get_daily_reward_api.dart';
import 'package:story_box/ui/earn_reward_page/model/earn_coin_from_check_in_model.dart';
import 'package:story_box/ui/earn_reward_page/model/earn_coin_from_watch_ad_model.dart';
import 'package:story_box/ui/earn_reward_page/model/get_ad_reward_model.dart';
import 'package:story_box/ui/earn_reward_page/model/get_daily_reward_model.dart';
import 'package:story_box/ui/earn_reward_page/view/earn_reward_view.dart';
import 'package:story_box/ui/earn_reward_page/widget/earn_reward_ui.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class EarnRewardController extends GetxController {
  // >>>> Ad Reward <<<<<

  RxInt myRewardCoin = 0.obs;

  EarnCoinFromWatchAdModel? earnCoinFromWatchAdModel;
  GetAdRewardModel? getAdRewardModel;
  bool isLoadingAdRewards = false;
  List<Data> adRewards = [];
  Timer? timer;
  int completeAdTask = 0;
  bool isEnableCurrentAdTask = false;
  int nextAdTaskTime = 0;
  LoginUserModel? loginUserModel;

/*  Future<void> init() async {
    log("Earn Reward Controller Called");
    onGetDailyRewards();
    await onGetAdRewards();
    // update(["onGetAdRewards"]);

    if (completeAdTask == 0) {
      isEnableCurrentAdTask = true;
    } else if (Preference.nextAdTaskTime == "0") {
      isEnableCurrentAdTask = true;
    } else {
      onStartTimer();
    }
    loginUserModel = await ProfileApi.callApi();
    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();

      return;
    }
  }

  void onShowAd(int index) {
    final newIndex = index + 1;

    if (newIndex < adRewards.length) {
      Utils.showLog("Next Task Available");

      isEnableCurrentAdTask = false;
      nextAdTaskTime = adRewards[newIndex].adDisplayInterval ?? 0;
      completeAdTask = newIndex;
      Preference.onSetNextAdTaskTime(nextAdTaskTime);

      Utils.showLog("Ad Reward Save Preference => $completeAdTask ${Preference.nextAdTaskTime}");
      update(["onChangeAdReward"]);

      onStartTimer();
    } else {
      completeAdTask = adRewards.length;
      isEnableCurrentAdTask = false;
      Preference.onSetNextAdTaskTime(0);
      update(["onChangeAdReward"]);
      Utils.showLog("Next Not Task Available");
    }
  }*/

  Future<void> init() async {
    log("Earn Reward Controller Called");
    onGetDailyRewards();
    await onGetAdRewards();

    // Restore saved completed ad task count
    int savedCompleteAdTask = Preference.completedAdTasks ?? 0;
    // int savedCompleteAdTask = 0;

    // Only update if saved value is valid
    if (savedCompleteAdTask > 0 && savedCompleteAdTask <= adRewards.length) {
      completeAdTask = savedCompleteAdTask;
      log("Restored completed ad tasks: $completeAdTask");
    }

    if (completeAdTask == 0) {
      isEnableCurrentAdTask = true;
    } else if (Preference.nextAdTaskTimes == 0) {
      isEnableCurrentAdTask = true;
    } else {
      onStartTimer();
    }

    loginUserModel = await ProfileApi.callApi();
    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();
      return;
    }

    update(["onChangeAdReward"]);
  }

  void onShowAd(int index) {
    final newIndex = index + 1;
    completeAdTask = newIndex;

    // Save completed task count in preferences
    Preference.onSetCompletedAdTasks(completeAdTask);

    if (newIndex < adRewards.length) {
      Utils.showLog("Next Task Available");

      isEnableCurrentAdTask = false;
      nextAdTaskTime = adRewards[newIndex].adDisplayInterval ?? 0;
      Preference.onSetNextAdTaskTime(nextAdTaskTime);

      Utils.showLog("Ad Reward Save Preference => $completeAdTask ${Preference.nextAdTaskTimes}");
      update(["onChangeAdReward"]);

      onStartTimer();
    } else {
      completeAdTask = adRewards.length;
      isEnableCurrentAdTask = false;
      Preference.onSetNextAdTaskTime(0);
      Preference.onSetCompletedAdTasks(completeAdTask);
      update(["onChangeAdReward"]);
      Utils.showLog("Next Not Task Available");
    }
  }

  void onStopTimer() {
    timer?.cancel();
    nextAdTaskTime = 0;
    isEnableCurrentAdTask = true;
    Preference.onSetNextAdTaskTime(nextAdTaskTime);
    update(["onChangeAdReward"]);
  }

/*  void onOpenApp() async {
    if (Preference.nextAdTaskTime != "0") {
      DateTime now = DateTime.now();
      DateTime lastDateTime = DateTime.parse(Preference.lastRewardDate);
      Duration difference = now.difference(lastDateTime);
      int seconds = difference.inSeconds;

      log("********* Dif => $seconds ");

      int lastTime = Preference.nextAdTaskTimes ?? 0;

      if (lastTime > seconds) {
        int currentTime = lastTime - seconds;
        Preference.onSetNextAdTaskTime(currentTime);
      } else {
        Preference.onSetNextAdTaskTime(0);
      }

      await 100.milliseconds.delay();

      update(["onChangeAdReward"]);
      onStartTimer();
    } else {
      onStartTimer();
    }
  }

  void onCloseApp() async {
    DateTime now = DateTime.now();
    Preference.onSetLastRewardDate(now.toString());

    timer?.cancel();
    timer = null;
    Preference.onSetNextAdTaskTime(nextAdTaskTime);
  }*/

  void onOpenApp() async {
    if (Preference.nextAdTaskTimes != 0) {
      DateTime now = DateTime.now();
      DateTime lastDateTime = DateTime.parse(Preference.lastRewardDates ?? now.toString());
      Duration difference = now.difference(lastDateTime);
      int seconds = difference.inSeconds;

      log("********* Dif => $seconds ");

      int lastTime = Preference.nextAdTaskTimes ?? 0;

      if (lastTime > seconds) {
        int currentTime = lastTime - seconds;
        Preference.onSetNextAdTaskTime(currentTime);
        nextAdTaskTime = currentTime;
      } else {
        Preference.onSetNextAdTaskTime(0);
        nextAdTaskTime = 0;
        isEnableCurrentAdTask = true;
      }

      await 100.milliseconds.delay();

      update(["onChangeAdReward"]);
      onStartTimer();
    } else {
      isEnableCurrentAdTask = true;
      update(["onChangeAdReward"]);
    }
  }

  void onCloseApp() async {
    DateTime now = DateTime.now();
    Preference.onSetLastRewardDate(now.toString());

    timer?.cancel();
    timer = null;
    Preference.onSetNextAdTaskTime(nextAdTaskTime);
  }

  String convertAdTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //   int minutes = seconds ~/ 60;
  //   int remainingSeconds = seconds % 60;
  //
  //   String formattedMinutes = minutes.toString().padLeft(2, '0');
  //   String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
  //
  //   return '$formattedMinutes:$formattedSeconds';
  // }

  Future<void> onGetAdRewards() async {
    isLoadingAdRewards = true;
    update(["onGetAdRewards"]);
    update(["onChangeAdReward"]);

    /// Ad reward api
    getAdRewardModel = await GetAdRewardApi.callApi(userId: Preference.userId);

    if (getAdRewardModel?.data?.isNotEmpty ?? false) {
      adRewards.clear();
      adRewards.addAll(getAdRewardModel?.data ?? []);
      isLoadingAdRewards = false;
      update(["onGetAdRewards"]);
      update(["onChangeAdReward"]);
    }
  }

  void onClickPlay(int index) async {
    Utils.showLog("Click To Index => $index");

    if (index == completeAdTask && isEnableCurrentAdTask) {
      Utils.showLog("Show Ad Success");

      /// Ad show success
      GoogleRewardAd.showAd(fun: () {
        onShowAd(index);
        onCreateAdReward(adRewards[index].coinEarnedFromAd ?? 0);
      });
    }
    update(['onChangeAdReward']);
  }

  void onStartTimer() {
    Utils.showLog("On Start Timer");
    isEnableCurrentAdTask = false;
    nextAdTaskTime = Preference.nextAdTaskTimes ?? 0;

    if (nextAdTaskTime != 0) {
      timer?.cancel();
      timer = null;
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (time) {
          if (nextAdTaskTime != 0) {
            nextAdTaskTime--;
            Preference.onSetNextAdTaskTime(nextAdTaskTime);
            update(["onChangeAdReward"]);
          } else {
            onStopTimer();
          }
        },
      );
    } else {
      isEnableCurrentAdTask = true;
      update(["onChangeAdReward"]);
    }
  }

  void onCreateAdReward(int coinEarnedFromAd) async {
    /// Watch Ad api
    earnCoinFromWatchAdModel = await EarnCoinFromWatchAdApi.callApi(
      loginUserId: Preference.userId,
      coinEarnedFromAd: coinEarnedFromAd,
    );
    if (earnCoinFromWatchAdModel?.status == false) {
      Utils.showToast(Get.context!, earnCoinFromWatchAdModel?.message ?? "");
    } else if (earnCoinFromWatchAdModel?.data?.coin != null) {
      await Preference.onSetUserCoin(earnCoinFromWatchAdModel?.data?.coin ?? 0);
    }
  }

  // >>>>> >>>>> >>>>> Check In Reward <<<<< <<<<< <<<<<

  GetDailyRewardModel? getDailyRewardModel;
  EarnCoinFromCheckInModel? earnCoinFromCheckInModel;
  bool isLoadingDailyRewards = false;
  List<DailyRewardData> dailyRewards = [];
  bool isTodayCheckIn = false;
  int todayCoin = 0;

  Future<void> onGetDailyRewards() async {
    log("Earn Reward Controller Called");
    isLoadingDailyRewards = true;
    update(["onGetDailyRewards"]);

    /// Daily reward api
    getDailyRewardModel = await GetDailyRewardApi.callApi(loginUserId: Preference.userId);

    if (getDailyRewardModel?.data?.isNotEmpty ?? false) {
      dailyRewards.clear();
      dailyRewards.addAll(getDailyRewardModel?.data ?? []);
      isLoadingDailyRewards = false;
      update(["onGetDailyRewards"]);

      // myRewardCoin.value = getDailyRewardModel?.totalCoins ?? 0;
      await Preference.onSetUserCoin(getDailyRewardModel?.totalCoins ?? 0);

      for (int index = 0; index < dailyRewards.length; index++) {
        if (DateTime.now().day == CustomGetCurrentWeekDate.onGet()[index].day) {
          todayCoin = dailyRewards[index].reward ?? 0;
          isTodayCheckIn = dailyRewards[index].isCheckIn ?? false;
          update(["onGetDailyRewards"]);
        }
      }
    }
  }

  void onCheckIn(BuildContext context) async {
    HapticFeedback.vibrate();
    if (isTodayCheckIn) {
    } else {
      Get.dialog(const LoadingWidget(color: AppColor.colorPrimary), barrierDismissible: false);

      /// Check In api

      earnCoinFromCheckInModel = await EarnCoinFromCheckInApi.callApi(
        loginUserId: Preference.userId,
        dailyRewardCoin: todayCoin,
      );

      Get.back();

      if (earnCoinFromCheckInModel?.status == true) {
        onGetDailyRewards();
        HapticFeedback.heavyImpact();
        showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (BuildContext context) {
            return CheckInDialog(
              todayCoin: todayCoin.toString(),
            );
          },
        );
      }

      // CustomToast.show(earnCoinFromCheckInModel?.message ?? "");
      if (earnCoinFromCheckInModel?.isCheckIn ?? false) {
        isTodayCheckIn = true;
        update(["onGetDailyRewards"]);
      }
    }
  }
}

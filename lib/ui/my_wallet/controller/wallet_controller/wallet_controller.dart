import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/earn_reward_page/api/get_daily_reward_api.dart';
import 'package:story_box/ui/earn_reward_page/model/get_daily_reward_model.dart';
import 'package:story_box/ui/episode_wise_reels_page/controller/episode_wise_reels_controller.dart';
import 'package:story_box/ui/my_wallet/api/episode_auto_unlock_api.dart';
import 'package:story_box/ui/my_wallet/api/episode_unlock_api.dart';
import 'package:story_box/ui/my_wallet/api/reward_coins_history_api.dart';
import 'package:story_box/ui/my_wallet/api/transaction_history_api.dart';
import 'package:story_box/ui/my_wallet/model/EpisodeAutoUnlockModel.dart';
import 'package:story_box/ui/my_wallet/model/episode_unlock_model.dart';
import 'package:story_box/ui/my_wallet/model/reward_coins_history_model.dart';
import 'package:story_box/ui/my_wallet/model/transaction_model.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class WalletController extends GetxController {
  // --- Transaction History ---
  List<CoinPlanHistory> transactionHistoryList = [];
  bool isCoinPlanLoading = true;
  bool isCoinPlanPaginationLoading = false;
  bool hasMoreTransactions = true;
  int transactionStart = 1;
  final int transactionLimit = 20;

  // --- Reward Coins ---
  List<Data> rewardCoins = [];
  bool isRewardCoinsLoading = false;
  bool isRewardCoinsPaginationLoading = false;
  bool hasMoreRewardCoins = true;
  int rewardCoinsStart = 1;
  final int rewardCoinsLimit = 20;

  // --- Episode Unlock ---
  List<EpisodeUnlockModel> episodeUnlock = [];
  bool isEpisodeUnlockLoading = false;
  bool isEpisodeUnlockLoading1 = false;
  int startUnlockCount = 1;
  int limitUnlockCount = 20;

  // --- Episode Auto Unlock ---
  List<EpisodeAutoUnlockModel> episodeAutoUnlock = [];
  bool isEpisodeAutoUnlockLoading = false;
  int startAutoUnlockCount = 1;
  int limitAutoUnlockCount = 20;

  int? coin;
  int? rewardCoin;

  final ScrollController scrollController = ScrollController();
  final ScrollController transactionScrollController = ScrollController();
  final ScrollController rewardCoinsScrollController = ScrollController();
  final controller = Get.put(EpisodeWiseReelsController());

  @override
  void onInit() {
    if (coin == null) {
      final args = Get.arguments;
      if (args != null) {
        coin = args["coin"];
        rewardCoin = args["rewardCoin"];
      }
    }

    scrollController.addListener(_onEpisodeUnlockPagination);
    transactionScrollController.addListener(_onTransactionPagination);
    rewardCoinsScrollController.addListener(_onRewardCoinsPagination);

    onGetTransactionHistory();
    onEpisodeUnlock();
    onEpisodeAutoUnlock();
    onGetRewardCoins();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    transactionScrollController.dispose();
    rewardCoinsScrollController.dispose();
    super.onClose();
  }

  bool isSwitchOn = true;
  List<bool> switchStates = [];

  void onSwitch(int index, bool value, String? movieId) async {
    switchStates[index] = value;
    await controller.setAutoUnlock(value: value, movieWebSeriesId: movieId);
    controller.fetchEpisodeWiseReelsModel?.isAutoUnlockEnabled = value;
    Preference.onIsAutoCheck(value);
    onEpisodeAutoUnlock();
    update(['idSwitchOn', 'episodeAutoUnlock']);
  }

  // ─── Transaction History ────────────────────────────────────────────────────

  Future<void> onGetTransactionHistory() async {
    transactionStart = 1;
    hasMoreTransactions = true;
    transactionHistoryList.clear();
    isCoinPlanLoading = true;
    update(["coinPlanHistoryList", "rewardCoins"]);

    final result = await TransactionHistoryApi.callApi(start: transactionStart, limit: transactionLimit.toString(), userId: Preference.userId);
    transactionHistoryList = result;
    if (result.length < transactionLimit) hasMoreTransactions = false;

    isCoinPlanLoading = false;
    update(["coinPlanHistoryList", "rewardCoins"]);
  }

  void _onTransactionPagination() {
    if (!hasMoreTransactions || isCoinPlanPaginationLoading) return;
    if (transactionScrollController.position.pixels >= transactionScrollController.position.maxScrollExtent - 200) {
      _fetchMoreTransactions();
    }
  }

  Future<void> _fetchMoreTransactions() async {
    isCoinPlanPaginationLoading = true;
    update(["coinPlanHistoryList"]);

    transactionStart++;
    final result = await TransactionHistoryApi.callApi(start: transactionStart, limit: transactionLimit.toString(), userId: Preference.userId);

    if (result.isNotEmpty) {
      transactionHistoryList.addAll(result);
    }
    if (result.length < transactionLimit) hasMoreTransactions = false;

    isCoinPlanPaginationLoading = false;
    update(["coinPlanHistoryList"]);
  }

  // ─── Reward Coins ───────────────────────────────────────────────────────────

  Future<void> onGetRewardCoins() async {
    rewardCoinsStart = 1;
    hasMoreRewardCoins = true;
    rewardCoins.clear();

    getDailyRewardModel = await GetDailyRewardApi.callApi(loginUserId: Preference.userId);
    await Preference.onSetUserCoin(getDailyRewardModel?.totalCoins ?? 0);

    isRewardCoinsLoading = true;
    update(["rewardCoins"]);

    final result = await RewardCoinsHistoryApi.callApi(start: rewardCoinsStart, limit: rewardCoinsLimit.toString(), userId: Preference.userId);

    Utils.showLog("result $result");
    rewardCoins = result;
    if (result.length < rewardCoinsLimit) hasMoreRewardCoins = false;

    isRewardCoinsLoading = false;
    update(["rewardCoins"]);
  }

  void _onRewardCoinsPagination() {
    if (!hasMoreRewardCoins || isRewardCoinsPaginationLoading) return;
    if (rewardCoinsScrollController.position.pixels >= rewardCoinsScrollController.position.maxScrollExtent - 200) {
      _fetchMoreRewardCoins();
    }
  }

  Future<void> _fetchMoreRewardCoins() async {
    isRewardCoinsPaginationLoading = true;
    update(["rewardCoins"]);

    rewardCoinsStart++;
    final result = await RewardCoinsHistoryApi.callApi(start: rewardCoinsStart, limit: rewardCoinsLimit.toString(), userId: Preference.userId);

    if (result.isNotEmpty) {
      rewardCoins.addAll(result);
    }
    if (result.length < rewardCoinsLimit) hasMoreRewardCoins = false;

    isRewardCoinsPaginationLoading = false;
    update(["rewardCoins"]);
  }

  // ─── Episode Unlock ─────────────────────────────────────────────────────────

  Future<void> onEpisodeUnlock() async {
    isEpisodeUnlockLoading = true;
    episodeUnlock = await EpisodeUnlockApi().callApi(
      userId: Preference.userId,
      start: startUnlockCount,
      limit: limitUnlockCount.toString(),
    );
    isEpisodeUnlockLoading = false;
    update(["episodeUnlock"]);
  }

  Future<void> onEpisodeAutoUnlock() async {
    isEpisodeAutoUnlockLoading = true;
    episodeAutoUnlock = await EpisodeAutoUnlockApi().callApi(
      userId: Preference.userId,
      start: startAutoUnlockCount.toString(),
      limit: limitAutoUnlockCount.toString(),
    );
    switchStates = List.generate(episodeAutoUnlock.length, (index) => true);
    isEpisodeAutoUnlockLoading = false;
    update(["episodeAutoUnlock"]);
  }

  void _onEpisodeUnlockPagination() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      _fetchMoreEpisodeUnlock();
    }
  }

  Future<void> _fetchMoreEpisodeUnlock() async {
    isEpisodeUnlockLoading1 = true;
    update(["episodeUnlock"]);

    startUnlockCount++;
    final model = await EpisodeUnlockApi().callApi(
      userId: Preference.userId,
      start: startUnlockCount,
      limit: limitUnlockCount.toString(),
    );
    if (model.isNotEmpty) {
      episodeUnlock.addAll(model);
    }

    isEpisodeUnlockLoading1 = false;
    update(["episodeUnlock"]);
  }

  GetDailyRewardModel? getDailyRewardModel;
}

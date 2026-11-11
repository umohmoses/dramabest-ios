import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/my_wallet/controller/wallet_controller/wallet_controller.dart';
import 'package:story_box/ui/my_wallet/view/episode_auto_unlock_view.dart';
import 'package:story_box/ui/my_wallet/view/episode_unlock_view.dart';
import 'package:story_box/ui/my_wallet/view/reward_coins_history.dart';
import 'package:story_box/ui/my_wallet/view/transaction_history.dart';
import 'package:story_box/ui/refill/view/store_view.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

import '../../../utils/enums.dart';

class MyWalletPage extends StatelessWidget {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: SingleChildScrollView(
        child: GetBuilder<WalletController>(
            id: "episodeUnlock",
            builder: (logic) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.only(right: 20, top: 36, bottom: 36, left: 5),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      AppColor.colorPrimary.withValues(alpha: 0.15),
                      AppColor.colorPrimary.withValues(alpha: 0.1),
                      AppColor.colorBlack.withValues(alpha: 0.1),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => Get.back(),
                        ),
                        const Spacer(),
                        Text(
                          EnumLocal.myWallet.name.tr,
                          style: AppFontStyle.styleW500(AppColor.colorWhite, 20),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(AppAsset.starCoin, width: 44, height: 44),
                      6.width,
                      Obx(
                        () => Text(
                          '${Preference.userCoin}',
                          style: AppFontStyle.styleW800(AppColor.colorWhite, 28),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20, vertical: 6),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "${EnumLocal.coin.name.tr} $coin",
                  //       style: AppFontStyle.styleW600(AppColor.greyColor, 16),
                  //     ),
                  //     const SizedBox(
                  //       height: 12,
                  //       child: VerticalDivider(
                  //         color: AppColor.greyColor,
                  //         thickness: 1.5,
                  //         width: 20,
                  //       ),
                  //     ),
                  //     Text(
                  //       "${EnumLocal.rewardCoin.name.tr} $rewardCoin",
                  //       style: AppFontStyle.styleW600(AppColor.greyColor, 16),
                  //     ),
                  //   ],
                  // ).paddingSymmetric(horizontal: 20),
                  16.height,
                  Container(
                    height: Get.height,
                    decoration: const BoxDecoration(
                      color: AppColor.bgGreyColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => StoreView());
                            },
                            child: Container(
                              height: 40,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColor.colorPrimary,
                                    AppColor.colorSecondary,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  EnumLocal.reFill.name.tr,
                                  style: AppFontStyle.styleW700(AppColor.colorWhite, 18),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            color: AppColor.greyColor.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          WalletViewWidget(
                            onTap: () async {
                              Get.to(() => const RewardCoinsHistory());
                              await logic.onGetRewardCoins();
                            },
                            text: EnumLocal.transactionHistory.name.tr,
                          ),
                          WalletViewWidget(
                            onTap: () async {
                              Get.to(() => const EpisodeUnlockView());
                              await logic.onEpisodeUnlock();
                            },
                            text: EnumLocal.episodesUnlocked.name.tr,
                          ),
                          WalletViewWidget(
                            onTap: () async {
                              Get.to(() => const EpisodeAutoUnlockView());
                              await logic.onEpisodeAutoUnlock();
                            },
                            text: EnumLocal.episodesOnAutoUnlock.name.tr,
                          ),
                          WalletViewWidget(
                            onTap: () async {
                              Get.to(() => const TransactionHistory());
                              await logic.onGetTransactionHistory();
                            },
                            text: EnumLocal.txtBuyCoinsHistory.name.tr,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

class WalletViewWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const WalletViewWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(color: AppColor.transparent),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 28,
            )
          ],
        ).paddingOnly(bottom: 30),
      ),
    );
  }
}

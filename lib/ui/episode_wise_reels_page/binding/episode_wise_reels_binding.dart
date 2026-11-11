import 'package:get/get.dart';
import 'package:story_box/ui/episode_wise_reels_page/controller/episode_wise_reels_controller.dart';

import '../../my_wallet/controller/wallet_controller/wallet_controller.dart';

class EpisodeWiseReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EpisodeWiseReelsController>(() => EpisodeWiseReelsController());
    Get.lazyPut(() => WalletController());
  }
}

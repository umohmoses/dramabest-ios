import 'package:get/get.dart';
import 'package:story_box/ui/my_wallet/controller/wallet_controller/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
  }
}

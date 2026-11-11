import 'package:get/get.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/bottom_bar/binding/bottom_bar_binding.dart';
import 'package:story_box/ui/bottom_bar/view/bottom_bar_view.dart';
import 'package:story_box/ui/category_page/binding/category_binding.dart';
import 'package:story_box/ui/category_page/view/category_view.dart';
import 'package:story_box/ui/earn_reward_page/binding/earn_reward_binding.dart';
import 'package:story_box/ui/earn_reward_page/view/earn_reward_view.dart';
import 'package:story_box/ui/episode_wise_reels_page/binding/episode_wise_reels_binding.dart';
import 'package:story_box/ui/episode_wise_reels_page/view/episode_wise_reels_view.dart';
import 'package:story_box/ui/filter_page/binding/filter_binding.dart';
import 'package:story_box/ui/filter_page/view/filter_view.dart';
import 'package:story_box/ui/home_page/binding/home_binding.dart';
import 'package:story_box/ui/home_page/view/home_view.dart';
import 'package:story_box/ui/language_page/binding/language_binding.dart';
import 'package:story_box/ui/language_page/view/language_view.dart';
import 'package:story_box/ui/login_page/binding/login_page_binding.dart';
import 'package:story_box/ui/login_page/view/login_page_view.dart';
import 'package:story_box/ui/my_list/binding/my_list_binding.dart';
import 'package:story_box/ui/my_list/view/my_list_view.dart';
import 'package:story_box/ui/my_wallet/binding/wallet_binding.dart';
import 'package:story_box/ui/my_wallet/view/my_wallet_page.dart';
import 'package:story_box/ui/profile_page/binding/profile_binding.dart';
import 'package:story_box/ui/profile_page/view/profile_view.dart';
import 'package:story_box/ui/search_page/binding/search_binding.dart';
import 'package:story_box/ui/search_page/view/search_view.dart';
import 'package:story_box/ui/setting_view_page/binding/setting_binding.dart';
import 'package:story_box/ui/setting_view_page/view/setting_view.dart';
import 'package:story_box/ui/splash_screen/binding/splash_binding.dart';
import 'package:story_box/ui/splash_screen/view/splash_view.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: AppRoutes.bottomBarPage,
      page: () => const BottomBarView(),
      binding: BottomBarBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeViewPage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.episodeWiseReels,
      page: () => const EpisodeWiseReelsView(),
      binding: EpisodeWiseReelsBinding(),
    ),
    GetPage(
      name: AppRoutes.myList,
      page: () => const MyListViewPage(
        isShowArrow: true,
      ),
      binding: MyListBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileViewPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => SettingViewPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => SearchViewPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.rewards,
      page: () => const EranRewardView(),
      binding: EranRewardBinding(),
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const MyWalletPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: AppRoutes.category,
      page: () => const CategoryBuilderView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.filter,
      page: () => const FilterView(),
      binding: FilterBinding(),
    ),
  ];
}

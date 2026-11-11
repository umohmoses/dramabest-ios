import 'package:story_box/utils/session_token.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/controller/wallet_controller/wallet_controller.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class UnlockEpisodesAutoApi {
  static Future<void> callApi({
    required String loginUserId,
    required bool type,
    required String movieWebSeriesId,
    String? shortVideoId,
  }) async {
    final queryParameters = shortVideoId == null
        ? {
            Params.userId: loginUserId,
            Params.movieWebseriesId: movieWebSeriesId,
            'type': type.toString(),
          }
        : {Params.userId: loginUserId, Params.movieWebseriesId: movieWebSeriesId, 'type': type.toString(), 'shortVideoId': shortVideoId};

    Utils.showLog(" Auto unlock Api queryParameters => $queryParameters");

    String queryString = Uri(queryParameters: queryParameters).query;

    final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.unlockEpisodesAutomatically + queryString);
    // final url = Uri.parse("http://192.168.1.39:6054/" + ApiConstant.unlockEpisodesAutomatically + queryString);
    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json', ...await SessionToken.headers()};

    Utils.showLog("unlock Api Url => $url");

    try {
      var response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        final controller = Get.find<WalletController>();
        controller.onEpisodeAutoUnlock();
        Utils.showLog("Auto unlock Api Response => ${response.body}");
      } else {
        Utils.showLog(
          "Auto unlock Api StateCode Error => ${response.statusCode} body => ${response.body} ",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Auto unlock Api Error => $error",
      );
    }
    return;
  }
}

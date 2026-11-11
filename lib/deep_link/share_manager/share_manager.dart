import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_box/deep_link/services/deep_link_services.dart';
import 'package:story_box/utils/color.dart';

import 'drama_share.dart';
import 'pure_flutter_share_service.dart';
import 'share_card_generator.dart';

class ShareManager {
  static Future<void> shareContent({
    required String id,
    required String title,
    String? imageUrl,
    String? thumbnailUrl,
    ShareType shareType = ShareType.richText,
    String? pageRoutes,
    String? movieName,
    int? episodeNumber,
    int? totalVideos,
    String? contentType,
    String? videoId,
    bool legacy = false,
    Function()? onComplete,
  }) async {
    // Share menu: poster card / clip of this episode / copy link, all with the sharer's short link.
    if (!legacy && id.isNotEmpty) {
      await DramaShare.open(
        movieSeriesId: id,
        videoId: videoId,
        episodeIndex: episodeNumber ?? 0,
        title: movieName?.isNotEmpty == true ? movieName! : title,
        posterUrl: thumbnailUrl ?? imageUrl,
        totalVideos: totalVideos ?? 0,
      );
      onComplete?.call();
      return;
    }
    final deepLink = DeepLinkServices.onGenerateLink(
      id: id,
      pageRoutes: pageRoutes,
      episodeNumber: episodeNumber,
      movieName: movieName,
      totalVideos: totalVideos,
    );

    debugPrint("✅ DEEP LINK GENERATE SUCCESS => $deepLink");

    switch (shareType) {
      case ShareType.richText:
        await _shareRichText(title: title, deepLink: deepLink, onComplete: onComplete);
        break;

      case ShareType.withImage:
        await PureFlutterShareService.shareRichContent(title: title, imageUrl: imageUrl, deepLink: deepLink, onComplete: onComplete);
        break;

      case ShareType.asPreviewCard:
        await ShareCardGenerator.shareAsPreviewCard(
          title: title,
          websiteName: "YourApp",
          imageUrl: thumbnailUrl ?? imageUrl,
          deepLink: deepLink,
          brandColor: AppColor.colorPrimary,
          onComplete: onComplete,
        );
        break;
    }
  }

  static Future<void> _shareRichText({required String title, String? deepLink, Function()? onComplete}) async {
    final shareText = '''
📱 $title


${deepLink != null ? '👉 $deepLink' : ''}
    '''
        .trim();

    await Share.share(shareText, subject: title).whenComplete(() => onComplete?.call());
  }
}

enum ShareType { richText, withImage, asPreviewCard }

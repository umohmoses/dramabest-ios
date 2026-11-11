import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_box/utils/utils.dart';

import '../../utils/color.dart';

class PureFlutterShareService {
  /// Share with image + formatted text (appears as image + caption)
  static Future<void> shareRichContent({required String title, String? imageUrl, String? deepLink, Function()? onComplete}) async {
    try {
      Get.dialog(const LoadingWidget(color: AppColor.colorPrimary), barrierDismissible: false);

      // Format the text nicely
      final shareText = '''
${deepLink != null ? '🔗 $deepLink' : ''}
      '''
          .trim();

      // If there's an image, download and share with it
      if (imageUrl != null) {
        final imageFile = await _downloadImage(imageUrl);

        if (imageFile != null) {
          // This will show image with your text as caption
          await Share.shareXFiles([imageFile], text: shareText, subject: title).whenComplete(() => onComplete?.call());
        } else {
          // Fallback to text only
          await Share.share(shareText, subject: title).whenComplete(() => onComplete?.call());
        }
      } else {
        // Text only share
        await Share.share(shareText, subject: title).whenComplete(() => onComplete?.call());
      }

      Get.back();
    } catch (e) {
      Get.back();
      Utils.showLog("Share failed: $e");
    }
  }

  static Future<XFile?> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'share_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${tempDir.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);
        return XFile(file.path);
      }
      return null;
    } catch (e) {
      Utils.showLog("Error downloading image: $e");
      return null;
    }
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: color ?? AppColor.colorPrimary,
        size: size ?? 60,
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_box/deep_link/services/deep_link_services.dart';
import 'package:story_box/growth/growth_config.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

/// "SHARE THIS DRAMA": poster card, a playable clip of this episode, or just the link.
/// Every share carries the sharer's own short link (dramabest.com/r/CODE) for this movie + episode,
/// which opens the app on that episode or Google Play with the sharer's invite code.
/// Files go through the system share sheet (share_plus: FileProvider content:// URI with read permission),
/// so WhatsApp (chats + Status), Facebook, TikTok, Telegram, Instagram ... all receive the real file.
class DramaShare {
  static const _brand = Color(0xFFed3a57);
  static const _brand2 = Color(0xFFff7a59);
  static const _surface = Color(0xff1c1816);

  static String _base() => '${ApiConstant.getBaseURL()}api/client/share';
  static String _uid() => (GuestGate.isGuest || Preference.userId.isEmpty) ? '' : Preference.userId;
  static void _toast(String m) {
    final c = Get.context;
    if (c != null) Utils.showToast(c, m);
  }

  /// Opens the share menu. [videoId] = the episode being watched (shortVideo id), [episodeIndex] = its play index.
  static Future<void> open({
    required String movieSeriesId,
    String? videoId,
    required int episodeIndex,
    required String title,
    String? posterUrl,
    int totalVideos = 0,
  }) async {
    if (movieSeriesId.isEmpty) return;
    final canVideo = GrowthConfig.clipsEnabled && (videoId ?? '').isNotEmpty;
    await Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: const BoxDecoration(color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 14),
              const Text('SHARE THIS DRAMA', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text(title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              const SizedBox(height: 16),
              _option('🖼️', 'Share Poster', 'Poster, story and your link', () {
                Get.back();
                sharePoster(movieSeriesId: movieSeriesId, episodeIndex: episodeIndex, title: title, posterUrl: posterUrl, totalVideos: totalVideos);
              }),
              if (canVideo)
                _option('🎬', 'Share Episode Video', 'A playable clip of this episode', () {
                  Get.back();
                  shareVideo(videoId: videoId!, episodeIndex: episodeIndex, title: title);
                }),
              _option('🔗', 'Copy Referral Link', 'Paste it anywhere: bio, caption, chat', () {
                Get.back();
                copyLink(movieSeriesId: movieSeriesId, episodeIndex: episodeIndex);
              }),
              const SizedBox(height: 6),
              const Text(
                'Then pick WhatsApp, Facebook, TikTok or any app. Your link is copied too: '
                'TikTok, Facebook and WhatsApp Status may drop the text, so paste it in the caption.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 11.5, height: 1.35),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Widget _option(String emoji, String label, String hint, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ]),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              ]),
            ),
          ),
        ),
      );

  /* ------------------------------ server ------------------------------ */

  static Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body, {Duration timeout = const Duration(seconds: 15)}) async {
    final res = await http
        .post(Uri.parse('${_base()}/$path'), headers: {'key': ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'}, body: jsonEncode(body))
        .timeout(timeout);
    final j = jsonDecode(res.body);
    if (j is Map && j['status'] == true && j['data'] is Map) return Map<String, dynamic>.from(j['data']);
    throw _ShareError(j is Map && j['message'] is String ? j['message'] : 'Sharing is not available right now.');
  }

  static Future<Map<String, dynamic>> _link(String movieSeriesId, int episodeIndex) =>
      _post('link', {'userId': _uid(), 'movieSeriesId': movieSeriesId, 'episodeNumber': episodeIndex});

  /* ------------------------------ actions ------------------------------ */

  static Future<void> copyLink({required String movieSeriesId, required int episodeIndex}) async {
    _loading('Creating your link…');
    try {
      final d = await _link(movieSeriesId, episodeIndex);
      await Clipboard.setData(ClipboardData(text: '${d['url']}'));
      _close();
      _toast('Link copied: ${d['url']}');
    } catch (e) {
      _close();
      _toast(e is _ShareError ? e.message : 'No connection. Please try again.');
    }
  }

  static Future<void> sharePoster({required String movieSeriesId, required int episodeIndex, required String title, String? posterUrl, int totalVideos = 0}) async {
    _loading('Preparing poster…');
    Map<String, dynamic> d;
    try {
      d = await _link(movieSeriesId, episodeIndex);
    } catch (e) {
      // Server unreachable: the old long link still opens the app, so the share is not lost.
      d = {
        'url': DeepLinkServices.onGenerateLink(id: movieSeriesId, pageRoutes: DeepLinkServices.episodeKey, episodeNumber: episodeIndex, totalVideos: totalVideos),
        'title': title,
        'image': posterUrl,
        'totalVideos': totalVideos,
      };
      d['shareText'] = '🎬 *${title.toUpperCase()}* 🔥\n\n👇▶️ *TAP TO START WATCHING ON DRAMA BEST*\n${d['url']}';
    }
    try {
      final text = '${d['shareText']}';
      await Clipboard.setData(ClipboardData(text: '${d['url']}'));
      final image = '${d['image'] ?? posterUrl ?? ''}';
      XFile? file;
      if (image.isNotEmpty) {
        final bytes = await _download(image);
        if (bytes != null) {
          final total = (d['totalVideos'] is num) ? (d['totalVideos'] as num).toInt() : totalVideos;
          final card = await _posterCard(bytes, '${d['title'] ?? title}', total > 1 ? 'EPISODE ${episodeIndex + 1}' : null);
          file = await _temp(card ?? bytes, card != null ? 'png' : 'jpg', 'dramabest_poster');
        }
      }
      _close();
      final result = file != null
          ? await SharePlus.instance.share(ShareParams(files: [file], text: text, subject: '${d['title'] ?? title}'))
          : await SharePlus.instance.share(ShareParams(text: text, subject: '${d['title'] ?? title}'));
      Utils.showLog('Poster share => ${result.status}');
    } catch (e) {
      _close();
      Utils.showLog('Poster share failed => $e');
      _toast('Could not open sharing. Please try again.');
    }
  }

  static Future<void> shareVideo({required String videoId, required int episodeIndex, required String title}) async {
    final progress = 0.0.obs;
    final stage = 'Preparing the episode clip…'.obs;
    var cancelled = false;
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: SizedBox(
                width: 260,
                child: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('🎬', style: TextStyle(fontSize: 34)),
                      const SizedBox(height: 10),
                      Text(stage.value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(minHeight: 6, value: progress.value > 0 ? progress.value : null, color: _brand, backgroundColor: Colors.white12),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          cancelled = true;
                          Get.back();
                        },
                        child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
                      ),
                    ])),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
    try {
      final d = await _post('clip', {'userId': _uid(), 'shortVideoId': videoId, 'episodeNumber': episodeIndex}, timeout: const Duration(seconds: 180));
      if (cancelled) return;
      final clip = d['clip'] is Map ? Map<String, dynamic>.from(d['clip']) : const <String, dynamic>{};
      stage.value = 'Downloading video…';
      final file = await _downloadToFile('${clip['url']}', 'dramabest_${(d['title'] ?? 'episode').toString().replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}_ep${episodeIndex + 1}.mp4',
          (p) => progress.value = p, () => cancelled);
      if (cancelled) return;
      if (file == null) throw _ShareError('The video could not be downloaded. Please check your connection.');
      await Clipboard.setData(ClipboardData(text: '${d['url']}'));
      if (Get.isDialogOpen == true) Get.back();
      final result = await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'video/mp4')], text: '${d['shareText']}', subject: '${d['title'] ?? title}'));
      Utils.showLog('Video share => ${result.status}');
      if (result.status == ShareResultStatus.success) _toast('Link copied. If the app dropped the caption, paste it.');
    } catch (e) {
      if (!cancelled && Get.isDialogOpen == true) Get.back();
      if (cancelled) return;
      Utils.showLog('Video share failed => $e');
      _toast(e is _ShareError
          ? e.message
          : e is TimeoutException
              ? 'Preparing the video took too long. Please try again.'
              : 'Could not share the video. Please check your connection and try again.');
    }
  }

  /// App opened from dramabest.com/r/CODE after a fresh install (Play referrer `s=CODE`): go to that episode.
  static Future<void> openFromCode(String code) async {
    try {
      final res = await http.get(Uri.parse('${_base()}/resolve/${Uri.encodeComponent(code)}'), headers: {'key': ApiConstant.SECRET_KEY}).timeout(const Duration(seconds: 15));
      final j = jsonDecode(res.body);
      if (j is! Map || j['status'] != true || j['data'] is! Map) return;
      final d = j['data'];
      DeepLinkServices.isNavigationComplete = false;
      DeepLinkServices.eventId = '${d['movieSeriesId']}';
      DeepLinkServices.eventType = DeepLinkServices.episodeKey;
      DeepLinkServices.episodeNumber = (d['episodeNumber'] as num?)?.toInt() ?? 0;
      DeepLinkServices.totalVideos = (d['totalVideos'] as num?)?.toInt() ?? 0;
      if (Get.currentRoute == AppRoutes.bottomBarPage) DeepLinkServices.onChangeRoutes(isBottomBarRoutes: false); // else: the home screen does it on start
    } catch (e) {
      Utils.showLog('Share code resolve failed => $e');
    }
  }

  /* ------------------------------ helpers ------------------------------ */

  static void _loading(String text) => Get.dialog(
        Center(
          child: Material(
            color: _surface,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: _brand)),
                const SizedBox(width: 14),
                Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
        barrierDismissible: false,
      );

  static void _close() {
    if (Get.isDialogOpen == true) Get.back();
  }

  static Future<Uint8List?> _download(String url) async {
    try {
      final r = await http.get(Uri.parse(url.replaceAll(' ', '%20'))).timeout(const Duration(seconds: 20));
      return r.statusCode == 200 && r.bodyBytes.isNotEmpty ? r.bodyBytes : null;
    } catch (_) {
      return null;
    }
  }

  static Future<File?> _downloadToFile(String url, String name, void Function(double) onProgress, bool Function() cancelled) async {
    final client = http.Client();
    try {
      final res = await client.send(http.Request('GET', Uri.parse(url))).timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) return null;
      final dir = Directory('${(await getTemporaryDirectory()).path}/share');
      if (!await dir.exists()) await dir.create(recursive: true);
      for (final old in dir.listSync()) {
        try {
          if (old is File && DateTime.now().difference(old.statSync().modified).inHours > 6) old.deleteSync(); // keep the cache small
        } catch (_) {}
      }
      final file = File('${dir.path}/$name');
      final sink = file.openWrite();
      final total = res.contentLength ?? 0;
      var got = 0;
      await for (final chunk in res.stream.timeout(const Duration(seconds: 30))) {
        if (cancelled()) {
          await sink.close();
          return null;
        }
        sink.add(chunk);
        got += chunk.length;
        if (total > 0) onProgress(got / total);
      }
      await sink.close();
      return got > 0 ? file : null;
    } catch (e) {
      Utils.showLog('Clip download failed => $e');
      return null;
    } finally {
      client.close();
    }
  }

  static Future<XFile> _temp(Uint8List bytes, String ext, String name) async {
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/${name}_${DateTime.now().millisecondsSinceEpoch}.$ext');
    await f.writeAsBytes(bytes);
    return XFile(f.path, mimeType: ext == 'png' ? 'image/png' : 'image/jpeg');
  }

  /// 1080x1350 card: the poster, a play button, the title and a "watch free" bar. Null if the image cannot be decoded.
  static Future<Uint8List?> _posterCard(Uint8List posterBytes, String title, String? chip) async {
    try {
      const w = 1080.0, h = 1350.0;
      final codec = await ui.instantiateImageCodec(posterBytes);
      final img = (await codec.getNextFrame()).image;
      final rec = ui.PictureRecorder();
      final c = Canvas(rec, const Rect.fromLTWH(0, 0, w, h));
      c.drawRect(const Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xff0d0b0a));

      // poster, cover-fit
      final iw = img.width.toDouble(), ih = img.height.toDouble();
      final scale = (w / iw) > (h / ih) ? w / iw : h / ih;
      final sw = w / scale, sh = h / scale;
      c.drawImageRect(img, Rect.fromLTWH((iw - sw) / 2, (ih - sh) / 2, sw, sh), const Rect.fromLTWH(0, 0, w, h), Paint()..filterQuality = FilterQuality.high);

      // shading for legible text
      c.drawRect(const Rect.fromLTWH(0, 0, w, 220),
          Paint()..shader = ui.Gradient.linear(Offset.zero, const Offset(0, 220), [Colors.black.withValues(alpha: 0.65), Colors.transparent]));
      c.drawRect(Rect.fromLTWH(0, h * 0.45, w, h * 0.55),
          Paint()..shader = ui.Gradient.linear(Offset(0, h * 0.45), const Offset(0, h), [Colors.transparent, Colors.black.withValues(alpha: 0.94)]));

      // brand
      _text(c, 'DRAMA', 60, 52, 44, Colors.white, FontWeight.w900, spacing: 6);
      _text(c, 'BEST', 60 + _measure('DRAMA', 44, FontWeight.w900, 6), 52, 44, _brand, FontWeight.w900, spacing: 6);

      // play button
      const center = Offset(w / 2, h * 0.42);
      c.drawCircle(center, 118, Paint()..color = _brand.withValues(alpha: 0.28));
      c.drawCircle(center, 92, Paint()..color = _brand.withValues(alpha: 0.95));
      final tri = Path()
        ..moveTo(center.dx - 26, center.dy - 40)
        ..lineTo(center.dx + 44, center.dy)
        ..lineTo(center.dx - 26, center.dy + 40)
        ..close();
      c.drawPath(tri, Paint()..color = Colors.white);

      // chip + title
      var y = h - 380;
      if (chip != null) {
        final cw = _measure(chip, 30, FontWeight.w800, 2) + 44;
        c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(60, y, cw, 54), const Radius.circular(27)), Paint()..color = Colors.white.withValues(alpha: 0.18));
        _text(c, chip, 82, y + 10, 30, Colors.white, FontWeight.w800, spacing: 2);
        y += 74;
      }
      final pb = ui.ParagraphBuilder(ui.ParagraphStyle(maxLines: 2, ellipsis: '…', fontSize: 66, fontWeight: FontWeight.w900, height: 1.1))
        ..pushStyle(ui.TextStyle(color: Colors.white, fontSize: 66, fontWeight: FontWeight.w900, shadows: const [Shadow(blurRadius: 12, color: Colors.black54)]))
        ..addText(title);
      final para = pb.build()..layout(const ui.ParagraphConstraints(width: w - 120));
      c.drawParagraph(para, Offset(60, y));

      // call to action bar
      final bar = RRect.fromRectAndRadius(const Rect.fromLTWH(60, h - 150, w - 120, 100), const Radius.circular(50));
      c.drawRRect(bar, Paint()..shader = ui.Gradient.linear(const Offset(60, 0), const Offset(w - 60, 0), [_brand, _brand2]));
      const cta = '▶  WATCH FREE ON DRAMABEST';
      final ctaW = _measure(cta, 36, FontWeight.w900, 1.5);
      _text(c, cta, (w - ctaW) / 2, h - 150 + 29, 36, Colors.white, FontWeight.w900, spacing: 1.5);

      final out = await rec.endRecording().toImage(w.toInt(), h.toInt());
      final png = await out.toByteData(format: ui.ImageByteFormat.png);
      return png?.buffer.asUint8List();
    } catch (e) {
      Utils.showLog('Poster card failed => $e');
      return null;
    }
  }

  static ui.Paragraph _para(String t, double size, FontWeight weight, Color color, double spacing) {
    final b = ui.ParagraphBuilder(ui.ParagraphStyle(maxLines: 1))
      ..pushStyle(ui.TextStyle(color: color, fontSize: size, fontWeight: weight, letterSpacing: spacing))
      ..addText(t);
    return b.build()..layout(const ui.ParagraphConstraints(width: 2000));
  }

  static double _measure(String t, double size, FontWeight weight, double spacing) => _para(t, size, weight, Colors.white, spacing).maxIntrinsicWidth;

  static void _text(Canvas c, String t, double x, double y, double size, Color color, FontWeight weight, {double spacing = 0}) =>
      c.drawParagraph(_para(t, size, weight, color, spacing), Offset(x, y));
}

class _ShareError implements Exception {
  final String message;
  _ShareError(this.message);
  @override
  String toString() => message;
}

library;

import 'easy_deep_links.dart';
export 'easy_deep_link_config.dart';
export 'easy_deep_link_manager.dart';

class EasyDeepLinks {
  EasyDeepLinks._();

  static EasyDeepLinkManager get _manager => EasyDeepLinkManager.instance;

  static Future<void> initialize(EasyDeepLinkConfig config) async {
    await _manager.initialize(config);
  }

  static Stream<DeepLinkInfo> get linkStream => _manager.linkStream;

  static String generateLink(String path, [Map<String, String>? params]) {
    return _manager.generateLink(path, params);
  }

  static void dispose() {
    _manager.dispose();
  }
}

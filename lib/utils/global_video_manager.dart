import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:story_box/utils/utils.dart';

/// Global Manager to handle video playback lifecycle across the app.
/// This ensures all videos are stopped and disposed when the app is backgrounded or detached.
class GlobalVideoManager extends GetxController with WidgetsBindingObserver {
  // List of cleanup callbacks from active video controllers
  final List<VoidCallback> _cleanupCallbacks = [];

  // ✅ Track state to determine fresh launch behavior
  DateTime? _lastBackgroundTime;
  bool _wasDetached = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    Utils.showLog("🎬 GlobalVideoManager initialized");
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils.showLog("📱 AppLifecycleState changed to: $state");

    if (state == AppLifecycleState.paused) {
      Utils.showLog("🛑 App paused - Triggering global video cleanup and tracking time");
      _lastBackgroundTime = DateTime.now();
      disposeAllVideos();
    } else if (state == AppLifecycleState.detached) {
      Utils.showLog("🛑 App detached - Triggering global video cleanup and marking detached");
      _wasDetached = true;
      disposeAllVideos();
      Get.deleteAll(force: true); // Force clear GetX controllers
    } else if (state == AppLifecycleState.resumed) {
      bool shouldReset = _wasDetached;

      if (_lastBackgroundTime != null) {
        final backgroundDuration = DateTime.now().difference(_lastBackgroundTime!);
        // If backgrounded for more than 5 minutes, consider it a fresh launch
        if (backgroundDuration.inMinutes >= 5) {
          shouldReset = true;
        }
      }

      if (shouldReset) {
        Utils.showLog("🔄 App resumed after being killed or long background. Forced reset to Splash.");
        _wasDetached = false;
        _lastBackgroundTime = null;

        // Ensure everything is clean
        disposeAllVideos();

        // 🚀 Reset navigation stack
        // Using Future.microtask to ensure it happens after the current frame
        Future.microtask(() {
          Get.offAllNamed('/'); // Using the splash route explicitly
        });
      } else {
        // Just a normal resume from a short background
        _lastBackgroundTime = null;
      }
    }
  }

  /// Register a cleanup callback (e.g., from a GetX controller or Widget state)
  void registerCleanup(VoidCallback callback) {
    if (!_cleanupCallbacks.contains(callback)) {
      _cleanupCallbacks.add(callback);
    }
  }

  /// Unregister a cleanup callback
  void unregisterCleanup(VoidCallback callback) {
    _cleanupCallbacks.remove(callback);
  }

  /// Trigger all registered cleanup callbacks
  void disposeAllVideos() {
    Utils.showLog("🧹 Cleaning up ${_cleanupCallbacks.length} active video sessions");
    for (var cleanup in _cleanupCallbacks) {
      try {
        cleanup();
      } catch (e) {
        Utils.showLog("Error during video cleanup: $e");
      }
    }
    // We don't clear the list here because some controllers might still be active
    // and want to remain registered for future lifecycle events if they are permanent.
    // However, for "detached" state, the app is dying anyway.
  }
}

// // ============================================================================
// // FILE 1: memory_manager.dart
// // ============================================================================
//
// import 'dart:async';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:collection';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:story_box/ui/reels_page/model/fetch_movie_series_trailer_model.dart';
//
// class MemoryManager {
//   static bool _inited = false;
//   static bool _isLowRam = false;
//   static bool _isUnisoc = false;
//
//   static Future<void> init() async {
//     if (_inited) return;
//     final di = DeviceInfoPlugin();
//
//     if (Platform.isAndroid) {
//       final info = await di.androidInfo;
//       final brand = (info.brand ?? '').toLowerCase();
//       final mfg = (info.manufacturer ?? '').toLowerCase();
//       final hw = (info.hardware ?? '').toLowerCase();
//       final sdk = info.version.sdkInt ?? 0;
//
//       _isUnisoc = [brand, mfg, hw].any((s) => s.contains('unisoc') || s.contains('spreadtrum') || s.contains('spd'));
//
//       _isLowRam = _isUnisoc || sdk <= 26;
//     } else if (Platform.isIOS) {
//       _isLowRam = false;
//     }
//
//     _inited = true;
//     Utils.showLog("📱 Memory Manager: UNISOC=$_isUnisoc, LowRAM=$_isLowRam");
//   }
//
//   static int cacheSize({required bool fastScrolling}) {
//     if (!_inited) return 3;
//     if (_isUnisoc) return fastScrolling ? 1 : 2;
//     if (_isLowRam) return fastScrolling ? 2 : 3;
//     return fastScrolling ? 3 : 5;
//   }
//
//   static int preloadBuffer({required bool fastScrolling}) {
//     if (!_inited) return 1;
//     if (_isUnisoc) return 0;
//     if (_isLowRam) return fastScrolling ? 0 : 1;
//     return fastScrolling ? 1 : 2;
//   }
//
//   static bool get isUnisoc => _isUnisoc;
//   static bool get isLowRam => _isLowRam;
// }
//
// // ============================================================================
// // FILE 2: video_cache_entity.dart
// // ============================================================================
//
// class VideoCacheEntity {
//   final String videoId;
//   final VideoPlayerController controller;
//   final DateTime lastAccessed;
//   final bool isInitialized;
//
//   VideoCacheEntity({
//     required this.videoId,
//     required this.controller,
//     required this.lastAccessed,
//     required this.isInitialized,
//   });
//
//   VideoCacheEntity copyWith({
//     DateTime? lastAccessed,
//     bool? isInitialized,
//   }) {
//     return VideoCacheEntity(
//       videoId: videoId,
//       controller: controller,
//       lastAccessed: lastAccessed ?? this.lastAccessed,
//       isInitialized: isInitialized ?? this.isInitialized,
//     );
//   }
// }
//
// // ============================================================================
// // FILE 3: video_cache_service.dart
// // ============================================================================
//
// // Replace the existing VideoCacheService with this improved version
//
// class VideoCacheService extends GetxService {
//   final LinkedHashMap<String, VideoCacheEntity> _cache = LinkedHashMap();
//   final RxMap<String, double> preloadProgress = <String, double>{}.obs;
//   final Map<String, Future<void>> _initFutures = {};
//
//   bool _isFastScrolling = false;
//
//   @override
//   void onClose() {
//     disposeAll();
//     super.onClose();
//   }
//
//   void setFastScrolling(bool isFastScrolling) {
//     _isFastScrolling = isFastScrolling;
//     _maintainCacheSize();
//   }
//
//   Future<VideoPlayerController> getController(TrailerData reel) async {
//     if (_cache.containsKey(reel.id)) {
//       final entity = _cache[reel.id]!;
//
//       if (entity.controller.value.hasError) {
//         _cache.remove(reel.id);
//         return _createNewController(reel);
//       }
//
//       _cache[reel.id ?? ""] = entity.copyWith(lastAccessed: DateTime.now());
//
//       if (!entity.isInitialized || !(entity.controller.value.isInitialized)) {
//         if (_initFutures[reel.id] != null) {
//           try {
//             await _initFutures[reel.id];
//           } finally {
//             _initFutures.remove(reel.id);
//           }
//         } else {
//           final future = entity.controller.initialize();
//           _initFutures[reel.id ?? ""] = future;
//           try {
//             await future;
//           } catch (e) {
//             _cache.remove(reel.id);
//             rethrow;
//           } finally {
//             _initFutures.remove(reel.id);
//             if (_cache.containsKey(reel.id)) {
//               _cache[reel.id ?? ""] = entity.copyWith(
//                 isInitialized: true,
//                 lastAccessed: DateTime.now(),
//               );
//             }
//           }
//         }
//       }
//       return entity.controller;
//     }
//
//     log("Creating controller for: ${reel.videos?.videoUrl}");
//     final controller = VideoPlayerController.networkUrl(
//       Uri.parse(reel.videos?.videoUrl ?? ""),
//       videoPlayerOptions: VideoPlayerOptions(
//         mixWithOthers: false,
//         allowBackgroundPlayback: false,
//       ),
//     );
//
//     final entity = VideoCacheEntity(
//       videoId: reel.id ?? "",
//       controller: controller,
//       lastAccessed: DateTime.now(),
//       isInitialized: false,
//     );
//
//     _cache[reel.id ?? ""] = entity;
//     _maintainCacheSize();
//
//     final initFuture = controller.initialize();
//     _initFutures[reel.id ?? ""] = initFuture;
//
//     try {
//       await initFuture;
//       _cache[reel.id ?? ""] = entity.copyWith(
//         isInitialized: true,
//         lastAccessed: DateTime.now(),
//       );
//     } catch (e) {
//       _cache.remove(reel.id);
//       rethrow;
//     } finally {
//       _initFutures.remove(reel.id);
//     }
//
//     return controller;
//   }
//
//   void preloadVideos(
//     List<TrailerData> reels,
//     int currentIndex, {
//     bool isFastScrolling = false,
//   }) {
//     final preloadRange = _getPreloadRange(
//       currentIndex,
//       reels.length,
//       isFastScrolling,
//     );
//
//     final priorityVideos = [
//       currentIndex - 2,
//       currentIndex,
//       currentIndex + 2,
//     ].where((i) => i >= 0 && i < reels.length);
//
//     for (int i in priorityVideos) {
//       if (!_cache.containsKey(reels[i].id)) {
//         _preloadVideoWithPriority(reels[i], true);
//       }
//     }
//
//     for (int i in preloadRange) {
//       if (i < reels.length && !_cache.containsKey(reels[i].id) && !priorityVideos.contains(i)) {
//         _preloadVideoWithPriority(reels[i], false);
//       }
//     }
//
//     _cleanupDistantVideos(reels, currentIndex, isFastScrolling);
//   }
//
//   List<int> _getPreloadRange(
//     int currentIndex,
//     int totalCount,
//     bool isFastScrolling,
//   ) {
//     final buffer = MemoryManager.preloadBuffer(fastScrolling: isFastScrolling);
//     final preloadStart = (currentIndex - buffer).clamp(0, totalCount - 1);
//     final preloadEnd = (currentIndex + buffer).clamp(0, totalCount - 1);
//     return List.generate(
//       preloadEnd - preloadStart + 1,
//       (i) => preloadStart + i,
//     );
//   }
//
//   void _preloadVideoWithPriority(TrailerData reel, bool isPriority) async {
//     try {
//       preloadProgress[reel.id ?? ""] = 0.0;
//
//       if (_cache.containsKey(reel.id)) {
//         await getController(reel);
//         preloadProgress[reel.id ?? ""] = 1.0;
//         return;
//       }
//
//       log("Preloading: ${reel.videos?.videoUrl}");
//       final controller = VideoPlayerController.networkUrl(
//         Uri.parse(reel.videos?.videoUrl ?? ''),
//         videoPlayerOptions: VideoPlayerOptions(
//           mixWithOthers: false,
//           allowBackgroundPlayback: false,
//         ),
//       );
//
//       final entity = VideoCacheEntity(
//         videoId: reel.id ?? '',
//         controller: controller,
//         lastAccessed: DateTime.now(),
//         isInitialized: false,
//       );
//       _cache[reel.id ?? ""] = entity;
//
//       final initFuture = controller.initialize();
//       _initFutures[reel.id ?? ''] = initFuture;
//
//       await initFuture.timeout(
//         Duration(seconds: isPriority ? 10 : 5),
//         onTimeout: () => throw Exception('Video initialization timeout'),
//       );
//
//       _cache[reel.id ?? ''] = entity.copyWith(isInitialized: true);
//       preloadProgress[reel.id ?? ''] = 1.0;
//
//       if (controller.value.isInitialized) {
//         await controller.seekTo(Duration.zero);
//         await controller.setVolume(0);
//         if (isPriority) {
//           final duration = controller.value.duration;
//           final preloadDuration = Duration(
//             milliseconds: (duration.inMilliseconds * 0.1).clamp(0, 5000).toInt(),
//           );
//           await controller.seekTo(preloadDuration);
//           await controller.seekTo(Duration.zero);
//         }
//       }
//     } catch (e) {
//       preloadProgress[reel.id ?? ''] = -1.0;
//       log("Preload failed: $e");
//     } finally {
//       _initFutures.remove(reel.id);
//     }
//   }
//
//   void _maintainCacheSize() {
//     final maxSize = MemoryManager.cacheSize(fastScrolling: _isFastScrolling);
//     while (_cache.length > maxSize) {
//       final oldestKey = _cache.keys.first;
//       final entity = _cache.remove(oldestKey);
//       entity?.controller.dispose();
//       preloadProgress.remove(oldestKey);
//       log("Cache evicted: $oldestKey");
//     }
//   }
//
//   void _cleanupDistantVideos(
//     List<TrailerData> reels,
//     int currentIndex,
//     bool isFastScrolling,
//   ) {
//     final buffer = MemoryManager.preloadBuffer(fastScrolling: isFastScrolling);
//     final keepRange = List.generate(
//       (buffer * 2) + 1,
//       (i) => currentIndex - buffer + i,
//     ).where((i) => i >= 0 && i < reels.length);
//
//     final reelIds = reels.map((r) => r.id).toSet();
//     final toRemove = _cache.keys.where((id) {
//       final reelIndex = reels.indexWhere((r) => r.id == id);
//       return reelIndex != -1 && reelIds.contains(id) && !keepRange.contains(reelIndex);
//     }).toList();
//
//     final maxToRemove = isFastScrolling ? toRemove.length : toRemove.length;
//     for (final id in toRemove.take(maxToRemove)) {
//       final entity = _cache.remove(id);
//       entity?.controller.dispose();
//       preloadProgress.remove(id);
//       log("Cleanup: $id");
//     }
//   }
//
//   bool isVideoReady(String videoId) {
//     try {
//       if (!_cache.containsKey(videoId)) return false;
//       final entity = _cache[videoId];
//       return entity != null && entity.isInitialized && entity.controller.value.isInitialized && !entity.controller.value.hasError;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   void disposeVideo(String videoId) {
//     final entity = _cache.remove(videoId);
//     entity?.controller.dispose();
//     preloadProgress.remove(videoId);
//     _initFutures.remove(videoId);
//   }
//
//   void removeController(String videoId) {
//     final entity = _cache[videoId];
//     if (entity != null) {
//       entity.controller.dispose();
//       _cache.remove(videoId);
//     }
//     _initFutures.remove(videoId);
//   }
//
//   void disposeAll() {
//     log("🗑️ Disposing all cached videos (${_cache.length})");
//     for (final entry in _cache.entries) {
//       if (!entry.value.controller.value.hasError) {
//         entry.value.controller.dispose();
//       }
//     }
//     _cache.clear();
//     _initFutures.clear();
//     preloadProgress.clear();
//   }
//
//   Future<VideoPlayerController> _createNewController(TrailerData reel) async {
//     log("Creating new controller for: ${reel.id}");
//     final controller = VideoPlayerController.networkUrl(
//       Uri.parse(reel.videos?.videoUrl ?? ""),
//       videoPlayerOptions: VideoPlayerOptions(
//         mixWithOthers: false,
//         allowBackgroundPlayback: false,
//       ),
//     );
//
//     final entity = VideoCacheEntity(
//       videoId: reel.id ?? "",
//       controller: controller,
//       lastAccessed: DateTime.now(),
//       isInitialized: false,
//     );
//
//     _cache[reel.id ?? ""] = entity;
//     _maintainCacheSize();
//
//     final initFuture = controller.initialize();
//     _initFutures[reel.id ?? ""] = initFuture;
//
//     try {
//       await initFuture;
//       if (_cache.containsKey(reel.id)) {
//         _cache[reel.id ?? ""] = entity.copyWith(
//           isInitialized: true,
//           lastAccessed: DateTime.now(),
//         );
//       }
//     } catch (e) {
//       _cache.remove(reel.id);
//       rethrow;
//     } finally {
//       _initFutures.remove(reel.id);
//     }
//
//     return controller;
//   }
//
//   int get cacheCount => _cache.length;
// }

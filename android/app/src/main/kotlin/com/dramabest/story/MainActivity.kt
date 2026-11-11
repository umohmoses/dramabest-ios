//package com.dramabest.storybox
//
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "com.app.reels/video"
//    private lateinit var videoPlayerPool: VideoPlayerPool
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        // 1️⃣ Initialize the player pool
//        videoPlayerPool = VideoPlayerPool(applicationContext)
//
//        // 2️⃣ Register the PlatformView factory
//        flutterEngine
//            .platformViewsController
//            .registry
//            .registerViewFactory(
//                "native-video-player",  // Must match Flutter side
//                VideoViewFactory(videoPlayerPool)
//            )
//
//        // 3️⃣ Setup MethodChannel for control commands
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "initialize" -> {
//                    val urls = call.argument<List<String>>("urls") ?: emptyList()
//                    // Store URLs if needed
//                    result.success(null)
//                }
//
//                "preload" -> {
//                    val index = call.argument<Int>("index") ?: 0
//                    val urls = call.argument<List<String>>("urls") ?: emptyList()
//                    videoPlayerPool.preloadVideos(index, urls)
//                    result.success(null)
//                }
//
//                "play" -> {
//                    val index = call.argument<Int>("index") ?: 0
//                    videoPlayerPool.play(index)
//                    result.success(null)
//                }
//
//                "pause" -> {
//                    val index = call.argument<Int>("index") ?: 0
//                    videoPlayerPool.pause(index)
//                    result.success(null)
//                }
//
//                "dispose" -> {
//                    videoPlayerPool.releaseAll()
//                    result.success(null)
//                }
//
//                else -> result.notImplemented()
//            }
//        }
//    }
//
//    override fun onDestroy() {
//        videoPlayerPool.releaseAll()
//        super.onDestroy()
//    }
//}

package com.dramabest.story

//import io.flutter.embedding.android.FlutterFragmentActivity
//
//class MainActivity: FlutterFragmentActivity() {
//}
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.ryanheise.audioservice.AudioServiceFragmentActivity

class MainActivity: AudioServiceFragmentActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
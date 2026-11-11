// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// import 'package:story_box/routes/app_routes.dart';
// import 'package:story_box/utils/api.dart';
// import 'package:get/get.dart'; // Add this import for navigation
//
// class BranchIoServices {
//   static BranchContentMetaData branchContentMetaData = BranchContentMetaData();
//   static BranchUniversalObject? branchUniversalObject;
//   static BranchLinkProperties branchLinkProperties = BranchLinkProperties();
//
//   static String eventId = "";
//   static String eventType = "";
//   static String movieSeriesId = "";
//   static String movieName = "";
//   static int episodeNumber = 0;
//   static String contentType = "";
//   static int totalVideos = 0;
//   // This is Use to Splash Screen...
//   static void onListenBranchIoLinks() async {
//     StreamController<String> streamController = StreamController<String>();
//     StreamSubscription<Map>? streamSubscription = FlutterBranchSdk.listSession().listen(
//       (data) {
//         log('Click To Branch Io Link => $data');
//         streamController.sink.add((data.toString()));
//
//         if (data.containsKey('+clicked_branch_link') && data['+clicked_branch_link'] == true) {
//           log("Click To Branch Io Link Page Routes => ${data['Video']}");
//           log("Event Id => $eventId");
//
//           // Extract the custom metadata from the Branch.io link
//           movieSeriesId = data['movieSeriesId'];
//           movieName = data['movieName'];
//           episodeNumber = int.tryParse(data['episodeNumber']?.toString() ?? '0') ?? 0;
//           contentType = data['contentType'];
//           totalVideos = int.tryParse(data['totalVideos']?.toString() ?? '0') ?? 0;
//
//           log("Extracted Data - MovieSeriesId: $movieSeriesId, MovieName: $movieName, EpisodeNumber: $episodeNumber, ContentType: $contentType, TotalVideos: $totalVideos");
//
//           // // Navigate to episodeWiseReels screen if we have the required data
//           // if (movieSeriesId != null && movieSeriesId?.isNotEmpty) {
//           //   // _navigateToEpisodeWiseReels(
//           //   //   movieSeriesId: movieSeriesId,
//           //   //   totalVideos: totalVideos ?? 0,
//           //   //   episodeNumber: episodeNumber ?? 0,
//           //   //   movieName: movieName ?? '',
//           //   //   contentType: contentType ?? '',
//           //   // );
//           // } else {
//           //   log("Missing required data for navigation");
//           // }
//         }
//       },
//       onError: (error) {
//         log('Branch Io Listen Error => ${error.toString()}');
//       },
//     );
//     log("Stream Subscription => $streamSubscription");
//   }
//
//   // Helper method to handle navigation
//   static void navigateToEpisodeWiseReels({
//     required String movieSeriesId,
//     required int totalVideos,
//     int? episodeNumber,
//     String? movieName,
//     String? contentType,
//   }) {
//     log("message>>>>>totalVideos>> $totalVideos");
//     // Add a small delay to ensure the app is fully loaded
//     Future.delayed(const Duration(milliseconds: 500), () {
//       log("navigate to EpisodeWiseReels message>>>>>totalVideos>> $totalVideos");
//       if (contentType == "episode") {
//         Get.toNamed(
//           AppRoutes.episodeWiseReels,
//           arguments: {
//             "movieSeriesId": movieSeriesId,
//             "totalVideos": totalVideos,
//             "playIndex": episodeNumber,
//           },
//         );
//       }
//       if (contentType == "movie") {
//         Get.toNamed(
//           AppRoutes.episodeWiseReels,
//           arguments: {
//             "movieSeriesId": movieSeriesId,
//             "totalVideos": totalVideos,
//             "playIndex": 0,
//           },
//         );
//       }
//     });
//   }
//
//   static Future<void> onCreateBranchIoLink({
//     // required String pageRoutes,
//     required String movieSeriesId,
//     required String movieName,
//     required int episodeNumber,
//     required String contentType,
//     required int totalVideos,
//     required String image,
//     required String title,
//     required String description,
//   }) async {
//     branchContentMetaData = BranchContentMetaData()
//       // ..addCustomMetadata("pageRoutes", pageRoutes)
//       ..addCustomMetadata("movieSeriesId", movieSeriesId)
//       ..addCustomMetadata("episodeNumber", episodeNumber)
//       ..addCustomMetadata("movieName", movieName)
//       ..addCustomMetadata("totalVideos", totalVideos)
//       ..addCustomMetadata("contentType", contentType);
//     // ..addCustomMetadata("image", image)
//     // ..addCustomMetadata('userId', userId);
//
//     branchUniversalObject = BranchUniversalObject(
//       canonicalIdentifier: 'flutter/branch',
//       canonicalUrl: 'https://flutter.dev',
//       title: title,
//       imageUrl: ApiConstant.getBaseURL() + image,
//       contentDescription: description,
//       contentMetadata: branchContentMetaData,
//       keywords: ['Plugin', 'Branch', 'Flutter'],
//       publiclyIndex: true,
//       locallyIndex: true,
//       expirationDateInMilliSec: DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch,
//     );
//
//     branchLinkProperties = BranchLinkProperties(channel: 'facebook', feature: 'sharing', stage: 'new share', campaign: 'campaign', tags: ['one', 'two', 'three'])
//       ..addControlParam('\$uri_redirect_mode', '1')
//       ..addControlParam('\$ios_nativelink', true)
//       ..addControlParam('\$match_duration', 7200)
//       ..addControlParam('\$always_deeplink', true)
//       ..addControlParam('\$android_redirect_timeout', 750)
//       ..addControlParam('referring_user_id', 'user_id');
//   }
//
//   static Future<String?> onGenerateLink() async {
//     BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: branchUniversalObject!, linkProperties: branchLinkProperties);
//     if (response.success) {
//       log("Generated Branch Io Link => ${response.result}");
//
//       return response.result.toString();
//     } else {
//       log("Generating Branch Io Link Failed !! => ${response.errorCode} - ${response.errorMessage}");
//       return null;
//     }
//   }
// }

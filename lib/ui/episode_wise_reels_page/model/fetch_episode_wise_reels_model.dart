class FetchEpisodeWiseReelsModel {
  bool? status;
  String? message;
  UserInfo? userInfo;
  int? totalVideosCount;
  bool? isAutoUnlockEnabled; // 👈 new field
  Data? data;

  FetchEpisodeWiseReelsModel({
    this.status,
    this.message,
    this.userInfo,
    this.data,
    this.totalVideosCount,
    this.isAutoUnlockEnabled, // 👈 add in constructor
  });

  FetchEpisodeWiseReelsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalVideosCount = json['totalVideosCount'];
    message = json['message'];
    isAutoUnlockEnabled = json['isAutoUnlockEnabled']; // 👈 parse here
    userInfo =
    json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalVideosCount'] = totalVideosCount;
    data['message'] = message;
    data['isAutoUnlockEnabled'] = isAutoUnlockEnabled; // 👈 add in toJson
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserInfo {
  int? coin;
  int? episodeUnlockAds;

  UserInfo({this.coin, this.episodeUnlockAds});

  UserInfo.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    episodeUnlockAds = json['episodeUnlockAds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coin'] = coin;
    data['episodeUnlockAds'] = episodeUnlockAds;
    return data;
  }
}

class Data {
  String? id;
  String? movieSeriesName;
  String? movieSeriesDescription;
  String? movieSeriesThumbnail;
  int? movieSeriesMaxAdsForFreeView;
  bool? isAddedList;
  int? totalAddedToList;
  List<Videos>? videos;

  Data(
      {this.id,
      this.movieSeriesName,
      this.movieSeriesDescription,
      this.movieSeriesThumbnail,
      this.movieSeriesMaxAdsForFreeView,
      this.isAddedList,
      this.totalAddedToList,
      this.videos});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    movieSeriesName = json['movieSeriesName'];
    movieSeriesDescription = json['movieSeriesDescription'];
    movieSeriesThumbnail = json['movieSeriesThumbnail'];
    movieSeriesMaxAdsForFreeView = json['movieSeriesMaxAdsForFreeView'];
    isAddedList = json['isAddedList'];
    totalAddedToList = json['totalAddedToList'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['movieSeriesName'] = movieSeriesName;
    data['movieSeriesDescription'] = movieSeriesDescription;
    data['movieSeriesThumbnail'] = movieSeriesThumbnail;
    data['movieSeriesMaxAdsForFreeView'] = movieSeriesMaxAdsForFreeView;
    data['isAddedList'] = isAddedList;
    data['totalAddedToList'] = totalAddedToList;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  String? id;
  int? episodeNumber;
  String? videoImage;
  String? videoUrl;
  bool? isLocked;
  int? coin;
  bool? isLike;
  // bool? isAddedList;
  int? totalLikes;
  // int? totalAddedToList;

  Videos({
    this.id,
    this.episodeNumber,
    this.videoImage,
    this.videoUrl,
    this.isLocked,
    this.coin,
    this.isLike,
    // this.isAddedList,
    this.totalLikes,
    // this.totalAddedToList,
  });

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    episodeNumber = json['episodeNumber'];
    videoImage = json['videoImage'];
    videoUrl = json['videoUrl'];
    isLocked = json['isLocked'];
    coin = json['coin'];
    isLike = json['isLike'];
    // isAddedList = json['isAddedList'];
    totalLikes = json['totalLikes'];
    // totalAddedToList = json['totalAddedToList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['episodeNumber'] = episodeNumber;
    data['videoImage'] = videoImage;
    data['videoUrl'] = videoUrl;
    data['isLocked'] = isLocked;
    data['coin'] = coin;
    data['isLike'] = isLike;
    // data['isAddedList'] = isAddedList;
    data['totalLikes'] = totalLikes;
    // data['totalAddedToList'] = totalAddedToList;
    return data;
  }
}

//
// class FetchEpisodeWiseReelsModel {
//   bool? status;
//   String? message;
//   UserInfo? userInfo;
//   int? totalVideosCount;
//   // bool? isAutoUnlockEnabled; // 👈 new field
//   Data? data;
//
//   FetchEpisodeWiseReelsModel({
//     this.status,
//     this.message,
//     this.userInfo,
//     this.data,
//     this.totalVideosCount,
//     // this.isAutoUnlockEnabled, // 👈 add in constructor
//   });
//
//   FetchEpisodeWiseReelsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     totalVideosCount = json['totalVideosCount'];
//     message = json['message'];
//     // isAutoUnlockEnabled = json['isAutoUnlockEnabled']; // 👈 parse here
//     userInfo =
//     json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['totalVideosCount'] = totalVideosCount;
//     data['message'] = message;
//     // data['isAutoUnlockEnabled'] = isAutoUnlockEnabled; // 👈 add in toJson
//     if (userInfo != null) {
//       data['userInfo'] = userInfo!.toJson();
//     }
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class UserInfo {
//   int? coin;
//   int? episodeUnlockAds;
//
//   UserInfo({this.coin, this.episodeUnlockAds});
//
//   UserInfo.fromJson(Map<String, dynamic> json) {
//     coin = json['coin'];
//     episodeUnlockAds = json['episodeUnlockAds'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['coin'] = coin;
//     data['episodeUnlockAds'] = episodeUnlockAds;
//     return data;
//   }
// }
//
// class Data {
//   String? id;
//   String? movieSeriesName;
//   String? movieSeriesDescription;
//   String? movieSeriesThumbnail;
//   int? movieSeriesMaxAdsForFreeView;
//   bool? isAddedList;
//   int? totalAddedToList;
//   bool? isAutoUnlockEnabled; // 👈 new field
//   List<Videos>? videos;
//
//   Data(
//       {this.id,
//         this.movieSeriesName,
//         this.movieSeriesDescription,
//         this.movieSeriesThumbnail,
//         this.movieSeriesMaxAdsForFreeView,
//         this.isAddedList,
//         this.totalAddedToList,
//         this.isAutoUnlockEnabled,
//         this.videos});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     movieSeriesName = json['movieSeriesName'];
//     movieSeriesDescription = json['movieSeriesDescription'];
//     movieSeriesThumbnail = json['movieSeriesThumbnail'];
//     movieSeriesMaxAdsForFreeView = json['movieSeriesMaxAdsForFreeView'];
//     isAddedList = json['isAddedList'];
//     totalAddedToList = json['totalAddedToList'];
//     isAutoUnlockEnabled = json['isAutoUnlockEnabled'];
//     if (json['videos'] != null) {
//       videos = <Videos>[];
//       json['videos'].forEach((v) {
//         videos!.add(Videos.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = id;
//     data['movieSeriesName'] = movieSeriesName;
//     data['movieSeriesDescription'] = movieSeriesDescription;
//     data['movieSeriesThumbnail'] = movieSeriesThumbnail;
//     data['movieSeriesMaxAdsForFreeView'] = movieSeriesMaxAdsForFreeView;
//     data['isAddedList'] = isAddedList;
//     data['totalAddedToList'] = totalAddedToList;
//     data['isAutoUnlockEnabled'] = isAutoUnlockEnabled;
//     if (videos != null) {
//       data['videos'] = videos!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Videos {
//   String? id;
//   int? episodeNumber;
//   String? videoImage;
//   String? videoUrl;
//   bool? isLocked;
//   int? coin;
//   bool? isLike;
//   // bool? isAddedList;
//   int? totalLikes;
//   // int? totalAddedToList;
//
//   Videos({
//     this.id,
//     this.episodeNumber,
//     this.videoImage,
//     this.videoUrl,
//     this.isLocked,
//     this.coin,
//     this.isLike,
//     // this.isAddedList,
//     this.totalLikes,
//     // this.totalAddedToList,
//   });
//
//   Videos.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     episodeNumber = json['episodeNumber'];
//     videoImage = json['videoImage'];
//     videoUrl = json['videoUrl'];
//     isLocked = json['isLocked'];
//     coin = json['coin'];
//     isLike = json['isLike'];
//     // isAddedList = json['isAddedList'];
//     totalLikes = json['totalLikes'];
//     // totalAddedToList = json['totalAddedToList'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = id;
//     data['episodeNumber'] = episodeNumber;
//     data['videoImage'] = videoImage;
//     data['videoUrl'] = videoUrl;
//     data['isLocked'] = isLocked;
//     data['coin'] = coin;
//     data['isLike'] = isLike;
//     // data['isAddedList'] = isAddedList;
//     data['totalLikes'] = totalLikes;
//     // data['totalAddedToList'] = totalAddedToList;
//     return data;
//   }
// }

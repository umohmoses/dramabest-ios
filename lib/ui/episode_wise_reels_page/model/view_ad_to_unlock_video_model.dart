class ViewAdToUnlockVideoModel {
  String? sId;
  String? movieSeries;
  Null category;
  int? episodeNumber;
  String? videoImage;
  String? videoUrl;
  int? duration;
  int? coin;
  bool? isLocked;
  String? releaseDate;
  String? createdAt;
  String? updatedAt;
  // Rewarded-ad unlock progress (server >= monetisation update)
  bool? status;
  String? code;
  String? message;
  bool? unlocked;
  int? adsWatched;
  int? adsRequired;
  int? adsLeft;
  int? coinsEarned;
  bool? pending;
  List<String> unlockedVideoIds = [];

  ViewAdToUnlockVideoModel(
      {this.sId,
      this.movieSeries,
      this.category,
      this.episodeNumber,
      this.videoImage,
      this.videoUrl,
      this.duration,
      this.coin,
      this.isLocked,
      this.releaseDate,
      this.createdAt,
      this.updatedAt});

  ViewAdToUnlockVideoModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    movieSeries = json['movieSeries'];
    category = json['category'];
    episodeNumber = json['episodeNumber'];
    videoImage = json['videoImage'];
    videoUrl = json['videoUrl'];
    duration = json['duration'];
    coin = json['coin'];
    isLocked = json['isLocked'];
    releaseDate = json['releaseDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    code = json['code'];
    message = json['message'];
    unlocked = json['unlocked'];
    adsWatched = json['adsWatched'];
    adsRequired = json['adsRequired'];
    adsLeft = json['adsLeft'];
    coinsEarned = json['coinsEarned'];
    pending = json['pending'];
    unlockedVideoIds = (json['unlockedVideoIds'] is List) ? List<String>.from((json['unlockedVideoIds'] as List).map((e) => e.toString())) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['movieSeries'] = movieSeries;
    data['category'] = category;
    data['episodeNumber'] = episodeNumber;
    data['videoImage'] = videoImage;
    data['videoUrl'] = videoUrl;
    data['duration'] = duration;
    data['coin'] = coin;
    data['isLocked'] = isLocked;
    data['releaseDate'] = releaseDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

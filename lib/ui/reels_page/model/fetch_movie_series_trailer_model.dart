class FetchMovieSeriesTrailerModel {
  bool? status;
  String? message;
  List<TrailerData>? data;

  FetchMovieSeriesTrailerModel({this.status, this.message, this.data});

  FetchMovieSeriesTrailerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TrailerData>[];
      json['data'].forEach((v) {
        data!.add(TrailerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrailerData {
  String? id;
  String? movieSeriesName;
  String? movieSeriesDescription;
  String? movieSeriesThumbnail;
  bool? isAddedList;
  int? totalAddedToList;
  Videos? videos;
  int? totalVideos;

  TrailerData({
    this.id,
    this.movieSeriesName,
    this.movieSeriesDescription,
    this.movieSeriesThumbnail,
    this.videos,
    this.totalVideos,
    this.isAddedList,
    this.totalAddedToList,
  });

  TrailerData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    movieSeriesName = json['movieSeriesName'];
    movieSeriesDescription = json['movieSeriesDescription'];
    movieSeriesThumbnail = json['movieSeriesThumbnail'];
    isAddedList = json['isAddedList'];
    totalAddedToList = json['totalAddedToList'];
    videos = json['videos'] != null ? Videos.fromJson(json['videos']) : null;
    totalVideos = json['totalVideos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['movieSeriesName'] = movieSeriesName;
    data['movieSeriesDescription'] = movieSeriesDescription;
    data['movieSeriesThumbnail'] = movieSeriesThumbnail;
    data['isAddedList'] = isAddedList;
    data['totalAddedToList'] = totalAddedToList;
    if (videos != null) {
      data['videos'] = videos!.toJson();
    }
    data['totalVideos'] = totalVideos;
    return data;
  }
}

class Videos {
  String? id;
  int? episodeNumber;
  String? videoImage;
  String? videoUrl;
  bool? isLocked;
  bool? isLike;
  int? totalLikes;

  Videos({this.id, this.episodeNumber, this.videoImage, this.videoUrl, this.isLocked, this.isLike, this.totalLikes});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    episodeNumber = json['episodeNumber'];
    videoImage = json['videoImage'];
    videoUrl = json['videoUrl'];
    isLocked = json['isLocked'];
    isLike = json['isLike'];
    totalLikes = json['totalLikes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['episodeNumber'] = episodeNumber;
    data['videoImage'] = videoImage;
    data['videoUrl'] = videoUrl;
    data['isLocked'] = isLocked;
    data['isLike'] = isLike;
    data['totalLikes'] = totalLikes;
    return data;
  }
}

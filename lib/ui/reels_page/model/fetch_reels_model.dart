// // To parse this JSON data, do
// //
// //     final getVideosGroupedByMovieSeriesModel = getVideosGroupedByMovieSeriesModelFromJson(jsonString);
//
// import 'dart:convert';
//
// GetVideosGroupedByMovieSeriesModel getVideosGroupedByMovieSeriesModelFromJson(String str) => GetVideosGroupedByMovieSeriesModel.fromJson(json.decode(str));
//
// String getVideosGroupedByMovieSeriesModelToJson(GetVideosGroupedByMovieSeriesModel data) => json.encode(data.toJson());
//
// class GetVideosGroupedByMovieSeriesModel {
//   bool? status;
//   String? message;
//   List<MovieSeries>? data;
//
//   GetVideosGroupedByMovieSeriesModel({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory GetVideosGroupedByMovieSeriesModel.fromJson(Map<String, dynamic> json) => GetVideosGroupedByMovieSeriesModel(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? [] : List<MovieSeries>.from(json["data"]!.map((x) => MovieSeries.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class MovieSeries {
//   String? id;
//   String? movieSeriesName;
//   String? movieSeriesDescription;
//   String? movieSeriesThumbnail;
//   List<Video>? videos;
//   int? totalVideos;
//
//   MovieSeries({
//     this.id,
//     this.movieSeriesName,
//     this.movieSeriesDescription,
//     this.movieSeriesThumbnail,
//     this.videos,
//     this.totalVideos,
//   });
//
//   factory MovieSeries.fromJson(Map<String, dynamic> json) => MovieSeries(
//         id: json["_id"],
//         movieSeriesName: json["movieSeriesName"],
//         movieSeriesDescription: json["movieSeriesDescription"],
//         movieSeriesThumbnail: json["movieSeriesThumbnail"],
//         videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
//         totalVideos: json["totalVideos"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "movieSeriesName": movieSeriesName,
//         "movieSeriesDescription": movieSeriesDescription,
//         "movieSeriesThumbnail": movieSeriesThumbnail,
//         "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
//         "totalVideos": totalVideos,
//       };
// }
//
// class Video {
//   String? id;
//   int? episodeNumber;
//   String? videoImage;
//   String? videoUrl;
//   bool? isLocked;
//   bool? isLike;
//   bool? isAddedList;
//
//   Video({
//     this.id,
//     this.episodeNumber,
//     this.videoImage,
//     this.videoUrl,
//     this.isLocked,
//     this.isLike,
//     this.isAddedList,
//   });
//
//   factory Video.fromJson(Map<String, dynamic> json) => Video(
//         id: json["_id"],
//         episodeNumber: json["episodeNumber"],
//         videoImage: json["videoImage"],
//         videoUrl: json["videoUrl"],
//         isLocked: json["isLocked"],
//         isLike: json["isLike"],
//         isAddedList: json["isAddedList"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "episodeNumber": episodeNumber,
//         "videoImage": videoImage,
//         "videoUrl": videoUrl,
//         "isLocked": isLocked,
//         "isLike": isLike,
//         "isAddedList": isAddedList,
//       };
// }

import 'dart:convert';

AllMovieRankingModel allMovieRankingModelFromJson(String str) => AllMovieRankingModel.fromJson(json.decode(str));

String allMovieRankingModelToJson(AllMovieRankingModel data) => json.encode(data.toJson());

class AllMovieRankingModel {
  bool? status;
  String? message;
  int? total;
  List<Trending>? trending;

  AllMovieRankingModel({
    this.status,
    this.message,
    this.total,
    this.trending,
  });

  factory AllMovieRankingModel.fromJson(Map<String, dynamic> json) => AllMovieRankingModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        trending: json["trending"] == null ? [] : List<Trending>.from(json["trending"]!.map((x) => Trending.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "trending": trending == null ? [] : List<dynamic>.from(trending!.map((x) => x.toJson())),
      };
}

class Trending {
  String? id;
  int? views;
  Movie? movie;

  Trending({
    this.id,
    this.views,
    this.movie,
  });

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
        id: json["_id"],
        views: json["views"],
        movie: json["movie"] == null ? null : Movie.fromJson(json["movie"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "views": views,
        "movie": movie?.toJson(),
      };
}

class Movie {
  String? id;
  String? name;
  String? description;
  String? thumbnail;
  String? category;
  String? languageName;

  Movie({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.category,
    this.languageName,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        category: json["category"],
        languageName: json["languageName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "languageName": languageName,
      };
}

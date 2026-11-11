import 'dart:convert';

GetMoviesGroupedByCategoryModel getMoviesGroupedByCategoryModelFromJson(String str) => GetMoviesGroupedByCategoryModel.fromJson(json.decode(str));

String getMoviesGroupedByCategoryModelToJson(GetMoviesGroupedByCategoryModel data) => json.encode(data.toJson());

class GetMoviesGroupedByCategoryModel {
  GetMoviesGroupedByCategoryModel({
    bool? status,
    String? message,
    List<GroupedMovies>? groupedMovies,
  }) {
    _status = status;
    _message = message;
    _groupedMovies = groupedMovies;
  }

  GetMoviesGroupedByCategoryModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['groupedMovies'] != null) {
      _groupedMovies = [];
      json['groupedMovies'].forEach((v) {
        _groupedMovies?.add(GroupedMovies.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<GroupedMovies>? _groupedMovies;

  GetMoviesGroupedByCategoryModel copyWith({
    bool? status,
    String? message,
    List<GroupedMovies>? groupedMovies,
  }) =>
      GetMoviesGroupedByCategoryModel(
        status: status ?? _status,
        message: message ?? _message,
        groupedMovies: groupedMovies ?? _groupedMovies,
      );

  bool? get status => _status;

  String? get message => _message;

  List<GroupedMovies>? get groupedMovies => _groupedMovies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_groupedMovies != null) {
      map['groupedMovies'] = _groupedMovies?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

GroupedMovies groupedMoviesFromJson(String str) => GroupedMovies.fromJson(json.decode(str));

String groupedMoviesToJson(GroupedMovies data) => json.encode(data.toJson());

class GroupedMovies {
  GroupedMovies({
    List<Movies>? movies,
    String? categoryName,
  }) {
    _movies = movies;
    _categoryName = categoryName;
  }

  GroupedMovies.fromJson(dynamic json) {
    if (json['movies'] != null) {
      _movies = [];
      json['movies'].forEach((v) {
        _movies?.add(Movies.fromJson(v));
      });
    }
    _categoryName = json['categoryName'];
  }

  List<Movies>? _movies;
  String? _categoryName;

  GroupedMovies copyWith({
    List<Movies>? movies,
    String? categoryName,
  }) =>
      GroupedMovies(
        movies: movies ?? _movies,
        categoryName: categoryName ?? _categoryName,
      );

  List<Movies>? get movies => _movies;

  String? get categoryName => _categoryName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_movies != null) {
      map['movies'] = _movies?.map((v) => v.toJson()).toList();
    }
    map['categoryName'] = _categoryName;
    return map;
  }
}

Movies moviesFromJson(String str) => Movies.fromJson(json.decode(str));

String moviesToJson(Movies data) => json.encode(data.toJson());

class Movies {
  Movies({
    String? id,
    String? name,
    String? thumbnail,
    String? languageName,
    num? totalViews,
  }) {
    _id = id;
    _name = name;
    _thumbnail = thumbnail;
    _languageName = languageName;
    _totalViews = totalViews;
  }

  Movies.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _thumbnail = json['thumbnail'];
    _languageName = json['languageName'];
    _totalViews = json['totalViews'];
  }

  String? _id;
  String? _name;
  String? _thumbnail;
  String? _languageName;
  num? _totalViews;

  Movies copyWith({
    String? id,
    String? name,
    String? thumbnail,
    String? languageName,
    num? totalViews,
  }) =>
      Movies(
        id: id ?? _id,
        name: name ?? _name,
        thumbnail: thumbnail ?? _thumbnail,
        languageName: languageName ?? _languageName,
        totalViews: _totalViews,
      );

  String? get id => _id;

  String? get name => _name;

  String? get thumbnail => _thumbnail;
  String? get languageName => _languageName;

  num? get totalViews => _totalViews;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['thumbnail'] = _thumbnail;
    map['languageName'] = _languageName;
    map['totalViews'] = _totalViews;
    return map;
  }
}

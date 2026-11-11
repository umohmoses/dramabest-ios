class Video {
  MovieSeries? movieSeries;
  String? sId;
  String? addedAt;

  Video({this.movieSeries, this.sId, this.addedAt});

  Video.fromJson(Map<String, dynamic> json) {
    movieSeries = json['movieSeries'] != null ? MovieSeries.fromJson(json['movieSeries']) : null;
    sId = json['_id'];
    addedAt = json['addedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (movieSeries != null) {
      data['movieSeries'] = movieSeries!.toJson();
    }
    data['_id'] = sId;
    data['addedAt'] = addedAt;
    return data;
  }
}

class MovieSeries {
  String? sId;
  String? name;
  String? thumbnail;

  MovieSeries({this.sId, this.name, this.thumbnail});

  MovieSeries.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['thumbnail'] = thumbnail;
    return data;
  }
}

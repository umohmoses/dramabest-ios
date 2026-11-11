class EpisodeAutoUnlockModel {
  String? sId;
  String? uniqueId;
  String? date;
  String? movieSeriesId;
  String? name;
  String? thumbnail;
  bool? isAutoUnlockEpisodes;

  EpisodeAutoUnlockModel(
      {this.sId, this.uniqueId, this.date, this.movieSeriesId, this.name, this.thumbnail, this.isAutoUnlockEpisodes});

  EpisodeAutoUnlockModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uniqueId = json['uniqueId'];
    date = json['date'];
    movieSeriesId = json['movieSeriesId'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    isAutoUnlockEpisodes = json['isAutoUnlockEpisodes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['uniqueId'] = uniqueId;
    data['date'] = date;
    data['movieSeriesId'] = movieSeriesId;
    data['name'] = name;
    data['thumbnail'] = thumbnail;
    data['isAutoUnlockEpisodes'] = isAutoUnlockEpisodes;
    return data;
  }
}

class EpisodeUnlockModel {
  String? sId;
  int? coin;
  String? uniqueId;
  String? date;
  String? name;
  int? episodeNumber;

  EpisodeUnlockModel({this.sId, this.coin, this.uniqueId, this.date, this.name, this.episodeNumber});

  EpisodeUnlockModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    coin = json['coin'];
    uniqueId = json['uniqueId'];
    date = json['date'];
    name = json['name'];
    episodeNumber = json['episodeNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['coin'] = coin;
    data['uniqueId'] = uniqueId;
    data['date'] = date;
    data['name'] = name;
    data['episodeNumber'] = episodeNumber;
    return data;
  }
}

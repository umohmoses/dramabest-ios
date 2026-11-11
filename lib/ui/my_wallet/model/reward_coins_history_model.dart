class RewardCoinsHistoryModel {
  bool? status;
  String? message;
  List<Data>? data;

  RewardCoinsHistoryModel({this.status, this.message, this.data});

  RewardCoinsHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? userId;
  String? videoId;
  String? movieSeries;
  int? type;
  int? coin;
  int? rewardCoinUsed;
  int? purchasedCoinUsed;
  int? adCoinUsed;
  int? dailyCoinUsed;
  int? loginCoinUsed;
  num? price;
  num? offerPrice;
  String? paymentGateway;
  String? uniqueId;
  String? date;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.userId,
      this.videoId,
      this.movieSeries,
      this.type,
      this.coin,
      this.rewardCoinUsed,
      this.purchasedCoinUsed,
      this.adCoinUsed,
      this.dailyCoinUsed,
      this.loginCoinUsed,
      this.price,
      this.offerPrice,
      this.paymentGateway,
      this.uniqueId,
      this.date,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    videoId = json['videoId'];
    movieSeries = json['movieSeries'];
    type = json['type'];
    coin = json['coin'];
    rewardCoinUsed = json['rewardCoinUsed'];
    purchasedCoinUsed = json['purchasedCoinUsed'];
    adCoinUsed = json['adCoinUsed'];
    dailyCoinUsed = json['dailyCoinUsed'];
    loginCoinUsed = json['loginCoinUsed'];
    price = json['price'];
    offerPrice = json['offerPrice'];
    paymentGateway = json['paymentGateway'];
    uniqueId = json['uniqueId'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['videoId'] = videoId;
    data['movieSeries'] = movieSeries;
    data['type'] = type;
    data['coin'] = coin;
    data['rewardCoinUsed'] = rewardCoinUsed;
    data['purchasedCoinUsed'] = purchasedCoinUsed;
    data['adCoinUsed'] = adCoinUsed;
    data['dailyCoinUsed'] = dailyCoinUsed;
    data['loginCoinUsed'] = loginCoinUsed;
    data['price'] = price;
    data['offerPrice'] = offerPrice;
    data['paymentGateway'] = paymentGateway;
    data['uniqueId'] = uniqueId;
    data['date'] = date;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

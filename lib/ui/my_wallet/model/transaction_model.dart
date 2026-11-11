import 'dart:convert';

CoinPlanHistory coinPlanHistoryFromJson(String str) => CoinPlanHistory.fromJson(json.decode(str));

String coinPlanHistoryToJson(CoinPlanHistory data) => json.encode(data.toJson());

class CoinPlanHistory {
  String? id;
  int? type;
  int? coin;
  String? uniqueId;
  String? date;
  String? createdAt;
  String? paymentGateway;
  num? price;

  CoinPlanHistory({
    this.id,
    this.type,
    this.coin,
    this.uniqueId,
    this.date,
    this.createdAt,
    this.paymentGateway,
    this.price,
  });

  factory CoinPlanHistory.fromJson(Map<String, dynamic> json) => CoinPlanHistory(
        id: json["_id"],
        type: json["type"],
        coin: json["coin"],
        uniqueId: json["uniqueId"],
        date: json["date"],
        createdAt: json["createdAt"],
        paymentGateway: json["paymentGateway"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "coin": coin,
        "uniqueId": uniqueId,
        "date": date,
        "createdAt": createdAt,
        "paymentGateway": paymentGateway,
        "price": price,
      };
}

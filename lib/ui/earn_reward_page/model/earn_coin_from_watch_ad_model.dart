// To parse this JSON data, do
//
//     final earnCoinFromWatchAdModel = earnCoinFromWatchAdModelFromJson(jsonString);

import 'dart:convert';

EarnCoinFromWatchAdModel earnCoinFromWatchAdModelFromJson(String str) =>
    EarnCoinFromWatchAdModel.fromJson(json.decode(str));

String earnCoinFromWatchAdModelToJson(EarnCoinFromWatchAdModel data) => json.encode(data.toJson());

class EarnCoinFromWatchAdModel {
  bool? status;
  String? message;
  WatchAdData? data;

  EarnCoinFromWatchAdModel({
    this.status,
    this.message,
    this.data,
  });

  factory EarnCoinFromWatchAdModel.fromJson(Map<String, dynamic> json) => EarnCoinFromWatchAdModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : WatchAdData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class WatchAdData {
  WatchAds? watchAds;
  String? id;
  String? name;
  String? username;
  String? gender;
  String? bio;
  String? age;
  String? country;
  String? profilePic;
  String? fcmToken;
  String? email;
  String? mobileNumber;
  String? identity;
  String? uniqueId;
  int? coin;
  int? rewardCoin;
  int? purchasedCoin;
  bool? isBlock;
  bool? isReferral;
  int? referralCount;
  String? referralCode;
  int? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;

  WatchAdData({
    this.watchAds,
    this.id,
    this.name,
    this.username,
    this.gender,
    this.bio,
    this.age,
    this.country,
    this.profilePic,
    this.fcmToken,
    this.email,
    this.mobileNumber,
    this.identity,
    this.uniqueId,
    this.coin,
    this.rewardCoin,
    this.purchasedCoin,
    this.isBlock,
    this.isReferral,
    this.referralCount,
    this.referralCode,
    this.loginType,
    this.createdAt,
    this.updatedAt,
  });

  factory WatchAdData.fromJson(Map<String, dynamic> json) => WatchAdData(
        watchAds: json["watchAds"] == null ? null : WatchAds.fromJson(json["watchAds"]),
        id: json["_id"],
        name: json["name"],
        username: json["username"],
        gender: json["gender"],
        bio: json["bio"],
        age: json["age"],
        country: json["country"],
        profilePic: json["profilePic"],
        fcmToken: json["fcmToken"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        identity: json["identity"],
        uniqueId: json["uniqueId"],
        coin: json["coin"],
        rewardCoin: json["rewardCoin"],
        purchasedCoin: json["purchasedCoin"],
        isBlock: json["isBlock"],
        isReferral: json["isReferral"],
        referralCount: json["referralCount"],
        referralCode: json["referralCode"],
        loginType: json["loginType"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "watchAds": watchAds?.toJson(),
        "_id": id,
        "name": name,
        "username": username,
        "gender": gender,
        "bio": bio,
        "age": age,
        "country": country,
        "profilePic": profilePic,
        "fcmToken": fcmToken,
        "email": email,
        "mobileNumber": mobileNumber,
        "identity": identity,
        "uniqueId": uniqueId,
        "coin": coin,
        "rewardCoin": rewardCoin,
        "purchasedCoin": purchasedCoin,
        "isBlock": isBlock,
        "isReferral": isReferral,
        "referralCount": referralCount,
        "referralCode": referralCode,
        "loginType": loginType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class WatchAds {
  int? count;
  DateTime? date;

  WatchAds({
    this.count,
    this.date,
  });

  factory WatchAds.fromJson(Map<String, dynamic> json) => WatchAds(
        count: json["count"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "date": date?.toIso8601String(),
      };
}

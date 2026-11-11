// To parse this JSON data, do
//
//     final loginUserModel = loginUserModelFromJson(jsonString);

import 'dart:convert';

LoginUserModel loginUserModelFromJson(String str) => LoginUserModel.fromJson(json.decode(str));

String loginUserModelToJson(LoginUserModel data) => json.encode(data.toJson());

class LoginUserModel {
  bool? status;
  String? message;
  User? user;
  bool? signUp;

  LoginUserModel({
    this.status,
    this.message,
    this.user,
    this.signUp,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    signUp: json["signUp"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user?.toJson(),
    "signUp": signUp,
  };
}

class User {
  CurrentPlan? currentPlan;
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
  bool? isVip;
  dynamic vipPlanStartDate;
  dynamic vipPlanEndDate;
  bool? isBlock;
  bool? isReferral;
  int? referralCount;
  String? date;
  String? lastLogin;
  List<dynamic>? coinplan;
  List<dynamic>? episodeUnlockAds;
  String? referralCode;
  int? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.currentPlan,
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
    this.isVip,
    this.vipPlanStartDate,
    this.vipPlanEndDate,
    this.isBlock,
    this.isReferral,
    this.referralCount,
    this.date,
    this.lastLogin,
    this.coinplan,
    this.episodeUnlockAds,
    this.referralCode,
    this.loginType,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    currentPlan: json["currentPlan"] == null ? null : CurrentPlan.fromJson(json["currentPlan"]),
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
    isVip: json["isVip"],
    vipPlanStartDate: json["vipPlanStartDate"],
    vipPlanEndDate: json["vipPlanEndDate"],
    isBlock: json["isBlock"],
    isReferral: json["isReferral"],
    referralCount: json["referralCount"],
    date: json["date"],
    lastLogin: json["lastLogin"],
    coinplan: json["coinplan"] == null ? [] : List<dynamic>.from(json["coinplan"]!.map((x) => x)),
    episodeUnlockAds: json["episodeUnlockAds"] == null ? [] : List<dynamic>.from(json["episodeUnlockAds"]!.map((x) => x)),
    referralCode: json["referralCode"],
    loginType: json["loginType"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "currentPlan": currentPlan?.toJson(),
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
    "isVip": isVip,
    "vipPlanStartDate": vipPlanStartDate,
    "vipPlanEndDate": vipPlanEndDate,
    "isBlock": isBlock,
    "isReferral": isReferral,
    "referralCount": referralCount,
    "date": date,
    "lastLogin": lastLogin,
    "coinplan": coinplan == null ? [] : List<dynamic>.from(coinplan!.map((x) => x)),
    "episodeUnlockAds": episodeUnlockAds == null ? [] : List<dynamic>.from(episodeUnlockAds!.map((x) => x)),
    "referralCode": referralCode,
    "loginType": loginType,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class CurrentPlan {
  int? validity;
  String? validityType;
  num? price;
  num? offerPrice;
  String? tags;

  CurrentPlan({
    this.validity,
    this.validityType,
    this.price,
    this.offerPrice,
    this.tags,
  });

  factory CurrentPlan.fromJson(Map<String, dynamic> json) => CurrentPlan(
    validity: json["validity"],
    validityType: json["validityType"],
    price: json["price"],
    offerPrice: json["offerPrice"],
    tags: json["tags"],
  );

  Map<String, dynamic> toJson() => {
    "validity": validity,
    "validityType": validityType,
    "price": price,
    "offerPrice": offerPrice,
    "tags": tags,
  };
}

class WatchAds {
  int? count;
  dynamic date;

  WatchAds({
    this.count,
    this.date,
  });

  factory WatchAds.fromJson(Map<String, dynamic> json) => WatchAds(
    count: json["count"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "date": date,
  };
}

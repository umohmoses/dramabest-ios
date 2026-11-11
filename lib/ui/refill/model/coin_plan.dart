class CoinPlan {
  String? sId;
  String? icon;
  num? coin;
  num? bonusCoin;
  num? price;
  num? offerPrice;
  String? productKey;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  CoinPlan(
      {this.sId, this.icon, this.coin, this.bonusCoin, this.price, this.offerPrice, this.productKey, this.isActive, this.createdAt, this.updatedAt});

  CoinPlan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    icon = json['icon'];
    coin = json['coin'];
    bonusCoin = json['bonusCoin'];
    price = json['price'];
    offerPrice = json['offerPrice'];
    productKey = json['productKey'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['icon'] = icon;
    data['coin'] = coin;
    data['bonusCoin'] = bonusCoin;
    data['price'] = price;
    data['offerPrice'] = offerPrice;
    data['productKey'] = productKey;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class VipPlan {
  String? sId;
  int? validity;
  String? validityType;
  num? price;
  num? offerPrice;
  String? tags;
  String? productKey;
  bool? isActive;
  int coinPrice = 0; // coins that redeem this plan (0 = not redeemable)
  String? createdAt;
  String? updatedAt;

  VipPlan(
      {this.sId,
      this.validity,
      this.validityType,
      this.price,
      this.offerPrice,
      this.tags,
      this.productKey,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  VipPlan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    validity = json['validity'];
    validityType = json['validityType'];
    price = json['price'];
    offerPrice = json['offerPrice'];
    tags = json['tags'];
    productKey = json['productKey'];
    isActive = json['isActive'];
    coinPrice = (json['coinPrice'] is num) ? (json['coinPrice'] as num).toInt() : 0;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['validity'] = validity;
    data['validityType'] = validityType;
    data['price'] = price;
    data['offerPrice'] = offerPrice;
    data['tags'] = tags;
    data['productKey'] = productKey;
    data['isActive'] = isActive;
    data['coinPrice'] = coinPrice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

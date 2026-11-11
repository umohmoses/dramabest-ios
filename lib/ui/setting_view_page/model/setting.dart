// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);
// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  bool status;
  String message;
  Setting setting;

  SettingModel({
    required this.status,
    required this.message,
    required this.setting,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        status: json["status"],
        message: json["message"],
        setting: Setting.fromJson(json["setting"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "setting": setting.toJson(),
      };
}

class Setting {
  Currency currency;
  Storage storage;
  Android android;
  Android ios;
  String id;
  bool googlePlaySwitch;
  bool stripeSwitch;
  String stripePublishableKey;
  String stripeSecretKey;
  bool razorPaySwitch;
  String razorPayId;
  String razorSecretKey;
  String flutterWaveId;
  bool flutterWaveSwitch;
  String privacyPolicyLink;
  String termsOfUsePolicyLink;
  int durationOfShorts;
  int minCoinForCashOut;
  int minWithdrawalRequestedCoin;
  int referralRewardCoins;
  int watchingVideoRewardCoins;
  int commentingRewardCoins;
  int likeVideoRewardCoins;
  int loginRewardCoins;
  int maxAdPerDay;
  bool isGoogle;
  PrivateKey privateKey;
  DateTime createdAt;
  DateTime updatedAt;
  int freeEpisodesForNonVip;
  String contactEmail;
  String resendApiKey;
  String awsAccessKey;
  String awsBucketName;
  String awsEndpoint;
  String awsHostname;
  String awsRegion;
  String awsSecretKey;
  String doAccessKey;
  String doBucketName;
  String doEndpoint;
  String doHostname;
  String doRegion;
  String doSecretKey;
  String androidAppLink;
  String androidAppVersion;
  String iosAppLink;
  String iosAppVersion;
  List<AndroidAssetLink> androidAssetLinks;
  AppleAppSiteAssociation appleAppSiteAssociation;
  bool cashfreeAndroidEnabled;
  String cashfreeClientId;
  String cashfreeClientSecret;
  bool cashfreeIosEnabled;
  bool flutterwaveIosEnabled;
  bool googlePayIosEnabled;
  bool paypalAndroidEnabled;
  String paypalClientId;
  bool paypalIosEnabled;
  String paypalSecretKey;
  bool paystackAndroidEnabled;
  bool paystackIosEnabled;
  String paystackPublicKey;
  String paystackSecretKey;
  bool razorpayIosEnabled;
  bool stripeIosEnabled;
  String websiteUrl;

  Setting({
    required this.currency,
    required this.storage,
    required this.android,
    required this.ios,
    required this.id,
    required this.googlePlaySwitch,
    required this.stripeSwitch,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
    required this.razorPaySwitch,
    required this.razorPayId,
    required this.razorSecretKey,
    required this.flutterWaveId,
    required this.flutterWaveSwitch,
    required this.privacyPolicyLink,
    required this.termsOfUsePolicyLink,
    required this.durationOfShorts,
    required this.minCoinForCashOut,
    required this.minWithdrawalRequestedCoin,
    required this.referralRewardCoins,
    required this.watchingVideoRewardCoins,
    required this.commentingRewardCoins,
    required this.likeVideoRewardCoins,
    required this.loginRewardCoins,
    required this.maxAdPerDay,
    required this.isGoogle,
    required this.privateKey,
    required this.createdAt,
    required this.updatedAt,
    required this.freeEpisodesForNonVip,
    required this.contactEmail,
    required this.resendApiKey,
    required this.awsAccessKey,
    required this.awsBucketName,
    required this.awsEndpoint,
    required this.awsHostname,
    required this.awsRegion,
    required this.awsSecretKey,
    required this.doAccessKey,
    required this.doBucketName,
    required this.doEndpoint,
    required this.doHostname,
    required this.doRegion,
    required this.doSecretKey,
    required this.androidAppLink,
    required this.androidAppVersion,
    required this.iosAppLink,
    required this.iosAppVersion,
    required this.androidAssetLinks,
    required this.appleAppSiteAssociation,
    required this.cashfreeAndroidEnabled,
    required this.cashfreeClientId,
    required this.cashfreeClientSecret,
    required this.cashfreeIosEnabled,
    required this.flutterwaveIosEnabled,
    required this.googlePayIosEnabled,
    required this.paypalAndroidEnabled,
    required this.paypalClientId,
    required this.paypalIosEnabled,
    required this.paypalSecretKey,
    required this.paystackAndroidEnabled,
    required this.paystackIosEnabled,
    required this.paystackPublicKey,
    required this.paystackSecretKey,
    required this.razorpayIosEnabled,
    required this.stripeIosEnabled,
    required this.websiteUrl,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        currency: Currency.fromJson(json["currency"]),
        storage: Storage.fromJson(json["storage"]),
        android: Android.fromJson(json["android"]),
        ios: Android.fromJson(json["ios"]),
        id: json["_id"],
        googlePlaySwitch: json["googlePlaySwitch"],
        stripeSwitch: json["stripeSwitch"],
        stripePublishableKey: json["stripePublishableKey"],
        stripeSecretKey: json["stripeSecretKey"],
        razorPaySwitch: json["razorPaySwitch"],
        razorPayId: json["razorPayId"],
        razorSecretKey: json["razorSecretKey"],
        flutterWaveId: json["flutterWaveId"],
        flutterWaveSwitch: json["flutterWaveSwitch"],
        privacyPolicyLink: json["privacyPolicyLink"],
        termsOfUsePolicyLink: json["termsOfUsePolicyLink"],
        durationOfShorts: json["durationOfShorts"],
        minCoinForCashOut: json["minCoinForCashOut"],
        minWithdrawalRequestedCoin: json["minWithdrawalRequestedCoin"],
        referralRewardCoins: json["referralRewardCoins"],
        watchingVideoRewardCoins: json["watchingVideoRewardCoins"],
        commentingRewardCoins: json["commentingRewardCoins"],
        likeVideoRewardCoins: json["likeVideoRewardCoins"],
        loginRewardCoins: json["loginRewardCoins"],
        maxAdPerDay: json["maxAdPerDay"],
        isGoogle: json["isGoogle"],
        privateKey: PrivateKey.fromJson(json["privateKey"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        freeEpisodesForNonVip: json["freeEpisodesForNonVip"],
        contactEmail: json["contactEmail"],
        resendApiKey: json["resendApiKey"],
        awsAccessKey: json["awsAccessKey"],
        awsBucketName: json["awsBucketName"],
        awsEndpoint: json["awsEndpoint"],
        awsHostname: json["awsHostname"],
        awsRegion: json["awsRegion"],
        awsSecretKey: json["awsSecretKey"],
        doAccessKey: json["doAccessKey"],
        doBucketName: json["doBucketName"],
        doEndpoint: json["doEndpoint"],
        doHostname: json["doHostname"],
        doRegion: json["doRegion"],
        doSecretKey: json["doSecretKey"],
        androidAppLink: json["androidAppLink"],
        androidAppVersion: json["androidAppVersion"],
        iosAppLink: json["iosAppLink"],
        iosAppVersion: json["iosAppVersion"],
        androidAssetLinks: List<AndroidAssetLink>.from(json["androidAssetLinks"].map((x) => AndroidAssetLink.fromJson(x))),
        appleAppSiteAssociation: AppleAppSiteAssociation.fromJson(json["appleAppSiteAssociation"]),
        cashfreeAndroidEnabled: json["cashfreeAndroidEnabled"],
        cashfreeClientId: json["cashfreeClientId"],
        cashfreeClientSecret: json["cashfreeClientSecret"],
        cashfreeIosEnabled: json["cashfreeIosEnabled"],
        flutterwaveIosEnabled: json["flutterwaveIosEnabled"],
        googlePayIosEnabled: json["googlePayIosEnabled"],
        paypalAndroidEnabled: json["paypalAndroidEnabled"],
        paypalClientId: json["paypalClientId"],
        paypalIosEnabled: json["paypalIosEnabled"],
        paypalSecretKey: json["paypalSecretKey"],
        paystackAndroidEnabled: json["paystackAndroidEnabled"],
        paystackIosEnabled: json["paystackIosEnabled"],
        paystackPublicKey: json["paystackPublicKey"],
        paystackSecretKey: json["paystackSecretKey"],
        razorpayIosEnabled: json["razorpayIosEnabled"],
        stripeIosEnabled: json["stripeIosEnabled"],
        websiteUrl: json["websiteUrl"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency.toJson(),
        "storage": storage.toJson(),
        "android": android.toJson(),
        "ios": ios.toJson(),
        "_id": id,
        "googlePlaySwitch": googlePlaySwitch,
        "stripeSwitch": stripeSwitch,
        "stripePublishableKey": stripePublishableKey,
        "stripeSecretKey": stripeSecretKey,
        "razorPaySwitch": razorPaySwitch,
        "razorPayId": razorPayId,
        "razorSecretKey": razorSecretKey,
        "flutterWaveId": flutterWaveId,
        "flutterWaveSwitch": flutterWaveSwitch,
        "privacyPolicyLink": privacyPolicyLink,
        "termsOfUsePolicyLink": termsOfUsePolicyLink,
        "durationOfShorts": durationOfShorts,
        "minCoinForCashOut": minCoinForCashOut,
        "minWithdrawalRequestedCoin": minWithdrawalRequestedCoin,
        "referralRewardCoins": referralRewardCoins,
        "watchingVideoRewardCoins": watchingVideoRewardCoins,
        "commentingRewardCoins": commentingRewardCoins,
        "likeVideoRewardCoins": likeVideoRewardCoins,
        "loginRewardCoins": loginRewardCoins,
        "maxAdPerDay": maxAdPerDay,
        "isGoogle": isGoogle,
        "privateKey": privateKey.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "freeEpisodesForNonVip": freeEpisodesForNonVip,
        "contactEmail": contactEmail,
        "resendApiKey": resendApiKey,
        "awsAccessKey": awsAccessKey,
        "awsBucketName": awsBucketName,
        "awsEndpoint": awsEndpoint,
        "awsHostname": awsHostname,
        "awsRegion": awsRegion,
        "awsSecretKey": awsSecretKey,
        "doAccessKey": doAccessKey,
        "doBucketName": doBucketName,
        "doEndpoint": doEndpoint,
        "doHostname": doHostname,
        "doRegion": doRegion,
        "doSecretKey": doSecretKey,
        "androidAppLink": androidAppLink,
        "androidAppVersion": androidAppVersion,
        "iosAppLink": iosAppLink,
        "iosAppVersion": iosAppVersion,
        "androidAssetLinks": List<dynamic>.from(androidAssetLinks.map((x) => x.toJson())),
        "appleAppSiteAssociation": appleAppSiteAssociation.toJson(),
        "cashfreeAndroidEnabled": cashfreeAndroidEnabled,
        "cashfreeClientId": cashfreeClientId,
        "cashfreeClientSecret": cashfreeClientSecret,
        "cashfreeIosEnabled": cashfreeIosEnabled,
        "flutterwaveIosEnabled": flutterwaveIosEnabled,
        "googlePayIosEnabled": googlePayIosEnabled,
        "paypalAndroidEnabled": paypalAndroidEnabled,
        "paypalClientId": paypalClientId,
        "paypalIosEnabled": paypalIosEnabled,
        "paypalSecretKey": paypalSecretKey,
        "paystackAndroidEnabled": paystackAndroidEnabled,
        "paystackIosEnabled": paystackIosEnabled,
        "paystackPublicKey": paystackPublicKey,
        "paystackSecretKey": paystackSecretKey,
        "razorpayIosEnabled": razorpayIosEnabled,
        "stripeIosEnabled": stripeIosEnabled,
        "websiteUrl": websiteUrl,
      };
}

class Android {
  Google google;

  Android({
    required this.google,
  });

  factory Android.fromJson(Map<String, dynamic> json) => Android(
        google: Google.fromJson(json["google"]),
      );

  Map<String, dynamic> toJson() => {
        "google": google.toJson(),
      };
}

class Google {
  String interstitial;
  String native;
  String reward;

  Google({
    required this.interstitial,
    required this.native,
    required this.reward,
  });

  factory Google.fromJson(Map<String, dynamic> json) => Google(
        interstitial: json["interstitial"],
        native: json["native"],
        reward: json["reward"],
      );

  Map<String, dynamic> toJson() => {
        "interstitial": interstitial,
        "native": native,
        "reward": reward,
      };
}

class AndroidAssetLink {
  List<String> relation;
  Target target;

  AndroidAssetLink({
    required this.relation,
    required this.target,
  });

  factory AndroidAssetLink.fromJson(Map<String, dynamic> json) => AndroidAssetLink(
        relation: List<String>.from(json["relation"].map((x) => x)),
        target: Target.fromJson(json["target"]),
      );

  Map<String, dynamic> toJson() => {
        "relation": List<dynamic>.from(relation.map((x) => x)),
        "target": target.toJson(),
      };
}

class Target {
  String namespace;
  String packageName;
  List<String> sha256CertFingerprints;

  Target({
    required this.namespace,
    required this.packageName,
    required this.sha256CertFingerprints,
  });

  factory Target.fromJson(Map<String, dynamic> json) => Target(
        namespace: json["namespace"],
        packageName: json["package_name"],
        sha256CertFingerprints: List<String>.from(json["sha256_cert_fingerprints"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "namespace": namespace,
        "package_name": packageName,
        "sha256_cert_fingerprints": List<dynamic>.from(sha256CertFingerprints.map((x) => x)),
      };
}

class AppleAppSiteAssociation {
  Applinks applinks;

  AppleAppSiteAssociation({
    required this.applinks,
  });

  factory AppleAppSiteAssociation.fromJson(Map<String, dynamic> json) => AppleAppSiteAssociation(
        applinks: Applinks.fromJson(json["applinks"]),
      );

  Map<String, dynamic> toJson() => {
        "applinks": applinks.toJson(),
      };
}

class Applinks {
  List<dynamic> apps;
  List<Detail> details;

  Applinks({
    required this.apps,
    required this.details,
  });

  factory Applinks.fromJson(Map<String, dynamic> json) => Applinks(
        apps: List<dynamic>.from(json["apps"].map((x) => x)),
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "apps": List<dynamic>.from(apps.map((x) => x)),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  String appId;
  List<String> paths;

  Detail({
    required this.appId,
    required this.paths,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        appId: json["appID"],
        paths: List<String>.from(json["paths"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "appID": appId,
        "paths": List<dynamic>.from(paths.map((x) => x)),
      };
}

class Currency {
  String name;
  String symbol;
  String countryCode;
  String currencyCode;
  bool isDefault;

  Currency({
    required this.name,
    required this.symbol,
    required this.countryCode,
    required this.currencyCode,
    required this.isDefault,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        name: json["name"],
        symbol: json["symbol"],
        countryCode: json["countryCode"],
        currencyCode: json["currencyCode"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "countryCode": countryCode,
        "currencyCode": currencyCode,
        "isDefault": isDefault,
      };
}

class PrivateKey {
  String type;
  String projectId;
  String privateKeyId;
  String privateKey;
  String clientEmail;
  String clientId;
  String authUri;
  String tokenUri;
  String authProviderX509CertUrl;
  String clientX509CertUrl;
  String universeDomain;

  PrivateKey({
    required this.type,
    required this.projectId,
    required this.privateKeyId,
    required this.privateKey,
    required this.clientEmail,
    required this.clientId,
    required this.authUri,
    required this.tokenUri,
    required this.authProviderX509CertUrl,
    required this.clientX509CertUrl,
    required this.universeDomain,
  });

  factory PrivateKey.fromJson(Map<String, dynamic> json) => PrivateKey(
        type: json["type"],
        projectId: json["project_id"],
        privateKeyId: json["private_key_id"],
        privateKey: json["private_key"],
        clientEmail: json["client_email"],
        clientId: json["client_id"],
        authUri: json["auth_uri"],
        tokenUri: json["token_uri"],
        authProviderX509CertUrl: json["auth_provider_x509_cert_url"],
        clientX509CertUrl: json["client_x509_cert_url"],
        universeDomain: json["universe_domain"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "project_id": projectId,
        "private_key_id": privateKeyId,
        "private_key": privateKey,
        "client_email": clientEmail,
        "client_id": clientId,
        "auth_uri": authUri,
        "token_uri": tokenUri,
        "auth_provider_x509_cert_url": authProviderX509CertUrl,
        "client_x509_cert_url": clientX509CertUrl,
        "universe_domain": universeDomain,
      };
}

class Storage {
  bool awsS3;
  bool digitalOcean;
  bool local;

  Storage({
    required this.awsS3,
    required this.digitalOcean,
    required this.local,
  });

  factory Storage.fromJson(Map<String, dynamic> json) => Storage(
        awsS3: json["awsS3"],
        digitalOcean: json["digitalOcean"],
        local: json["local"],
      );

  Map<String, dynamic> toJson() => {
        "awsS3": awsS3,
        "digitalOcean": digitalOcean,
        "local": local,
      };
}

import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4641579323652872~3139994033";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4641579323652872~3139994033";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId_HomePage {
    if (Platform.isAndroid) {
      return "ca-app-pub-4641579323652872/9600287144";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4641579323652872/9600287144";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId_Subcategories {
    if (Platform.isAndroid) {
      return "ca-app-pub-4641579323652872/4427851510";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4641579323652872/4427851510";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId_Tags {
    if (Platform.isAndroid) {
      return "ca-app-pub-4641579323652872/7660519515";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4641579323652872/7660519515";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4641579323652872/7245941767";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4641579323652872/7245941767";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2698325959262993/7303294855";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2698325959262993/7303294855";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

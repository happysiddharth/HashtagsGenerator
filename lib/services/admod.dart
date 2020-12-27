import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7353181874904121~9156964823";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7353181874904121~9156964823";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId_HomePage {
    if (Platform.isAndroid) {
      return "ca-app-pub-7353181874904121/4076044449";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7353181874904121/4076044449";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId_Subcategories {
    if (Platform.isAndroid) {
      return "ca-app-pub-7353181874904121/6107311413";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7353181874904121/6107311413";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId_Tags {
    if (Platform.isAndroid) {
      return "ca-app-pub-7353181874904121/1278474804";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7353181874904121/1278474804";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7353181874904121/5197554425";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7353181874904121/5197554425";
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

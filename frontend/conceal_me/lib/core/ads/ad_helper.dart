import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static RewardedAd? _rewardedAd;
  static InterstitialAd? _interstitialAd;
  static bool _isRewardedAdLoaded = false;
  static bool _isInterstitialAdLoaded = false;

  static Future<void> initializeAdMob() async {
    await MobileAds.instance.initialize();
    await loadRewardedAd();
    await loadInterstitialAd();
  }

  // ----------- Rewarded Ad -------------
  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _getRewardedAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
          debugPrint('Rewarded ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Failed to load rewarded ad: $error');
          _rewardedAd = null;
          _isRewardedAdLoaded = false;
        },
      ),
    );
  }

  static void showRewardedAd({
    required VoidCallback onAdCompleted,
    VoidCallback? onAdFailed,
  }) {
    if (_isRewardedAdLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadRewardedAd();
          onAdFailed?.call();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('Reward earned: ${reward.amount} ${reward.type}');
          onAdCompleted();
        },
      );

      _rewardedAd = null;
      _isRewardedAdLoaded = false;
    } else {
      debugPrint('Rewarded ad not ready');
      onAdFailed?.call();
    }
  }

  // ----------- Interstitial Ad -------------
  static Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Failed to load interstitial ad: $error');
          _interstitialAd = null;
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  static void showInterstitialAd({
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailed,
  }) {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
          onAdDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
          onAdFailed?.call();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdLoaded = false;
    } else {
      debugPrint('Interstitial ad not ready');
      onAdFailed?.call();
    }
  }

  // ----------- Banner Ad Widget -------------
  static BannerAd createBannerAd({
    AdSize size = AdSize.banner,
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  // ----------- Test Ad Unit IDs -------------
  static String _getRewardedAdUnitId() =>
      'ca-app-pub-3940256099942544/5224354917';

  static String _getInterstitialAdUnitId() =>
      'ca-app-pub-3940256099942544/1033173712';

  static String _getBannerAdUnitId() =>
      'ca-app-pub-3940256099942544/6300978111';
}

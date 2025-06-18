import 'package:conceal_me/core/theme/app_palette.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/ads/ad_helper.dart';
import '../../../../core/services/hive/models/vpn_history.dart';

class VpnHistoryPage extends StatefulWidget {
  const VpnHistoryPage({super.key});

  @override
  State<VpnHistoryPage> createState() => _VpnHistoryPageState();
}

class _VpnHistoryPageState extends State<VpnHistoryPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = AdHelper.createBannerAd(
      onAdLoaded: (ad) {
        setState(() {
          _isBannerAdReady = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('BannerAd failed to load: $error');
      },
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<VpnHistory>('vpnHistoryBox');

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<VpnHistory>>(
              valueListenable: historyBox.listenable(),
              builder: (context, box, _) {
                final histories = box.values.toList().reversed.toList();

                if (histories.isEmpty) {
                  return const Center(child: Text('No VPN history yet.'));
                }

                return ListView.builder(
                  itemCount: histories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Country',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Duration',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_circle_down,
                                        size: 18,
                                        color: AppPalette.primaryColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'KB',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_circle_up,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'KB',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    }

                    final history = histories[index - 1];
                    final bytesInKbs = (history.bytesIn / 1000).toStringAsFixed(
                      2,
                    );
                    final bytesOutKbs = (history.bytesOut / 1000)
                        .toStringAsFixed(2);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: CountryFlag.fromCountryCode(
                                history.country,
                                height: 40,
                                width: 60,
                                shape: RoundedRectangle(8),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                history.duration,
                                style: const TextStyle(fontSize: 15.0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                bytesInKbs,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppPalette.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                bytesOutKbs,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// BANNER AD
          if (_isBannerAdReady)
            SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }
}

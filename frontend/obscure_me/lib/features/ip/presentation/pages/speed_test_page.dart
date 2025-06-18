import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';
import 'package:obscure_me/core/theme/app_palette.dart';
import 'package:obscure_me/features/ip/presentation/widgets/speed_test/speed_gauge_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../widgets/speed_test/loading_widget.dart';
import '../widgets/speed_test/network_component_card.dart';
import '../widgets/speed_test/result_widget.dart';
import '../widgets/speed_test/run_test_widget.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final _internetSpeedTest = FlutterInternetSpeedTest();
  final PageController _pageController = PageController();

  double _downloadRate = 0;
  double _uploadRate = 0;
  double _finalDownloadRate = 0;
  double _finalUploadRate = 0;

  double _downloadProgress = 0.0;
  double _uploadProgress = 0.0;
  String? _ip;

  String? _city;

  String? _country;
  String? _isp;
  String? _asn;
  String _unit = 'Mbps';

  bool _isServerSelectionInProgress = false;
  bool _hasTestStarted = false;
  bool _isTestComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speed Test')),
      body: speedTestBody(),
    );
  }

  Widget speedTestBody() {
    if (!_hasTestStarted) return RunTestWidget(onTap: startTest);

    if (_isServerSelectionInProgress) return const LoadingWidget();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_isTestComplete ? finalResult() : pageView()],
      ),
    );
  }

  Widget pageView() {
    return SizedBox(
      height: 800,
      width: 800,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          inProgressView(
            label: "Download",
            value: _downloadRate,
            color: AppPalette.primaryColor,
            isDownload: true,
          ),
          inProgressView(
            label: "Upload",
            value: _uploadRate,
            color: Colors.orange,
            isDownload: false,
          ),
        ],
      ),
    );
  }

  Widget inProgressView({
    required String label,
    required double value,
    required Color color,
    required bool isDownload,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8.0,
      children: [
        // Header
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
        // Progress
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 20.0,
              percent: isDownload ? _downloadProgress : _uploadProgress,
              center: Text(
                isDownload
                    ? '${(_downloadProgress * 100).toStringAsFixed(1)}%'
                    : '${(_uploadProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white),
              ),
              restartAnimation: false,
              addAutomaticKeepAlive: false,
              animateFromLastPercent: true,
              animateToInitialPercent: false,
              barRadius: const Radius.circular(16),
              progressColor:
                  isDownload ? AppPalette.primaryColor : Colors.orange,
              backgroundColor: AppPalette.greyOpacityColor,
            ),
          ),
        ),
        // Speed Gauge
        Flexible(
          flex: 3,
          child: SpeedGaugeWidget(
            value: value,
            unit: _unit,
            color: color,
            isDownload: isDownload,
          ),
        ),
        // Network Details
        Flexible(
          child: Wrap(
            spacing: 16.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: [
              NetworkComponentCard(
                title: 'IP Address',
                subTitle: _ip ?? 'Unknown IP',
                icon: Icon(Icons.location_on_rounded, color: color,size: 20,),
              ),
              NetworkComponentCard(
                title: 'ISP',
                subTitle: _isp ?? 'Unknown ISP',
                icon: Icon(Icons.language, color: color,size: 20,),
              ),
              NetworkComponentCard(
                title: 'Location',
                subTitle:
                    '${_city ?? 'Unknown City'}, ${_country ?? 'Unknown Country'}',
                icon: Icon(CupertinoIcons.location_fill, color: color,size: 20,),
              ),
              NetworkComponentCard(
                title: 'ASN',
                subTitle: _asn ?? 'Unknown ASN',
                icon: Icon(Icons.numbers, color: color,size: 20,),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget finalResult() {
    return Column(
      children: [
        ResultWidget(
          downloadRate: _finalDownloadRate,
          uploadRate: _finalUploadRate,
          unit: _unit,
        ),
        const SizedBox(height: 40),
        RunTestWidget(
          onTap: () async {
            await resetTest();
            startTest();
          },
        ),
      ],
    );
  }

  void startTest() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _hasTestStarted = true;
        _isTestComplete = false;
      });

      await _internetSpeedTest.startTesting(
        useFastApi: true,
        onCompleted: (download, upload) {
          setState(() {
            _isTestComplete = true;
            _finalDownloadRate = double.parse(
              (download.transferRate).toStringAsPrecision(3),
            );
            _finalUploadRate = double.parse(
              (upload.transferRate).toStringAsPrecision(3),
            );
          });
        },
        onProgress: (percent, data) {
          setState(() {
            if (data.type == TestType.download) {
              _downloadProgress = percent / 100;
              _downloadRate = double.parse(
                (data.transferRate).toStringAsPrecision(3),
              );
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
              );
            } else {
              _uploadProgress = percent / 100;
              _uploadRate = double.parse(
                (data.transferRate).toStringAsPrecision(3),
              );
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
              );
            }
          });
        },
        onDefaultServerSelectionInProgress: () {
          setState(() => _isServerSelectionInProgress = true);
        },
        onDefaultServerSelectionDone: (client) {
          setState(() {
            _isServerSelectionInProgress = false;
            _ip = client?.ip;
            _city = client?.location?.city;
            _country = client?.location?.country;
            _isp = client?.isp;
            _asn = client?.asn;
          });
        },
        onError: (_, __) async => await resetTest(),
        onCancel: () async => await resetTest(),
      );
    });
  }

  Future<void> resetTest() async {
    // internetSpeedTest.isTestInProgress()
    //     ? await internetSpeedTest.cancelTest()
    //     : startTest();
    setState(() {
      _downloadRate = 0;
      _uploadRate = 0;
      _finalDownloadRate = 0;
      _finalUploadRate = 0;
      _unit = 'Mbps';
      _ip = null;
      _hasTestStarted = false;
      _isTestComplete = false;
      _isServerSelectionInProgress = false;
      _downloadProgress = 0.0;
      _uploadProgress = 0.0;
    });
  }
}

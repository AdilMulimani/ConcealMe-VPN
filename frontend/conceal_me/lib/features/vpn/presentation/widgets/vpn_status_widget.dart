import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class VpnStatusWidget extends StatefulWidget {
  const VpnStatusWidget({super.key, required this.status});

  final VpnStatus? status;

  @override
  State<VpnStatusWidget> createState() => _VpnStatusWidgetState();
}

class _VpnStatusWidgetState extends State<VpnStatusWidget> {
  static const _backgroundColor = Colors.black;

  static const _colors = [Colors.orange, Colors.orangeAccent];

  static const _durations = [10000, 8000];

  // static const _heightPercentages = [0.55, 0.66];
  static const _heightPercentages = [.99, .99];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24.0,
          children: [
            // Upload
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_up, size: 24.0),
                    SizedBox(width: 4.0),
                    Text(
                      'Upload',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Container(
                  width: 156,
                  height: 95,
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        WaveWidget(
                          config: CustomConfig(
                            colors: _colors,
                            durations: _durations,
                            heightPercentages: _heightPercentages,
                          ),
                          backgroundColor: _backgroundColor,
                          size: Size(156, 95),
                          waveAmplitude: 0,
                        ),
                        Positioned(
                          left: 10,
                          top: 8,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '32.3',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                TextSpan(text: ' '),
                                TextSpan(
                                  text: 'Mbps',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Download
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_down, size: 24.0),
                    SizedBox(width: 4.0),
                    Text(
                      'Download',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Container(
                  width: 156,
                  height: 95,
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        WaveWidget(
                          config: CustomConfig(
                            colors: _colors,
                            durations: _durations,
                            heightPercentages: _heightPercentages,
                          ),
                          backgroundColor: _backgroundColor,
                          size: Size(156, 95),
                          waveAmplitude: 0,
                        ),
                        Positioned(
                          left: 10,
                          top: 8,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '32.3',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                TextSpan(text: ' '),
                                TextSpan(
                                  text: 'Mbps',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

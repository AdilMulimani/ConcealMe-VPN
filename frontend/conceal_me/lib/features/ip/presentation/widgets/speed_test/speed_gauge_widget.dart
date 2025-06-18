import 'package:conceal_me/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class SpeedGaugeWidget extends StatelessWidget {
  const SpeedGaugeWidget({
    super.key,
    required this.value,
    required this.unit,
    required this.color,
    required this.isDownload,
  });

  final double value;
  final String unit;
  final Color color;

  final bool isDownload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: color.withAlpha(50),
              shape: CircleBorder(),
            ),
            child: RadialGauge(
              valueBar: [
                RadialValueBar(
                  value: value.clamp(0, 100),
                  color: color,
                  valueBarThickness: 20,
                ),
              ],
              needlePointer: [
                NeedlePointer(
                  value: value.clamp(0, 100),
                  needleWidth: 10,
                  tailRadius: 20,
                  needleStyle: NeedleStyle.gaugeNeedle,
                  needleHeight: 80,
                  color: color,
                  tailColor: color,
                ),
              ],
              radiusFactor: 1,
              track: RadialTrack(
                start: 0,
                end: 100,
                steps: 10,
                color: AppPalette.greyOpacityColor,
                thickness: 20,
                trackLabelFormater: (p0) => '${p0.toInt()}',
                trackStyle: const TrackStyle(
                  showLabel: true,
                  showPrimaryRulers: true,
                  primaryRulerColor: Colors.grey,
                  showSecondaryRulers: false,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.38,
            top: MediaQuery.sizeOf(context).height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Row(
                  spacing: 2.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDownload
                          ? Icons.arrow_circle_down
                          : Icons.arrow_circle_up,
                      color: color,
                      size: 26.0,
                    ),
                    Text(
                      'Mbps',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

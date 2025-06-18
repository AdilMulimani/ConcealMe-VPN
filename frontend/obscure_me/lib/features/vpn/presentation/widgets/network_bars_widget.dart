import 'package:flutter/material.dart';
import 'package:obscure_me/core/theme/app_palette.dart';

class NetworkSpeedBars extends StatelessWidget {
  final String speed; // Speed from server

  const NetworkSpeedBars({super.key, required this.speed});

  // Function to extract numeric speed in Mbps
  double _parseSpeed() {
    if (speed.contains("Gbps")) {
      return double.parse(speed.replaceAll(" Gbps", "")) *
          1000; // Convert to Mbps
    } else if (speed.contains("Mbps")) {
      return double.parse(speed.replaceAll(" Mbps", ""));
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    double parsedSpeed = _parseSpeed(); // Convert speed to Mbps

    // Determine how many bars should be blue based on speed
    int activeBars;
    if (parsedSpeed < 100) {
      activeBars = 1;
    } else if (parsedSpeed < 400) {
      activeBars = 2;
    } else if (parsedSpeed < 1000) {
      activeBars = 3;
    } else {
      activeBars = 4;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBar(
          8,
          activeBars >= 1 ? AppPalette.primaryColor : AppPalette.greyColor,
        ),
        SizedBox(width: 2),
        _buildBar(
          11,
          activeBars >= 2 ? AppPalette.primaryColor : AppPalette.greyColor,
        ),
        SizedBox(width: 2),
        _buildBar(
          14,
          activeBars >= 3 ? AppPalette.primaryColor : AppPalette.greyColor,
        ),
        SizedBox(width: 2),
        _buildBar(
          18,
          activeBars >= 4 ? AppPalette.primaryColor : AppPalette.greyColor,
        ),
      ],
    );
  }

  // Widget for individual bars
  Widget _buildBar(double height, Color color) {
    return Container(height: height, width: 4, color: color);
  }
}

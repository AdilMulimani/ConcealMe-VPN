import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class NetworkTestCard extends StatelessWidget {
  const NetworkTestCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.suffixButton,
  });
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  final Widget suffixButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppPalette.darkBlueBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        spacing: 8.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 12.0,
            children: [
              Icon(icon, color: iconColor, size: 24.0),
              Column(
                spacing: 2.0,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(value),
                ],
              ),
            ],
          ),
          Flexible(child: suffixButton),
        ],
      ),
    );
  }
}

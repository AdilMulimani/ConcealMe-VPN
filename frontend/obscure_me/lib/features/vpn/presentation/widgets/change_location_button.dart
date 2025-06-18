import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class ChangeLocationButton extends StatelessWidget {
  const ChangeLocationButton({
    super.key,
    required this.onPressed,
    required this.isConnected,
  });

  final VoidCallback onPressed;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isConnected ? AppPalette.primaryColor : Colors.orange,
        side: BorderSide(
          color: isConnected ? AppPalette.primaryColor : Colors.orange,
        ),
      ),
      child: Text('Change Location', style: TextStyle(fontSize: 18.0)),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        overlayColor: AppPalette.greyOpacityColor,
      ),
      onPressed: onPressed,
      child: Text(
        'Forgot your Password?',
        style: TextStyle(
          color: AppPalette.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

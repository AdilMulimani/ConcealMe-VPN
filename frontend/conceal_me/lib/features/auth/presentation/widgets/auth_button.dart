import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
  });
  final VoidCallback onPressed;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.primaryColor,
        elevation: 4,
        overlayColor: AppPalette.primaryColor,
        shadowColor: AppPalette.primaryColor,
        minimumSize: Size(double.infinity, 60),
      ),
      child: Text(
        buttonName,
        style: TextStyle(
          color: AppPalette.whiteColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

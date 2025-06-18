import 'package:conceal_me/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        header,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppPalette.whiteColor,
        ),
      ),
    );
  }
}

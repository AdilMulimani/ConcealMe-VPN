import 'package:flutter/material.dart';
import 'package:obscure_me/core/theme/app_palette.dart';

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

import 'package:flutter/material.dart';

class AuthShield extends StatelessWidget {
  const AuthShield({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/shield.png',
        height: 160,
        width: 160,
        fit: BoxFit.cover,
      ),
    );
  }
}

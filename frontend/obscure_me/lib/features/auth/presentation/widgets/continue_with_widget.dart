import 'package:flutter/material.dart';
import 'package:obscure_me/core/theme/app_palette.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Divider()),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'or continue with',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppPalette.whiteColor,
              ),
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

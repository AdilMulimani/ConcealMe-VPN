import 'package:conceal_me/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class RunTestWidget extends StatelessWidget {
  const RunTestWidget({super.key, required this.onTap});

  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(400),
        child: Container(
          width: 250.0,
          height: 250.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(400),
            border: Border.all(
              //color: Colors.cyanAccent,
              color: AppPalette.primaryColor,
              width: 15.0,
            ),
          ),
          child: const Center(
            child: Text(
              'GO',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class OtpTimer extends StatefulWidget {
  const OtpTimer({super.key, required this.resendCode});
  final VoidCallback resendCode;

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int _seconds = 60;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      _seconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _seconds > 0
        ? Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Resend code in\t',
                style: TextStyle(fontSize: 16.0, color: AppPalette.whiteColor),
              ),
              TextSpan(
                text: '$_seconds\t',
                style: const TextStyle(
                  color: AppPalette.primaryColor,
                  fontSize: 16.0,
                ),
              ),
              const TextSpan(
                text: 's',
                style: TextStyle(fontSize: 16.0, color: AppPalette.whiteColor),
              ),
            ],
          ),
        )
        : TextButton(
          onPressed: () {
            widget.resendCode();
            startTimer();
          },
          child: const Text(
            'Resend OTP',
            style: TextStyle(color: AppPalette.primaryColor, fontSize: 16.0),
          ),
        );
  }
}

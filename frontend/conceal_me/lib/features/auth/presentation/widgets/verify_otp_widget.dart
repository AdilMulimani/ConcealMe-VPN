import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/obscure_email.dart';
import 'auth_button.dart';
import 'otp_timer.dart';

class VerifyOtpWidget extends StatelessWidget {
  VerifyOtpWidget({
    super.key,
    required this.isSignUpVerification,
    required this.onVerifyPressed,
    required this.onResendCodePressed,
    required this.formKey,
    required this.otpController,
  });
  final bool isSignUpVerification;

  final VoidCallback onVerifyPressed;

  final VoidCallback onResendCodePressed;

  final GlobalKey<FormState> formKey;

  final TextEditingController otpController;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppPalette.whiteColor,
    ),
    decoration: BoxDecoration(
      color: AppPalette.greyOpacityColor,
      border: Border.all(width: 2, color: AppPalette.greyColor.withAlpha(100)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppPalette.whiteColor,
    ),
    decoration: BoxDecoration(
      color: AppPalette.blueOpacityColor,
      border: Border.all(width: 2, color: AppPalette.primaryColor),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final submittedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppPalette.whiteColor,
    ),
    decoration: BoxDecoration(
      color: AppPalette.blueOpacityColor,
      border: Border.all(width: 2, color: AppPalette.primaryColor),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: formKey,
        child: Column(
          spacing: 24.0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            //Text
            Center(
              child: Text(
                'OTP has been sent to ${obscureEmail(email!)}',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            //Pinput
            Pinput(
              controller: otpController,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              pinAnimationType: PinAnimationType.slide,
              validator: (value) {
                if (value == null) {
                  return 'OTP is a required field';
                } else if (value.isEmpty) {
                  return 'OTP is a required field';
                } else if (value.length < 4) {
                  return 'OTP is a 4 digit pin';
                }
                return null;
              },
            ),
            //Resend code in
            !isSignUpVerification
                ? OtpTimer(resendCode: onResendCodePressed)
                : SizedBox.shrink(),
            //Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: AuthButton(
                    onPressed: onVerifyPressed,
                    buttonName: 'Verify',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

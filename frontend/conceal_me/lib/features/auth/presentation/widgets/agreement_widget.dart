import 'package:conceal_me/features/auth/presentation/widgets/terms_and_conditions_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AgreementWidget extends StatelessWidget {
  const AgreementWidget({
    super.key,
    required this.value,
    required this.onAgreed,
    required this.onDisagreed,
    required this.onChanged,
  });
  final bool value;
  final VoidCallback onAgreed;
  final VoidCallback onDisagreed;

  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          checkColor: AppPalette.whiteColor,
          activeColor: AppPalette.primaryColor,
          side: BorderSide(width: 2, color: AppPalette.primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          onChanged: onChanged,
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 16),
            children: [
              TextSpan(
                text: 'I agree to the\t',
                style: TextStyle(color: AppPalette.whiteColor),
              ),
              TextSpan(
                text: 'Terms & Conditions.',
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        showTermsAndConditionsDialog(
                          context: context,
                          onAgreed: onAgreed,
                          onDisagreed: onDisagreed,
                        );
                      },
                style: TextStyle(
                  color: AppPalette.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

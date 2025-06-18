import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

Future<bool?> showTermsAndConditionsDialog({
  required BuildContext context,
  required VoidCallback onAgreed,
  required VoidCallback onDisagreed,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevents closing without action
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "1. No Illegal Activity: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "You shall not use this VPN for hacking, fraud, or any unlawful activities.\n\n",
                      ),
                      TextSpan(
                        text: "2. No Log Policy: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "We do not store or track any logs of your internet activity.\n\n",
                      ),
                      TextSpan(
                        text: "3. Data Privacy: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "While we use encryption, we cannot guarantee absolute privacy.\n\n",
                      ),
                      TextSpan(
                        text: "4. Service Availability: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "We are not responsible for connection issues caused by ISPs or other third parties.\n\n",
                      ),
                      TextSpan(
                        text: "5. Third-Party Services: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "The VPN may interact with third-party services, and we are not responsible for their policies.\n\n",
                      ),
                      TextSpan(
                        text: "6. Termination of Service: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "We reserve the right to suspend your access if you violate these terms.\n\n",
                      ),
                      TextSpan(
                        text: "7. Use at Your Own Risk: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "We are not liable for any damage, data loss, or legal issues arising from VPN usage.\n\n",
                      ),
                      TextSpan(
                        text: "By clicking ",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      TextSpan(
                        text: "'Agree'",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            " you confirm that you have read and understood these terms.",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: onDisagreed,
            child: const Text(
              "Disagree",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onAgreed,
            child: const Text(
              "Agree",
              style: TextStyle(
                color: AppPalette.primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

import 'package:conceal_me/features/ip/presentation/widgets/speed_test/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_test_plus/src/models/server_selection_response.dart';

import '../../../../../core/theme/app_palette.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.downloadRate,
    required this.uploadRate,
    required this.unit,
    Client? clientInfo,
  });

  final double downloadRate;
  final double uploadRate;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpaceWidget(),
        const Text(
          'Result',
          style: TextStyle(
            color: AppPalette.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        const SpaceWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  spacing: 6.0,
                  children: [
                    const Icon(
                      Icons.arrow_circle_down_rounded,
                      color: AppPalette.primaryColor,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'DOWNLOAD ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: unit),
                        ],
                      ),
                    ),
                  ],
                ),
                const SpaceWidget(),
                Text(
                  downloadRate == 0 ? '...' : downloadRate.toString(),
                  style: const TextStyle(fontSize: 32.0),
                ),
              ],
            ),
            const SizedBox(height: 60.0, child: VerticalDivider()),
            Column(
              children: [
                Row(
                  spacing: 6.0,
                  children: [
                    const Icon(
                      Icons.arrow_circle_up_rounded,
                      color: Colors.orange,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'UPLOAD ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: unit),
                        ],
                      ),
                    ),
                  ],
                ),
                const SpaceWidget(),
                Text(
                  uploadRate == 0 ? '...' : uploadRate.toString(),
                  style: const TextStyle(fontSize: 32.0),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

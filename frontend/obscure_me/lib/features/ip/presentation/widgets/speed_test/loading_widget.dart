import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/custom_loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoadingIndicator(),
          SizedBox(height: 16.0),
          Text('Selecting Server...'),
        ],
      ),
    );
  }
}

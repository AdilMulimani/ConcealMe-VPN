import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../blocs/lock_pattern_bloc/lock_pattern_bloc.dart';
import '../widgets/lock_pattern.dart';

class LockPatternPage extends StatefulWidget {
  const LockPatternPage({super.key});

  @override
  State<LockPatternPage> createState() => _LockPatternPageState();
}

class _LockPatternPageState extends State<LockPatternPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Your Lock Pattern',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<LockPatternBloc, LockPatternState>(
        listener: (context, state) {
          if (state is LockPatternSuccess) {
            showToast(
              type: ToastificationType.success,
              description: state.message,
            );
            context.go('/vpn-home-page'); // Redirect only on success
          } else if (state is LockPatternFailure) {
            showToast(
              type: ToastificationType.error, // Corrected error toast
              description: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is LockPatternLoading) {
            return const CustomLoadingIndicator();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your passcode',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                LockPattern(
                  onEntered: (inputPattern) {
                    debugPrint('Page Entered Pattern $inputPattern');
                    context.read<LockPatternBloc>().add(
                      LockPatternVerification(pattern: List.from(inputPattern)),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

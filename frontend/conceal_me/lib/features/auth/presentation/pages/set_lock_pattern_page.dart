import 'package:conceal_me/core/common/widgets/custom_loading_indicator.dart';
import 'package:conceal_me/core/common/widgets/toast.dart';
import 'package:conceal_me/features/auth/presentation/blocs/lock_pattern_bloc/lock_pattern_bloc.dart';
import 'package:conceal_me/features/auth/presentation/widgets/lock_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class SetLockPatternPage extends StatefulWidget {
  const SetLockPatternPage({super.key});

  @override
  State<SetLockPatternPage> createState() => _SetLockPatternPageState();
}

class _SetLockPatternPageState extends State<SetLockPatternPage> {
  List<int>? _pattern;
  bool _isConfirming = false;

  Future<void> _onPatternEntered(List<int> inputPattern) async {
    if (inputPattern.length < 4) {
      showToast(
        type: ToastificationType.error,
        description: 'Pattern must be at least 4 dots',
      );
      return;
    }

    if (!_isConfirming) {
      // First pattern entry
      setState(() {
        _pattern = List.from(inputPattern);
        _isConfirming = true;
      });
      showToast(
        type: ToastificationType.info,
        description: 'Re-enter pattern to confirm',
      );
    } else {
      // Confirm pattern entry
      if (listEquals(_pattern, inputPattern)) {
        context.read<LockPatternBloc>().add(
          LockPatternSetup(pattern: _pattern!),
        );
      } else {
        showToast(
          type: ToastificationType.error,
          description: 'Patterns do not match. Try again.',
        );
      }
      setState(() {
        _pattern = null;
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Your Lock Pattern',
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
            context.go('/vpn-home-page');
          } else if (state is LockPatternFailure) {
            showToast(
              type: ToastificationType.success,
              description: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is LockPatternLoading) {
            return CustomLoadingIndicator();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isConfirming
                      ? 'Confirm new passcode'
                      : 'Draw a new passcode',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                LockPattern(onEntered: _onPatternEntered),
              ],
            ),
          );
        },
      ),
    );
  }
}

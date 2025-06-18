import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:obscure_me/core/common/widgets/toast.dart';
import 'package:obscure_me/core/routes/app_routes.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/theme/app_palette.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? resetPasswordToken =
        GoRouterState.of(context).extra as String?;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Create New Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthResetPasswordSuccess) {
            //show dialog
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      spacing: 12.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/success.png',
                          fit: BoxFit.cover,
                          height: 200,
                          alignment: Alignment.center,
                        ),
                        Text(
                          'Congratulations!',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.primaryColor,
                          ),
                        ),
                        Text(
                          'Password was reset successfully',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppPalette.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AuthButton(
                            onPressed: () {
                              context.go(AppRoutes.signIn);
                            },
                            buttonName: 'Go to Login Page',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AuthResetPasswordFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.error)));
            showToast(type: ToastificationType.error, description: state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoadingIndicator();
          }
          return OrientationBuilder(
            builder: (context, orientation) {
              bool isPortrait = orientation == Orientation.portrait;
              return SafeArea(
                child: Form(
                  key: key,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        isPortrait
                            ? Column(
                              spacing: 24.0,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image
                                Center(
                                  child: Image.asset(
                                    'assets/images/acknowledged.png',
                                  ),
                                ),
                                // Text
                                Text(
                                  'Your new password must be different from the previous used passwords',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                                //Password field
                                AuthField(
                                  obscureText: true,
                                  textEditingController: passwordController,
                                  hintText: 'New Password',
                                  validator: (password) {
                                    if (password == null || password.isEmpty) {
                                      return 'New Password is a required field';
                                    } else if (!RegExp(
                                      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                                    ).hasMatch(password)) {
                                      return 'Password must be at least 8 characters, include a capital letter, a number, and a special symbol';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.lock,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                ),
                                // Confirm Password field
                                AuthField(
                                  obscureText: true,
                                  textEditingController:
                                      confirmPasswordController,
                                  hintText: 'Confirm New Password',
                                  validator: (password) {
                                    if (password == null || password.isEmpty) {
                                      return 'Confirm New Password is a required field';
                                    } else if (!RegExp(
                                      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                                    ).hasMatch(password)) {
                                      return 'Password must be at least 8 characters, include a capital letter, a number, and a special symbol';
                                    } else if (password !=
                                        passwordController.text.trim()) {
                                      return 'New Password and Confirm New Password must be same.';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.lock,
                                  textInputAction: TextInputAction.go,
                                  textInputType: TextInputType.text,
                                ),
                                //Button
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: AuthButton(
                                        onPressed: () async {
                                          key.currentState!.validate()
                                              ? context.read<AuthBloc>().add(
                                                AuthResetPassword(
                                                  resetPasswordToken:
                                                      resetPasswordToken!,
                                                  password:
                                                      passwordController.text
                                                          .trim(),
                                                ),
                                              )
                                              : null;
                                        },
                                        buttonName: 'Continue',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Row(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

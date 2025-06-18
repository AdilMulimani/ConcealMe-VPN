import 'package:conceal_me/core/common/widgets/toast.dart';
import 'package:conceal_me/core/routes/app_routes.dart';
import 'package:conceal_me/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            showToast(
              type: ToastificationType.success,
              description: state.message,
            );
            context.push(
              AppRoutes.verifyResetOtp,
              extra: emailController.text.trim(),
            );
          } else if (state is AuthForgotPasswordFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            showToast(
              type: ToastificationType.error,
              description: state.message,
            );
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
                              spacing: 16.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                Center(
                                  child: Image.asset(
                                    'assets/images/locked.png',
                                  ),
                                ),
                                // Text
                                Text(
                                  'Please enter your email and we will send an OTP code in the next step to reset the password.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                                //Email field
                                AuthField(
                                  textEditingController: emailController,
                                  hintText: 'Email',
                                  validator: (email) {
                                    if (email == null || email.isEmpty) {
                                      return 'Email is a required field';
                                    } else if (!validator.isEmail(email)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.email,
                                  textInputAction: TextInputAction.go,
                                  textInputType: TextInputType.emailAddress,
                                ),
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
                                                AuthForgotPassword(
                                                  email:
                                                      emailController.text
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:obscure_me/core/common/widgets/toast.dart';
import 'package:obscure_me/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/routes/app_routes.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_company_widget.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_shield.dart';
import '../widgets/continue_with_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            showToast(
              type: ToastificationType.error,
              description: state.message,
            );
          } else if (state is AuthSuccess) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.user.name)));
            showToast(
              type: ToastificationType.success,
              description: state.user.name,
            );
            context.go(AppRoutes.vpnHome);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoadingIndicator();
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthShield(),
                      //Top texts
                      AuthHeader(header: 'Login to your Account'),
                      //Auth fields
                      // Email
                      AuthField(
                        prefixIcon: Icons.email,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Email is a required field';
                          } else if (!validator.isEmail(email)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        hintText: 'Email',
                      ),
                      //Password
                      AuthField(
                        obscureText: true,
                        prefixIcon: Icons.lock,
                        textInputAction: TextInputAction.go,
                        textInputType: TextInputType.text,
                        textEditingController: _passwordController,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Password is a required field';
                          } else if (!RegExp(
                            r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                          ).hasMatch(password)) {
                            return 'Password must be at least 8 characters, include a capital letter, a number, and a special symbol';
                          }
                          return null;
                        },
                        hintText: 'Password',
                      ),
                      //Login Button
                      AuthButton(
                        onPressed: () {
                          _formKey.currentState!.validate()
                              ? context.read<AuthBloc>().add(
                                AuthSignIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              )
                              : null;
                        },
                        buttonName: 'Sign in',
                      ),
                      //Forgot password text
                      Center(
                        child: ForgotPasswordButton(
                          onPressed: () {
                            context.push(AppRoutes.forgotPassword);
                          },
                        ),
                      ),
                      // Or continue with
                      ContinueWithWidget(),
                      // Buttons for company login
                      AuthCompanyWidget(
                        appleLogin: () {},
                        googleLogin: () {},
                        facebookLogin: () {},
                      ),
                      // Rich text
                      AuthFooter(
                        isSignUp: false,
                        onTap: () {
                          context.go(AppRoutes.signUp);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

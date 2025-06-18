import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:obscure_me/core/routes/app_routes.dart';
import 'package:obscure_me/features/auth/presentation/widgets/agreement_widget.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_company_widget.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_shield.dart';
import '../widgets/continue_with_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _checkBoxSelected = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            context.push(
              AppRoutes.verifyEmailOtp,
              extra: _emailController.text.trim(),
            );
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthShield(),
                      //Top texts
                      AuthHeader(header: 'Create your Account'),
                      //Auth fields
                      // Name
                      AuthField(
                        prefixIcon: Icons.person,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        textEditingController: _nameController,
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Name is a required field';
                          }
                          return null;
                        },
                        hintText: 'Name',
                      ),
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
                          if (_formKey.currentState!.validate() &&
                              _checkBoxSelected) {
                            context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                          } else if (_formKey.currentState!.validate() &&
                              !_checkBoxSelected) {
                            showToast(
                              type: ToastificationType.warning,
                              description:
                                  'Please agree with our terms and conditions to continue using VPN App',
                            );
                          }
                        },
                        buttonName: 'Sign up',
                      ),
                      //Agreement Text
                      AgreementWidget(
                        value: _checkBoxSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              _checkBoxSelected = value;
                            }
                          });
                        },
                        onAgreed: () {
                          setState(() {
                            _checkBoxSelected = true;
                          });
                          Navigator.of(context).pop(true);
                        },
                        onDisagreed: () {
                          setState(() {
                            _checkBoxSelected = false;
                          });
                          Navigator.of(context).pop(false);
                        },
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
                        isSignUp: true,
                        onTap: () {
                          context.go(AppRoutes.signIn);
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

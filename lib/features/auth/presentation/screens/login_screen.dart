import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:e_commerce_app/core/constants/app_colors.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../contacts/presentation/screens/home_screen.dart';
import '../../../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(LoginRequested(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: !isDark
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
            : null,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                } else if (state is AuthFailure) {
                  DelightToastBar(
                    builder: (context) => ToastCard(
                      leading: Icon(
                        Icons.flutter_dash,
                        size: 28,
                      ),
                      title: Text(
                        state.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    position: DelightSnackbarPosition.bottom,
                    autoDismiss: true,
                    snackbarDuration: const Duration(seconds: 2),
                  ).show(context);
                }
              },
              builder: (context, state) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            'Welcome',
                            style: textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hint: 'Email',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hint: 'Password',
                            controller: _passCtrl,
                            obscure: true,
                            validator: passwordValidator,
                          ),
                          const SizedBox(height: 18),
                          CustomButton(
                            text: 'LOGIN',
                            loading: state is AuthLoading,
                            onPressed: _onLoginPressed,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _emailCtrl.text = 'user@example.com';
                              _passCtrl.text = '1234';
                            },
                            child: const Text('Fill demo account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

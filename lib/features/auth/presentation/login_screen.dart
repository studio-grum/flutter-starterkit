import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authNotifierProvider.notifier)
        .signIn(_emailController.text.trim(), _passwordController.text);

    if (mounted) {
      final authState = ref.read(authNotifierProvider);
      if (authState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppConstants.appName,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
                const Gap(48),
                AppTextField(
                  controller: _emailController,
                  label: '이메일',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v?.isValidEmail ?? false) ? null : '올바른 이메일을 입력하세요',
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: -0.1),
                const Gap(16),
                AppTextField(
                  controller: _passwordController,
                  label: '비밀번호',
                  obscureText: true,
                  validator: (v) =>
                      (v?.isValidPassword ?? false) ? null : '8자 이상 입력하세요',
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: -0.1),
                const Gap(24),
                AppButton(
                  label: '로그인',
                  isLoading: isLoading,
                  onPressed: _submit,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const Gap(16),
                TextButton(
                  onPressed: () => context.push(AppConstants.routeRegister),
                  child: const Text('계정이 없으신가요? 회원가입'),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

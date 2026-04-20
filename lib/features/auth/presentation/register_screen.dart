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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
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
        .signUp(_emailController.text.trim(), _passwordController.text);

    if (mounted) {
      final authState = ref.read(authNotifierProvider);
      if (authState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error.toString())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 인증 링크를 확인해주세요')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(24),
                Text(
                  '새 계정 만들기',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const Gap(32),
                AppTextField(
                  controller: _emailController,
                  label: '이메일',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v?.isValidEmail ?? false) ? null : '올바른 이메일을 입력하세요',
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                const Gap(16),
                AppTextField(
                  controller: _passwordController,
                  label: '비밀번호',
                  obscureText: true,
                  validator: (v) =>
                      (v?.isValidPassword ?? false) ? null : '8자 이상 입력하세요',
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const Gap(24),
                AppButton(
                  label: '회원가입',
                  isLoading: isLoading,
                  onPressed: _submit,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

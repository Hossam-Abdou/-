import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../config/router/app_router.dart';
import '../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../core/shared/widgets/fields/app_text_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/user_role.dart';
import '../../../generated/locale_keys.g.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(UserRole role) async {
    setState(() => _isLoading = true);
    // TODO: wire up once the backend is decided — the backend will return
    // the account's real role instead of relying on what was tapped here.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(
      context,
      role == UserRole.marketer ? AppRoutes.marketerRequests : AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Passed from RoleSelectionScreen; defaults to client if opened directly.
    final role = (ModalRoute.of(context)?.settings.arguments as UserRole?) ?? UserRole.client;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(LocaleKeys.loginTitle.tr(), style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(LocaleKeys.loginSubtitle.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              AppTextField(label: LocaleKeys.emailLabel.tr(), controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              AppTextField(label: LocaleKeys.passwordLabel.tr(), controller: _passwordController, obscureText: true),
              const SizedBox(height: 24),
              AppPrimaryButton(label: LocaleKeys.loginButton.tr(), onPressed: () => _handleLogin(role), isLoading: _isLoading),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register, arguments: role),
                    child: Text(LocaleKeys.createAccountLabel.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  Text(LocaleKeys.noAccountLabel.tr(), style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

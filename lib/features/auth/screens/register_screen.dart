import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../core/shared/widgets/fields/app_text_field.dart';
import '../../../config/router/app_router.dart';
import '../models/user_role.dart';
import '../../../generated/locale_keys.g.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister(UserRole role) async {
    setState(() => _isLoading = true);
    // TODO: wire up once the backend is decided — persist `role` with the
    // new account so future logins don't need it passed through routing.
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
    final role = (ModalRoute.of(context)?.settings.arguments as UserRole?) ?? UserRole.client;

    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(LocaleKeys.registerTitle.tr(), style: AppTextStyles.heading1, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            AppTextField(label: LocaleKeys.fullNameLabel.tr(), controller: _nameController),
            const SizedBox(height: 16),
            AppTextField(label: LocaleKeys.phoneLabel.tr(), controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            AppTextField(label: LocaleKeys.emailLabel.tr(), controller: _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            AppTextField(label: LocaleKeys.passwordLabel.tr(), controller: _passwordController, obscureText: true),
            const SizedBox(height: 24),
            AppPrimaryButton(label: LocaleKeys.registerButton.tr(), onPressed: () => _handleRegister(role), isLoading: _isLoading),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(LocaleKeys.loginLabel.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                Text(LocaleKeys.haveAccountLabel.tr(), style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

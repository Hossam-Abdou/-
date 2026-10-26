import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_error_text.dart';
import '../../../../core/shared/widgets/app_snack_bar.dart';
import '../../../profile/cubit/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../core/shared/widgets/fields/validated_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Edit-personal-details screen for the client account, filled from the
/// real profile and saved through [ProfileCubit]. The email is shown but
/// can't be changed here (it is the login).
class MyInformationScreen extends StatefulWidget {
  const MyInformationScreen({super.key});

  @override
  State<MyInformationScreen> createState() => _MyInformationScreenState();
}

class _MyInformationScreenState extends State<MyInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    _fill(cubit.state.selected);
    cubit.load().then((_) {
      if (mounted) _fill(cubit.state.selected);
    });
  }

  void _fill(profile) {
    if (profile == null) return;
    _nameController.text = profile.fullName;
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<ProfileCubit>();
    setState(() => _submitting = true);
    final ok = await cubit.update(fullName: _nameController.text.trim(), phone: _phoneController.text.trim());
    if (!mounted) return;
    setState(() => _submitting = false);
    if (!ok) {
      showAppSnackBar(context, cubit.state.error!.text, isError: true);
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(LocaleKeys.propertySavedSuccessTitle.tr(), style: AppTextStyles.heading4),
          ],
        ),
        content: Text(LocaleKeys.infoSavedSuccessDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(LocaleKeys.okButton.tr())),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.profileMyInfoTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              ValidatedTextField(controller: _nameController, label: LocaleKeys.fullNameLabel.tr()),
              const SizedBox(height: 16),
              ValidatedTextField(controller: _emailController, label: LocaleKeys.emailLabel.tr(), keyboardType: TextInputType.emailAddress, readOnly: true),
              const SizedBox(height: 16),
              ValidatedTextField(controller: _phoneController, label: LocaleKeys.phoneLabel.tr(), keyboardType: TextInputType.phone),
              const SizedBox(height: 28),
              AppPrimaryButton(
                label: LocaleKeys.saveChangesButton.tr(),
                icon: Icons.check,
                isLoading: _submitting,
                onPressed: _submitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

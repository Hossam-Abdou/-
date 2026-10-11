import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../core/shared/widgets/fields/validated_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Edit-personal-details screen for the marketer account. Adds a bio
/// field on top of name/email/phone, since a marketer's profile is
/// client-facing (shown on offers). Demo data is pre-filled to match
/// the mock name on the marketer Profile tab header.
///
/// Submission is simulated (no backend yet): validates the form,
/// shows a success dialog, and pops back.
class MarketerMyInformationScreen extends StatefulWidget {
  const MarketerMyInformationScreen({super.key});

  @override
  State<MarketerMyInformationScreen> createState() => _MarketerMyInformationScreenState();
}

class _MarketerMyInformationScreenState extends State<MarketerMyInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'أحمد محمود');
  final _emailController = TextEditingController(text: 'ahmed.mahmoud@example.com');
  final _phoneController = TextEditingController(text: '01098765432');
  final _bioController = TextEditingController(text: 'مسوق عقاري في القاهرة الجديدة، متخصص في الشقق والفيلل السكنية.');
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);

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
              ValidatedTextField(controller: _emailController, label: LocaleKeys.emailLabel.tr(), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              ValidatedTextField(controller: _phoneController, label: LocaleKeys.phoneLabel.tr(), keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              ValidatedTextField(controller: _bioController, label: LocaleKeys.bioLabel.tr(), maxLines: 4, required: false),
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

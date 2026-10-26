import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Label above a rounded white input. Used by every field on Login / Sign Up.
/// [trailingLabel] is the small link on the label row (e.g. "forgot password").
class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.prefix,
    this.suffix,
    this.trailingLabel,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon; // shown at the end side of the field
  final Widget? prefix; // shown at the start side (e.g. +20 flag)
  final Widget? suffix; // replaces [icon] (e.g. the eye button)
  final Widget? trailingLabel;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final inputTextStyle = AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary, fontSize: 15);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700))),
            if (trailingLabel != null) trailingLabel!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          textAlign: TextAlign.start,
          style: inputTextStyle,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 15),
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffix ?? (icon == null ? null : Icon(icon, size: 20, color: AppColors.textMuted)),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color c, {double width = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: width),
      );
}

/// "🇪🇬 +20 |" chip placed at the start of a phone field.
class PhonePrefix extends StatelessWidget {
  const PhonePrefix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇪🇬', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text('+20', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 22, color: AppColors.border),
        ],
      ),
    );
  }
}

/// Password input with the lock icon and the show/hide eye.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.trailingLabel,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final Widget? trailingLabel;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return AuthField(
      label: widget.label,
      controller: widget.controller,
      hint: widget.hint,
      trailingLabel: widget.trailingLabel,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      obscureText: _hidden,
      keyboardType: TextInputType.visiblePassword,
      prefix: const Padding(
        padding: EdgeInsetsDirectional.only(start: 14, end: 4),
        child: Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.textMuted),
      ),
      suffix: IconButton(
        onPressed: () => setState(() => _hidden = !_hidden),
        icon: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: AppColors.textMuted),
      ),
    );
  }
}

/// Label + rounded dropdown with an id as value (ids come from `Locations`).
class AuthDropdownField extends StatelessWidget {
  const AuthDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.icon,
    this.validator,
  });

  final String label;
  final List<DropdownMenuItem<int>> items;
  final ValueChanged<int?> onChanged;
  final int? value;
  final String? hint;
  final IconData? icon;
  final String? Function(int?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary, fontSize: 15),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          hint: Text(hint ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 14),
            prefixIcon: icon == null
                ? null
                : Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
                    child: Icon(icon, size: 20, color: AppColors.primary),
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color c, {double width = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: width),
      );
}

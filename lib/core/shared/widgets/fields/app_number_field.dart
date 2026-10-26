import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Turns Arabic-Indic digits (٠-٩) into 0-9 as the user types, so the
/// value can always be parsed as a number.
class WesternDigitsFormatter extends TextInputFormatter {
  const WesternDigitsFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAllMapped(RegExp('[٠-٩]'), (m) => '${m[0]!.codeUnitAt(0) - 0x0660}');
    return newValue.copyWith(text: text);
  }
}

/// A numbers-only form field: digits only (optionally one decimal point),
/// a hint with an example, an optional unit and built-in validation.
/// Use it for area, price, rooms, lease months...
class AppNumberField extends StatelessWidget {
  final TextEditingController? controller; // or use [initialValue] + [onChanged]
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String label;
  final String hint;
  final String? unit; // shown after the number, e.g. "م²"
  final bool required;
  final bool allowDecimal;
  final bool allowZero;

  const AppNumberField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    required this.label,
    required this.hint,
    this.unit,
    this.required = true,
    this.allowDecimal = false,
    this.allowZero = false,
  });

  String? _validate(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return required ? LocaleKeys.fieldRequiredError.tr() : null;
    final n = double.tryParse(text);
    if (n == null || n < 0 || (n == 0 && !allowZero)) return LocaleKeys.numberInvalid.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color, width: width));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
          textAlign: TextAlign.start,
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
          inputFormatters: [
            const WesternDigitsFormatter(),
            FilteringTextInputFormatter.allow(allowDecimal ? RegExp(r'^\d*\.?\d*') : RegExp(r'\d*')),
          ],
          validator: _validate,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            suffixText: unit,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: border(AppColors.border),
            enabledBorder: border(AppColors.border),
            focusedBorder: border(AppColors.primary, 1.5),
            errorBorder: border(AppColors.error),
            focusedErrorBorder: border(AppColors.error, 1.5),
          ),
        ),
      ],
    );
  }
}

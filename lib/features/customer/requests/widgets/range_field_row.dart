import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A labeled "من / إلى" (from / to) pair of number fields — used for
/// the budget and area ranges on the request-details step.
class RangeFieldRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController fromController;
  final TextEditingController toController;
  final String fromLabel;
  final String toLabel;
  final String fromHint;
  final String toHint;

  const RangeFieldRow({
    super.key,
    required this.label,
    required this.icon,
    required this.fromController,
    required this.toController,
    required this.fromLabel,
    required this.toLabel,
    required this.fromHint,
    required this.toHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            const SizedBox(width: 6),
            Icon(icon, size: 15, color: AppColors.textSecondary),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _RangeInput(label: fromLabel, controller: fromController, hint: fromHint)),
            const SizedBox(width: 12),
            Expanded(child: _RangeInput(label: toLabel, controller: toController, hint: toHint)),
          ],
        ),
      ],
    );
  }
}

class _RangeInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _RangeInput({required this.label, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.start,
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

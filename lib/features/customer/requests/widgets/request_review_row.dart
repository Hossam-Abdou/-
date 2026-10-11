import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// One row of the review-step summary card: an icon + label on the
/// trailing (right, in RTL) side and the value on the leading (left)
/// side, with an optional light tint background for zebra striping.
class RequestReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool tinted;
  final TextStyle? valueStyle;

  const RequestReviewRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.tinted = false,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: tinted ? AppColors.primaryLight.withValues(alpha: 0.5) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: valueStyle ?? AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

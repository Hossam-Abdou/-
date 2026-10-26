import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// "20 Oct 2026 • 12:58 AM" in the user's local time and app language.
/// Renders nothing when [date] is null.
class DateTimeLabel extends StatelessWidget {
  final DateTime? date;
  const DateTimeLabel({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final d = date;
    if (d == null) return const SizedBox.shrink();
    final text = DateFormat('d MMM yyyy • h:mm a', context.locale.languageCode).format(d.toLocal());
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.schedule, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}

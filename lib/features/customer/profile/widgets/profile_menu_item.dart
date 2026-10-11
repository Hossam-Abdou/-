import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool iconInCircle;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconInCircle = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            iconInCircle
                ? Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                    child: Icon(icon, size: 18, color: AppColors.primaryDark),
                  )
                : Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: AppTextStyles.heading3, textAlign: TextAlign.start),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppTextStyles.bodySmall, textAlign: TextAlign.start),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Authored for LTR (points "forward"); `matchTextDirection`
            // mirrors it to chevron_left automatically under RTL — no
            // manual direction check needed.
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted, ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/date_time_label.dart';
import '../models/property_request.dart';
import '../../requests/widgets/request_status_badge.dart';
import '../../../../generated/locale_keys.g.dart';

class RequestCard extends StatelessWidget {
  final PropertyRequest request;
  final VoidCallback? onTap;

  const RequestCard({super.key, required this.request, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Wrapped in its own Material for the same reason as CategoryChip —
    // guarantees the InkWell ripple works regardless of ancestor context.
    return Material(
      color: Colors.transparent,
      child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  color: AppColors.primaryLight,
                  alignment: Alignment.center,
                  child: const Icon(Icons.apartment, size: 40, color: AppColors.primary),
                ),
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: RequestStatusBadge(status: request.status),
                ),
                if (request.isNew)
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(999)),
                      child: Text(LocaleKeys.newBadge.tr(), style: AppTextStyles.badgeTracked.copyWith(color: AppColors.primaryDark)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(request.title, style: AppTextStyles.heading3, textAlign: TextAlign.start),
                  const SizedBox(height: 4),
                  Text(request.location, style: AppTextStyles.bodySmall, textAlign: TextAlign.start),
                  if (request.createdAt != null) ...[
                    const SizedBox(height: 4),
                    DateTimeLabel(date: request.createdAt),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _Spec(icon: Icons.bathtub_outlined, value: '${request.bathrooms}'),
                      const SizedBox(width: 16),
                      _Spec(icon: Icons.bed_outlined, value: '${request.rooms}'),
                      const SizedBox(width: 16),
                      _Spec(icon: Icons.straighten, value: request.area),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RequestOffersCountLabel(offersCount: request.offersCount),
                      const Spacer(),
                      Text(request.priceRange, style: AppTextStyles.priceLarge, textAlign: TextAlign.start),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  final IconData icon;
  final String value;
  const _Spec({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.bodySmall),
        const SizedBox(width: 4),
        Icon(icon, size: 14, color: AppColors.textSecondary),
      ],
    );
  }
}

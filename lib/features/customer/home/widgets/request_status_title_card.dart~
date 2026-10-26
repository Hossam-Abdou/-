import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/property_image_strip.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/shared/widgets/date_time_label.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/offer_preview.dart';
import '../models/property_request.dart';
import 'offer_status_badge.dart';

class RequestStatusTitleCard extends StatelessWidget {
  final PropertyRequest request;
  const RequestStatusTitleCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = switch (request.status) {
      PropertyRequestStatus.open => (LocaleKeys.statusOpen.tr(), AppColors.warning),
      PropertyRequestStatus.offersReceived => (LocaleKeys.statusOffersReceived.tr(), AppColors.primary),
      PropertyRequestStatus.closed => (LocaleKeys.statusClosed.tr(), AppColors.textMuted),
    };

    return SectionCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(statusLabel, style: AppTextStyles.badgeTracked.copyWith(color: Colors.white)),
                    const SizedBox(width: 4),
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  ],
                ),
              ),
              const Spacer(),
              // the id is a long uuid: show a short code and never overflow the row
              Flexible(
                child: Text(
                  '#${request.id.length > 8 ? request.id.substring(0, 8).toUpperCase() : request.id}',
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(request.title, style: AppTextStyles.heading1, textAlign: TextAlign.start),
          if (request.propertyType.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.apartment, size: 14, color: AppColors.primaryDark),
                    const SizedBox(width: 6),
                    Text(request.propertyType, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          if (request.createdAt != null) ...[
            Align(alignment: AlignmentDirectional.centerStart, child: DateTimeLabel(date: request.createdAt)),
            const SizedBox(height: 6),
          ],
          Row(
            children: [
              Expanded(child: Text(request.location, style: AppTextStyles.bodySmall, textAlign: TextAlign.start)),
              const SizedBox(width: 8),
              const Icon(Icons.location_on_outlined, size: 15, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/marketer_request.dart';
import '../../../../generated/locale_keys.g.dart';

class MarketerRequestCard extends StatelessWidget {
  final MarketerRequest request;
  final VoidCallback? onAction;
  final VoidCallback? onTap;

  const MarketerRequestCard({super.key, required this.request, this.onAction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasOffer = request.status == MarketerRequestStatus.offerSent;

    // Whole card opens the request details screen; the action button
    // underneath keeps its own separate destination (send/update offer).
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.more_vert, color: AppColors.textMuted, size: 18),
              const Spacer(),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(child: Text(request.customerName, style: AppTextStyles.bodySmall, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        CircleAvatar(
                          radius: 11,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            request.customerName.isNotEmpty ? request.customerName.substring(0, 1) : '?',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(request.location, style: AppTextStyles.heading3, textAlign: TextAlign.start),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (hasOffer) ...[
                          _Tag(label: LocaleKeys.offerSentBadge.tr(), background: AppColors.accentMint, textColor: AppColors.primaryDark),
                          const SizedBox(width: 8),
                        ] else ...[
                          _Tag(label: LocaleKeys.newBadge.tr(), background: AppColors.background, bordered: true),
                          const SizedBox(width: 8),
                        ],
                        _Tag(label: request.propertyType, background: AppColors.background),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            children: [
              _SpecChip(icon: Icons.straighten, label: request.areaLabel),
              _SpecChip(icon: Icons.bathtub_outlined, label: request.bathsLabel),
              _SpecChip(icon: Icons.bed_outlined, label: request.bedsLabel),
            ],
          ),
          const SizedBox(height: 17),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: 17),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              hasOffer
                  ? OutlinedButton(
                      onPressed: onAction,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(LocaleKeys.updateOffer.tr()),
                    )
                  : ElevatedButton(
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(LocaleKeys.viewMatch.tr()),
                    ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(LocaleKeys.budgetLabel.tr(), style: AppTextStyles.bodySmall),
                  Text(request.budgetRange, style: AppTextStyles.priceLarge),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color background;
  final Color? textColor;
  final bool bordered;

  const _Tag({required this.label, required this.background, this.textColor, this.bordered = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
        border: bordered ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.badgeTracked.copyWith(color: textColor ?? AppColors.textPrimary, letterSpacing: 0),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

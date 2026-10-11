import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/marketer/details_spec.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/marketer_request.dart';

/// Full detail view for a single client request, opened from a
/// [MarketerRequestCard] on the marketer's main_layout ("home") tab or
/// from search results. Takes the request's id through
/// `settings.arguments` (see [AppRoutes.marketerRequestDetails]).
class MarketerRequestDetailsScreen extends StatelessWidget {
  final MarketerRequest request;

  const MarketerRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final hasOffer = request.status == MarketerRequestStatus.offerSent;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.requestDetailsTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasOffer)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Tag(label: LocaleKeys.offerSentBadge.tr(), background: AppColors.accentMint, textColor: AppColors.primaryDark),
                  ),
                Flexible(child: Text(request.location, style: AppTextStyles.heading1, textAlign: TextAlign.start)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(request.customerName, style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    request.customerName.isNotEmpty ? request.customerName.substring(0, 1) : '?',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Tag(label: request.propertyType, background: AppColors.background, bordered: true),
            ),
            const SizedBox(height: 20),
            Text(request.budgetRange, style: AppTextStyles.priceLarge.copyWith(fontSize: 22), textAlign: TextAlign.start),
            const SizedBox(height: 4),
            Text(LocaleKeys.budgetLabel.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.start),
            const SizedBox(height: 20),
            SectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DetailSpec(icon: Icons.straighten, label: LocaleKeys.specArea.tr(), value: request.areaLabel),
                  DetailSpec(icon: Icons.bed_outlined, label: LocaleKeys.specRooms.tr(), value: request.bedsLabel),
                  DetailSpec(icon: Icons.bathtub_outlined, label: LocaleKeys.specBathrooms.tr(), value: request.bathsLabel),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(LocaleKeys.requestDescriptionTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.start),
            const SizedBox(height: 8),
            Text(
              request.description.isNotEmpty ? request.description : LocaleKeys.noDescriptionAvailable.tr(),
              style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 28),
            AppPrimaryButton(
              label: hasOffer ? LocaleKeys.updateOffer.tr() : LocaleKeys.viewMatch.tr(),
              icon: Icons.send_outlined,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.marketerSendOffer, arguments: request.id),
            ),
            if (request.conversationId != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.marketerChatThread, arguments: request.conversationId),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(LocaleKeys.contactCustomer.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



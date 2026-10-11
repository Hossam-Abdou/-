import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/property_image_strip.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/offer_preview.dart';
import '../widgets/offer_status_badge.dart';
import '../models/property_request.dart';

/// Full detail view for a single client request + a preview of the
/// offers received on it, matching the Figma design (status badge,
/// budget bento card, spec grid, notes, inline offer previews, and a
/// bottom edit/pause action bar). Opened from a [RequestCard] on the
/// home tab or from search results.
///
/// Takes the request's id through `settings.arguments` (see
/// [AppRoutes.requestDetails]) and looks it up from the mock data —
/// swap [findPropertyRequestById] for a repository call once the
/// backend is wired up.
class RequestDetailsScreen extends StatelessWidget {
  final PropertyRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final offers = mockOfferPreviewsForRequest(request.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.requestDetailsTitle.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.primaryDark)),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _StatusAndTitleCard(request: request),
            const SizedBox(height: 16),
            _BudgetCard(priceRange: request.priceRange),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _SpecCard(icon: Icons.bathtub_outlined, label: LocaleKeys.specBathrooms.tr(), value: '${request.bathrooms}')),
                const SizedBox(width: 16),
                Expanded(child: _SpecCard(icon: Icons.bed_outlined, label: LocaleKeys.specRooms.tr(), value: '${request.rooms}')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _SpecCard(icon: Icons.brush_outlined, label: LocaleKeys.specFinishing.tr(), value: request.finishing)),
                const SizedBox(width: 16),
                Expanded(child: _SpecCard(icon: Icons.straighten, label: LocaleKeys.specArea.tr(), value: request.area)),
              ],
            ),
            const SizedBox(height: 16),
            _NotesCard(description: request.description),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(6)),
                  child: Text('${request.offersCount}', style: AppTextStyles.heading4),
                ),
                const SizedBox(width: 8),
                Text(LocaleKeys.viewReceivedOffers.tr(), style: AppTextStyles.heading4),
              ],
            ),
            const SizedBox(height: 16),
            if (offers.isEmpty)
              SectionCard(child: Text(LocaleKeys.noOffersYet.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center))
            else ...[
              ...offers.map((o) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _OfferPreviewCard(offer: o))),
              if (request.offersCount > offers.length)
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.requestOffers, arguments: request.id),
                  child: Text(LocaleKeys.viewAllOffersLink.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.primaryDark)),
                ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 24),
        decoration: const BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: AppColors.border))),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.editRequest, arguments: request.id),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(LocaleKeys.editRequestButton.tr()),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: wire up once the backend exists.
                  },
                  icon: const Icon(Icons.pause_circle_outline, size: 16),
                  label: Text(LocaleKeys.pauseRequestButton.tr()),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryDark, side: const BorderSide(color: AppColors.primaryDark)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusAndTitleCard extends StatelessWidget {
  final PropertyRequest request;
  const _StatusAndTitleCard({required this.request});

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
              Text('#${request.id}', style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(request.title, style: AppTextStyles.heading1, textAlign: TextAlign.start),
          const SizedBox(height: 4),
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

class _BudgetCard extends StatelessWidget {
  final String priceRange;
  const _BudgetCard({required this.priceRange});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SectionCard(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                Text(LocaleKeys.suggestedBudgetLabel.tr(), style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(priceRange, style: AppTextStyles.priceLarge),
              ],
            ),
          ),
          PositionedDirectional(
            top: -16,
            end: -16,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SpecCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: AppTextStyles.badgeTracked.copyWith(color: AppColors.textSecondary, letterSpacing: 0)),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: AppTextStyles.heading4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final String description;
  const _NotesCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(LocaleKeys.requestDescriptionTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.start),
          const SizedBox(height: 8),
          Text(
            description.isNotEmpty ? description : LocaleKeys.noDescriptionAvailable.tr(),
            style: AppTextStyles.bodyRegular,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _OfferPreviewCard extends StatelessWidget {
  final OfferPreview offer;
  const _OfferPreviewCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.pushNamed(context, AppRoutes.offerDetails, arguments: offer.id),
      child: SectionCard(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.person, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(offer.timeAgo, style: AppTextStyles.caption),
                        const Spacer(),
                        Text(offer.marketerName, style: AppTextStyles.heading4),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [OfferStatusBadge(status: offer.status)],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(LocaleKeys.reviewsCountLabel.tr(args: ['${offer.reviewsCount}']), style: AppTextStyles.caption),
                        const SizedBox(width: 4),
                        Text('${offer.rating}', style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 12, color: AppColors.warning),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer.message,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (offer.propertyTitle != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home_work_outlined, size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          offer.propertyTitle!,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Every photo the marketer attached to this property
                  // shows here — not just a cover — and tapping any one
                  // opens the full-screen swipeable gallery.
                  PropertyImageStrip(imagePaths: offer.propertyImagePaths, thumbnailSize: 76),
                ],
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}

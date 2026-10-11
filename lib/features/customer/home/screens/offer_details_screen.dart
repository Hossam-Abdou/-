import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/property_image_strip.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../messages/models/conversation.dart';
import '../models/offer_preview.dart';
import '../widgets/offer_status_badge.dart';

/// Full detail view of a single offer a marketer sent, opened by
/// tapping an offer preview on [RequestDetailsScreen]. Shows who sent
/// it, their full message, every photo of the offered property (tap
/// any thumbnail for the full-screen swipeable gallery), and a
/// "Send Message" CTA that opens (or starts) a chat thread with that
/// marketer.
///
/// Takes the offer's id through `settings.arguments` (see
/// [AppRoutes.offerDetails]) and looks it up from the mock data —
/// swap [findOfferPreviewById] for a repository call once the
/// backend is wired up.
class OfferDetailsScreen extends StatefulWidget {
  final OfferPreview offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  late OfferStatus _status = widget.offer.status;

  void _sendMessage(BuildContext context) {
    final conversation = findOrCreateConversationWithMarketer(widget.offer.marketerName, relatedRequestTitle: widget.offer.propertyTitle);
    Navigator.pushNamed(context, AppRoutes.chatThread, arguments: conversation.id);
  }

  Future<void> _accept() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(LocaleKeys.acceptOfferConfirmTitle.tr(), style: AppTextStyles.heading4),
        content: Text(LocaleKeys.acceptOfferConfirmDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(LocaleKeys.cancelButton.tr())),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LocaleKeys.acceptOfferButton.tr(), style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    updateOfferStatus(widget.offer.id, OfferStatus.accepted);
    if (!mounted) return;
    setState(() => _status = OfferStatus.accepted);
  }

  Future<void> _decline() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(LocaleKeys.declineOfferConfirmTitle.tr(), style: AppTextStyles.heading4),
        content: Text(LocaleKeys.declineOfferConfirmDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(LocaleKeys.cancelButton.tr())),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LocaleKeys.declineOfferButton.tr(), style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    updateOfferStatus(widget.offer.id, OfferStatus.declined);
    if (!mounted) return;
    setState(() => _status = OfferStatus.declined);
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.offerDetailsTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            SectionCard(
              padding: const EdgeInsets.all(17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: AppColors.primaryDark, size: 26),
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
                            Text(offer.marketerName, style: AppTextStyles.heading3),
                          ],
                        ),
                        const SizedBox(height: 6),
                        OfferStatusBadge(status: _status),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (offer.propertyTitle != null) ...[
              SectionCard(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.home_work_outlined, size: 18, color: AppColors.primaryDark),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            offer.propertyTitle!,
                            style: AppTextStyles.heading4,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(LocaleKeys.propertyPhotosLabel.tr(), style: AppTextStyles.bodySmall),
                    const SizedBox(height: 10),
                    // Every photo the marketer attached — tap any one
                    // to open the full-screen swipeable gallery.
                    PropertyImageStrip(imagePaths: offer.propertyImagePaths, thumbnailSize: 96),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            SectionCard(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(LocaleKeys.offerMessageFromMarketerLabel.tr(), style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(offer.message, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.start),
                ],
              ),
            ),
            if (_status != OfferStatus.pending) ...[
              const SizedBox(height: 16),
              SectionCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      _status == OfferStatus.accepted ? Icons.check_circle_outline : Icons.cancel_outlined,
                      size: 18,
                      color: _status == OfferStatus.accepted ? AppColors.primary : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        (_status == OfferStatus.accepted ? LocaleKeys.offerAcceptedNote : LocaleKeys.offerDeclinedNote).tr(),
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 24),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_status == OfferStatus.pending) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _accept,
                        icon: const Icon(Icons.check, size: 18),
                        label: Text(LocaleKeys.acceptOfferButton.tr()),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _decline,
                        icon: const Icon(Icons.close, size: 18),
                        label: Text(LocaleKeys.declineOfferButton.tr()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed: () => _sendMessage(context),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(LocaleKeys.sendMessageButton.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primaryDark),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../core/shared/widgets/fields/app_text_field.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../customer/home/models/offer_preview.dart';
import '../../properties/models/marketer_property.dart';
import '../../properties/widgets/property_selector_card.dart';
import '../models/marketer_request.dart';

/// Form the marketer fills in to send (or update) an offer against a
/// client request. Takes the request's id through `settings.arguments`
/// (see `AppRoutes.marketerSendOffer`) and is looked up from mock data.
///
/// The marketer picks one of their own listed properties (from
/// [mockMarketerProperties]) rather than typing a property in by
/// hand — this is the piece that wasn't implemented before.
///
/// Submission is simulated: there's no backend yet, so this validates
/// the form, shows a success dialog, and pops back to where the
/// marketer came from — swap `_submit` for a real API call later.
class SendOfferScreen extends StatefulWidget {
  final MarketerRequest request;

  const SendOfferScreen({super.key, required this.request});

  @override
  State<SendOfferScreen> createState() => _SendOfferScreenState();
}

class _SendOfferScreenState extends State<SendOfferScreen> {
  final _messageController = TextEditingController();
  String? _selectedPropertyId;
  String? _propertyError;
  bool _submitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _propertyError = _selectedPropertyId == null ? LocaleKeys.propertyRequiredError.tr() : null);
    if (_selectedPropertyId == null) return;

    setState(() => _submitting = true);
    // Demo-only delay to feel like a real submission; replace with an
    // API call once the backend exists.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);

    // Push the offer (with the chosen property's photo) onto the
    // customer's request-details screen, when this demo request has a
    // matching one there — see [MarketerRequest.linkedCustomerRequestId].
    final linkedRequestId = widget.request.linkedCustomerRequestId;
    if (linkedRequestId != null) {
      final property = findMarketerPropertyById(_selectedPropertyId);
      addOfferPreview(
        linkedRequestId,
        OfferPreview(
          id: 'offer-${DateTime.now().millisecondsSinceEpoch}',
          marketerName: 'أحمد محمود',
          rating: 4.8,
          reviewsCount: 0,
          timeAgo: LocaleKeys.justNow.tr(),
          message: _messageController.text.trim().isNotEmpty
              ? _messageController.text.trim()
              : LocaleKeys.defaultOfferMessage.tr(),
          propertyTitle: property?.title,
          propertyImagePaths: property?.imagePaths ?? const [],
        ),
      );
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(LocaleKeys.offerSentSuccessTitle.tr(), style: AppTextStyles.heading4),
          ],
        ),
        content: Text(
          LocaleKeys.offerSentSuccessDesc.tr(args: [widget.request.customerName]),
          style: AppTextStyles.bodyRegular,
          textAlign: TextAlign.start,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(LocaleKeys.okButton.tr()),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.sendOfferTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(child: Text(request.customerName, style: AppTextStyles.heading4, textAlign: TextAlign.start)),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          request.customerName.isNotEmpty ? request.customerName.substring(0, 1) : '?',
                          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(request.location, style: AppTextStyles.bodySmall, textAlign: TextAlign.start),
                  const SizedBox(height: 4),
                  Text(
                    '${LocaleKeys.budgetLabel.tr()}: ${request.budgetRange}',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(LocaleKeys.selectPropertyPrompt.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.start),
            const SizedBox(height: 16),
            if (mockMarketerProperties.isEmpty)
              SectionCard(
                child: Column(
                  children: [
                    Text(LocaleKeys.noPropertiesTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(LocaleKeys.noPropertiesDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.marketerAddProperty),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: Text(LocaleKeys.addFirstPropertyButton.tr()),
                    ),
                  ],
                ),
              )
            else ...[
              ...mockMarketerProperties.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PropertySelectorCard(
                    property: p,
                    isSelected: _selectedPropertyId == p.id,
                    onTap: () => setState(() {
                      _selectedPropertyId = p.id;
                      _propertyError = null;
                    }),
                  ),
                ),
              ),
              if (_propertyError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_propertyError!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error), textAlign: TextAlign.start),
                ),
            ],
            const SizedBox(height: 8),
            AppTextField(
              label: LocaleKeys.offerMessageLabel.tr(),
              controller: _messageController,
              maxLines: 4,
            ),
            const SizedBox(height: 28),
            AppPrimaryButton(
              label: LocaleKeys.sendOfferSubmit.tr(),
              icon: Icons.send_outlined,
              isLoading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

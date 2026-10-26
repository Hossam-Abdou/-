import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error_text.dart';
import '../../../chat/cubit/chat_cubits.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../chat/screens/chat_room_screen.dart';
import '../../../requests/data/requests_repository.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/marketer/details_spec.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/shared/widgets/date_time_label.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../offers/cubit/offers_cubit.dart';
import '../models/marketer_request.dart';
import '../widgets/my_offer_card.dart';

/// Full detail view for a single client request, opened from a
/// [MarketerRequestCard] on the marketer's main_layout ("home") tab or
/// from search results. Takes the request's id through
/// `settings.arguments` (see [AppRoutes.marketerRequestDetails]).
class MarketerRequestDetailsScreen extends StatefulWidget {
  final MarketerRequest request;

  const MarketerRequestDetailsScreen({super.key, required this.request});

  @override
  State<MarketerRequestDetailsScreen> createState() => _MarketerRequestDetailsScreenState();
}

class _MarketerRequestDetailsScreenState extends State<MarketerRequestDetailsScreen> {
  String? _customerName;
  String? _customerId;
  bool _contacting = false;

  MarketerRequest get request => widget.request;

  @override
  void initState() {
    super.initState();
    _loadCustomer();
  }

  /// The list doesn't carry the customer; the details do.
  Future<void> _loadCustomer() async {
    try {
      final r = await RequestsRepository().details(request.id);
      if (!mounted) return;
      setState(() {
        _customerName = r.customer?.fullName;
        _customerId = r.customerId;
      });
    } on ApiException {
      // keep the fallback name
    }
  }

  Future<void> _contact() async {
    final customerId = _customerId ?? request.customerId;
    if (customerId.isEmpty) return;
    setState(() => _contacting = true);
    final chat = ChatCubit(ChatRepository());
    final ok = await chat.start(customerId, relatedRequestId: request.id);
    final conversation = chat.state.selected;
    final error = chat.state.error;
    await chat.close();
    if (!mounted) return;
    setState(() => _contacting = false);
    if (ok && conversation != null) {
      openChatRoom(context, conversation, title: _customerName ?? request.customerName);
    } else if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // the offer I sent on this request (newest first)
    final myOffer = context.watch<OffersCubit>().state.items.where((o) => o.requestId == request.id).firstOrNull;
    final customerName = (_customerName != null && _customerName!.isNotEmpty) ? _customerName! : request.customerName;
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
                Text(customerName, style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    customerName.isNotEmpty ? customerName.substring(0, 1) : '?',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (request.createdAt != null) ...[
              const SizedBox(height: 8),
              Align(alignment: AlignmentDirectional.centerStart, child: DateTimeLabel(date: request.createdAt)),
            ],
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
            if (myOffer != null) ...[
              const SizedBox(height: 20),
              MyOfferCard(offer: myOffer),
            ],
            const SizedBox(height: 28),
            AppPrimaryButton(
              label: hasOffer ? LocaleKeys.updateOffer.tr() : LocaleKeys.viewMatch.tr(),
              icon: Icons.send_outlined,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.marketerSendOffer, arguments: request.id),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _contacting ? null : _contact,
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
        ),
      ),
    );
  }
}



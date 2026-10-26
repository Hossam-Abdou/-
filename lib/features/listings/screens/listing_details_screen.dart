import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_error_text.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../../../core/shared/widgets/app_property_image.dart';
import '../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';
import '../../chat/cubit/chat_cubits.dart';
import '../../chat/data/chat_repository.dart';
import '../../chat/models/chat_models.dart';
import '../../chat/screens/chat_room_screen.dart';
import '../../customer/home/widgets/listing_card.dart';
import '../cubit/listings_cubit.dart';
import '../data/listings_repository.dart';
import '../models/listing_model.dart';
import '../widgets/listings_message.dart';

/// One marketer property, opened from the customer's Home / Search.
class ListingDetailsScreen extends StatelessWidget {
  final String listingId;
  const ListingDetailsScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ListingsCubit(ListingsRepository())..open(listingId)),
        BlocProvider(create: (_) => ChatCubit(ChatRepository())),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(LocaleKeys.listingDetailsTitle.tr(), style: AppTextStyles.heading3),
          leading: const AppBackButton(),
        ),
        body: BlocBuilder<ListingsCubit, ApiState<ListingModel>>(
          builder: (context, state) {
            final l = state.selected;
            if (l == null) {
              // `items` is empty here, so this shows loading or the error.
              return SingleChildScrollView(
                child: ListingsMessage.of(state, () => context.read<ListingsCubit>().open(listingId)) ??
                    const SizedBox.shrink(),
              );
            }
            return _Body(listing: l);
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ListingModel listing;
  const _Body({required this.listing});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final price = listing.displayPrice == null ? '' : NumberFormat.decimalPattern(lang).format(listing.displayPrice);
    final suffix = !listing.isRent ? '' : ' ${listing.isDailyRent ? LocaleKeys.perDay.tr() : LocaleKeys.perMonth.tr()}';
    final marketer = listing.marketer;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              SizedBox(
                height: 240,
                child: listing.images.isEmpty
                    ? Container(
                        color: AppColors.primaryLight,
                        alignment: Alignment.center,
                        child: const Icon(Icons.apartment, size: 56, color: AppColors.primary),
                      )
                    : PageView(
                        children: [for (final url in listing.images) AppPropertyImage(path: url, width: double.infinity)],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(listing.title, style: AppTextStyles.heading2)),
                        FavoriteButton(listing: listing),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(child: Text(listing.location(lang), style: AppTextStyles.bodySmall)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      price.isEmpty ? '' : '$price ${LocaleKeys.currency.tr()}$suffix',
                      style: AppTextStyles.priceLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.isRent ? LocaleKeys.listingForRent.tr() : LocaleKeys.listingForSale.tr(),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        if (listing.rooms != null) _Spec(Icons.bed_outlined, '${listing.rooms}'),
                        if (listing.bathrooms != null) _Spec(Icons.bathtub_outlined, '${listing.bathrooms}'),
                        if (listing.area != null)
                          _Spec(Icons.straighten, '${listing.area!.round()} ${LocaleKeys.areaUnit.tr()}'),
                        if (listing.floor != null)
                          _Spec(Icons.stairs_outlined, '${LocaleKeys.listingFloor.tr()} ${listing.floor}'),
                        if (listing.referenceCode != null)
                          _Spec(Icons.tag, '${LocaleKeys.listingReference.tr()} ${listing.referenceCode}'),
                      ],
                    ),
                    if (listing.description != null && listing.description!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(LocaleKeys.listingDescription.tr(), style: AppTextStyles.heading4),
                      const SizedBox(height: 6),
                      Text(listing.description!, style: AppTextStyles.bodyRegular),
                    ],
                    if (listing.features.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(LocaleKeys.listingFeatures.tr(), style: AppTextStyles.heading4),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final f in listing.features)
                            Chip(
                              label: Text(f, style: AppTextStyles.bodySmall),
                              backgroundColor: AppColors.primaryLight,
                              side: BorderSide.none,
                            ),
                        ],
                      ),
                    ],
                    if (marketer != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(Icons.person_outline_rounded, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(LocaleKeys.listingMarketer.tr(), style: AppTextStyles.caption),
                                  Text(marketer.fullName, style: AppTextStyles.heading4),
                                ],
                              ),
                            ),
                            if ((marketer.rating ?? 0) > 0) ...[
                              const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                              const SizedBox(width: 2),
                              Text(marketer.rating!.toStringAsFixed(1), style: AppTextStyles.caption),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: BlocBuilder<ChatCubit, ApiState<ConversationModel>>(
              builder: (context, chat) => AppPrimaryButton(
                label: LocaleKeys.listingContactMarketer.tr(),
                icon: Icons.chat_bubble_outline,
                onPressed: chat.isLoading
                    ? null
                    : () async {
                        final cubit = context.read<ChatCubit>();
                        final messenger = ScaffoldMessenger.of(context);
                        final ok = await cubit.start(listing.marketerId);
                        if (ok && context.mounted) {
                          openChatRoom(context, cubit.state.selected!, title: listing.marketer?.fullName);
                        } else if (!ok) {
                          messenger.showSnackBar(SnackBar(
                            content: Text(cubit.state.error!.text),
                            backgroundColor: AppColors.error,
                          ));
                        }
                      },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Spec extends StatelessWidget {
  final IconData icon;
  final String value;
  const _Spec(this.icon, this.value);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(value, style: AppTextStyles.bodyRegular),
        ],
      );
}

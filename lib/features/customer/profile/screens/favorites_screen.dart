import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/cubit/api_state.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../listings/models/listing_model.dart';
import '../../../listings/widgets/listings_message.dart';
import '../../home/widgets/listing_card.dart';

/// The customer's saved listings, from the app-wide [FavoritesCubit].
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.profileFavoritesTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: BlocBuilder<FavoritesCubit, ApiState<ListingModel>>(
          builder: (context, state) {
            if (state.items.isEmpty && state.status != ApiStatus.failure && !state.isLoading) {
              return _EmptyState();
            }
            final message = ListingsMessage.of(state, () => context.read<FavoritesCubit>().load());
            if (message != null) return SingleChildScrollView(child: message);
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final l = state.items[i];
                return ListingCard(
                  listing: l,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.listingDetails, arguments: l.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(LocaleKeys.noFavoritesTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(LocaleKeys.noFavoritesDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

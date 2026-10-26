import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/cubit/api_state.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../listings/models/listing_model.dart';
import '../../../listings/widgets/listings_message.dart';
import 'listing_card.dart';

/// The marketers' listings on the home tab (`GET listings`), with the
/// loading skeleton / error / empty states.
class HomeListingsSection extends StatelessWidget {
  const HomeListingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingsCubit, ApiState<ListingModel>>(
      builder: (context, state) {
        final message = ListingsMessage.of(state, () => context.read<ListingsCubit>().load());
        if (message != null) return message;
        return Column(
          children: [
            for (final l in state.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ListingCard(
                  listing: l,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.listingDetails, arguments: l.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

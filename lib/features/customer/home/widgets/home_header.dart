import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/cubit/api_state.dart';
import '../../../../core/shared/widgets/top_bar.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../listings/models/listing_model.dart';
import 'location_label.dart';
import 'location_sheet.dart';

/// Greeting + location chip. The chosen area lives in [ListingsCubit].
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Future<void> _pickLocation(BuildContext context) async {
    final cubit = context.read<ListingsCubit>();
    final choice = await showLocationSheet(context, cityId: cubit.cityId, districtId: cubit.districtId);
    if (choice != null) cubit.setLocation(choice.cityId, choice.districtId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingsCubit, ApiState<ListingModel>>(
      builder: (context, _) {
        final cubit = context.read<ListingsCubit>();
        return TopBar(
          locationLabel: locationLabel(
            cityId: cubit.cityId,
            districtId: cubit.districtId,
            isArabic: context.locale.languageCode == 'ar',
          ),
          onLocationTap: () => _pickLocation(context),
        );
      },
    );
  }
}

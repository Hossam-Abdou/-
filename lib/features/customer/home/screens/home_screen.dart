import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/customer/categories_row.dart';
import '../../../../core/shared/widgets/customer/section_header.dart';
import '../../../../core/shared/widgets/fields/custom_search_bar.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../widgets/home_header.dart';
import '../widgets/home_listings_section.dart';

/// Content for the "Home" tab only — no Scaffold/bottom nav here.
/// [ClientBottomNavBar] owns those and provides the [ListingsCubit]; the
/// chosen location lives in that cubit, so this screen keeps no state.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: context.read<ListingsCubit>().load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const HomeHeader(),
            const SizedBox(height: 24),
            CustomSearchBar(
              onTap: () => Navigator.pushNamed(context, AppRoutes.search),
              searchText: LocaleKeys.searchPlaceholder.tr(),
            ),
            const SizedBox(height: 24),
            CategoriesRow(
              onCategoryTap: (category) => Navigator.pushNamed(context, AppRoutes.search, arguments: category),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: LocaleKeys.marketerListingsTitle.tr(),
              onViewAllTap: () => Navigator.pushNamed(context, AppRoutes.search),
            ),
            const SizedBox(height: 16),
            const HomeListingsSection(),
            const SizedBox(height: 8),
            AppPrimaryButton(
              label: LocaleKeys.createRequestButton.tr(),
              icon: Icons.add,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.createRequestLocation),
            ),
          ],
        ),
      ),
    );
  }
}

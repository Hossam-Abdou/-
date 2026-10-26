import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/skeleton_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_error_text.dart';
import '../../../../core/shared/cubit/api_state.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../listings/models/listing_model.dart';
import '../models/marketer_property_mapper.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/marketer_property.dart';
import '../widgets/property_image_thumbnail.dart';

/// Lists the marketer's own properties from the backend (pull to refresh).
class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MyListingsCubit>().load();
    });
  }

  Future<void> _openForm(String route, {String? propertyId}) async {
    await Navigator.pushNamed(context, route, arguments: propertyId);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.myPropertiesTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primaryDark),
            onPressed: () => _openForm(AppRoutes.marketerAddProperty),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MyListingsCubit, ApiState<ListingModel>>(
          builder: (context, state) {
            final properties = [for (final l in state.items) l.toMarketerProperty(lang)];
            if (properties.isEmpty && state.isLoading) {
              return const SingleChildScrollView(padding: EdgeInsets.all(16), child: SkeletonList());
            }
            if (properties.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<MyListingsCubit>().load(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 400,
                      child: _EmptyState(onAddProperty: () => _openForm(AppRoutes.marketerAddProperty)),
                    ),
                    if (state.error != null)
                      Center(child: Text(state.error!.text, style: AppTextStyles.bodySmall)),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<MyListingsCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  for (final p in properties)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PropertyListItem(
                        property: p,
                        onTap: () => _openForm(AppRoutes.marketerEditProperty, propertyId: p.id),
                        onVisibilityChanged: (visible) async {
                          final cubit = context.read<MyListingsCubit>();
                          await cubit.update(p.id, {'is_published': visible});
                          cubit.load(); // the update reply has no photos / location
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PropertyListItem extends StatelessWidget {
  final MarketerProperty property;
  final VoidCallback onTap;
  final ValueChanged<bool> onVisibilityChanged;
  const _PropertyListItem({required this.property, required this.onTap, required this.onVisibilityChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SectionCard(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            // Authored for LTR; `matchTextDirection` mirrors it to
            // chevron_left automatically under RTL.
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted,),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(property.title, style: AppTextStyles.heading4, textAlign: TextAlign.start),
                  if (!property.isPublished)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(LocaleKeys.propertyHiddenBadge.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                    ),
                  const SizedBox(height: 2),
                  Text(property.location, style: AppTextStyles.bodySmall, textAlign: TextAlign.start),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(property.priceLabel, style: AppTextStyles.priceLarge),
                      const SizedBox(width: 12),
                      Text(property.areaLabel, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(LocaleKeys.propertyVisibleShort.tr(), style: AppTextStyles.caption),
                      Switch(
                        value: property.isPublished,
                        activeColor: AppColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: onVisibilityChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PropertyImageThumbnail(
              imagePath: property.coverImagePath,
              size: 68,
              extraCount: property.imagePaths.length > 1 ? property.imagePaths.length - 1 : 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddProperty;
  const _EmptyState({required this.onAddProperty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home_work_outlined, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(LocaleKeys.noPropertiesTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(LocaleKeys.noPropertiesDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAddProperty,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: Text(LocaleKeys.addFirstPropertyButton.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

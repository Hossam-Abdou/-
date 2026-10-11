import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/marketer_property.dart';
import '../widgets/property_image_thumbnail.dart';

/// Lists the marketer's own properties. Stateful only so it can
/// refresh its list after returning from add/edit (which mutate
/// [mockMarketerProperties] in place — there's no stream/repository
/// yet to listen to).
class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  Future<void> _openForm(String? route, {String? propertyId}) async {
    await Navigator.pushNamed(context, route!, arguments: propertyId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
        child: mockMarketerProperties.isEmpty
            ? _EmptyState(onAddProperty: () => _openForm(AppRoutes.marketerAddProperty))
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: mockMarketerProperties
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PropertyListItem(
                          property: p,
                          onTap: () => _openForm(AppRoutes.marketerEditProperty, propertyId: p.id),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _PropertyListItem extends StatelessWidget {
  final MarketerProperty property;
  final VoidCallback onTap;
  const _PropertyListItem({required this.property, required this.onTap});

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

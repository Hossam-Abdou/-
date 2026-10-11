import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../models/marketer_property.dart';
import 'property_image_thumbnail.dart';

class PropertySelectorCard extends StatelessWidget {
  final MarketerProperty property;
  final bool isSelected;
  final VoidCallback onTap;

  const PropertySelectorCard({
    super.key,
    required this.property,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SectionCard(
        padding: const EdgeInsets.all(13),
        backgroundColor: isSelected ? AppColors.primaryLight : AppColors.surface,
        borderColor: isSelected ? AppColors.primary : AppColors.border,
        borderWidth: isSelected ? 2 : 1,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(property.title, style: AppTextStyles.heading4, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(property.location, style: AppTextStyles.bodySmall, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis),
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
              size: 72,
              extraCount: property.imagePaths.length > 1 ? property.imagePaths.length - 1 : 0,
            ),
          ],
        ),
      ),
    );
  }
}

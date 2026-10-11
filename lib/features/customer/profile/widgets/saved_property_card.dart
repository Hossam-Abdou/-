import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../models/saved_property.dart';

class SavedPropertyCard extends StatelessWidget {
  final SavedProperty property;
  final VoidCallback onRemove;

  const SavedPropertyCard({super.key, required this.property, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(13),
      child: Row(

        children: [

          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.apartment, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(property.title, style: AppTextStyles.heading4, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(property.location, style: AppTextStyles.bodySmall, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(property.priceRange, style: AppTextStyles.priceLarge),
                  const SizedBox(width: 12),
                  Text(property.area, style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
          Spacer(),

          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.favorite, color: AppColors.error, size: 20),
          ),

        ],
      ),
    );
  }
}

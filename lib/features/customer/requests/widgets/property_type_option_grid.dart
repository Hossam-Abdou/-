import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Property types offered on the "what are you looking for" wizard.
/// Kept as plain Arabic strings (not localized) since these are data
/// values stored on [PropertyRequest.propertyType] — same convention
/// as the marketer's property-type list.
const List<String> requestPropertyTypeOptions = ['فيلا', 'شقة', 'أرض', 'استوديو', 'أخرى', 'مكتب'];

const Map<String, IconData> _requestTypeIcons = {
  'فيلا': Icons.villa_outlined,
  'شقة': Icons.apartment,
  'أرض': Icons.terrain,
  'استوديو': Icons.weekend_outlined,
  'أخرى': Icons.more_horiz,
  'مكتب': Icons.business_center_outlined,
};

/// A 2-column grid of icon cards (villa, apartment, land, studio,
/// office, other) — the property-type picker on step 1 of the
/// create-request wizard. Distinct from [PropertyTypeChips] (a pill
/// row) since the Figma design uses bigger selectable cards here.
class PropertyTypeOptionGrid extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PropertyTypeOptionGrid({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: requestPropertyTypeOptions.map((type) {
        final isSelected = type == selected;
        return _TypeCard(
          type: type,
          icon: _requestTypeIcons[type] ?? Icons.home_outlined,
          isSelected: isSelected,
          onTap: () => onChanged(type),
        );
      }).toList(),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({required this.type, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 26, color: isSelected ? AppColors.primary : AppColors.primaryDark),
                  const SizedBox(height: 8),
                  Text(
                    type,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              PositionedDirectional(
                top: 6,
                end: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 11, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

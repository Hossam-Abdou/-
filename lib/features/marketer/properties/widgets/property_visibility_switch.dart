import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/property_draft.dart';

/// "Show this property to all users" switch. Off = hidden: only its owner
/// sees it, it disappears from search and from customers' favorites.
class PropertyVisibilitySwitch extends StatefulWidget {
  final PropertyDraft draft;
  const PropertyVisibilitySwitch({super.key, required this.draft});

  @override
  State<PropertyVisibilitySwitch> createState() => _PropertyVisibilitySwitchState();
}

class _PropertyVisibilitySwitchState extends State<PropertyVisibilitySwitch> {
  @override
  Widget build(BuildContext context) {
    final visible = widget.draft.isPublished;
    return SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: visible,
        activeColor: AppColors.primary,
        onChanged: (v) => setState(() => widget.draft.isPublished = v),
        title: Text(LocaleKeys.propertyVisibleLabel.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.start),
        subtitle: Text(LocaleKeys.propertyVisibleHint.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.start),
        secondary: Icon(visible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.primaryDark),
      ),
    );
  }
}

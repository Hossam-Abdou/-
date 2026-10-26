import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/locations.dart';
import '../../../../core/shared/widgets/fields/app_select_field.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// City (required) + district (optional, depends on the city) dropdowns.
class LocationPickers extends StatelessWidget {
  final int? cityId;
  final int? districtId;
  final String? cityError;
  final ValueChanged<int?> onCity;
  final ValueChanged<int?> onDistrict;

  const LocationPickers({
    super.key,
    required this.cityId,
    required this.districtId,
    required this.cityError,
    required this.onCity,
    required this.onDistrict,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final districts = cityId == null ? const <District>[] : Locations.districtsOf(cityId!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(LocaleKeys.cityLabel.tr(), style: AppTextStyles.bodySmall),
        const SizedBox(height: 6),
        AppSelectField<int>(
          value: cityId,
          options: [for (final c in Locations.cities) SelectOption(c.id, c.name(lang))],
          placeholder: LocaleKeys.cityPlaceholder.tr(),
          sheetTitle: LocaleKeys.cityLabel.tr(),
          icon: Icons.location_city_outlined,
          errorText: cityError,
          onChanged: onCity,
        ),
        const SizedBox(height: 16),
        Text(LocaleKeys.districtLabel.tr(), style: AppTextStyles.bodySmall),
        const SizedBox(height: 6),
        AppSelectField<int>(
          key: ValueKey('district-$cityId'),
          value: districtId,
          options: [for (final d in districts) SelectOption(d.id, d.name(lang))],
          placeholder: LocaleKeys.districtPlaceholder.tr(),
          sheetTitle: LocaleKeys.districtLabel.tr(),
          icon: Icons.map_outlined,
          enabled: cityId != null,
          onChanged: onDistrict,
        ),
      ],
    );
  }
}

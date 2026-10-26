import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/data/locations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import 'location_row.dart';

typedef LocationChoice = ({int? cityId, int? districtId});

/// Opens [LocationSheet]; null when it is dismissed without a choice.
Future<LocationChoice?> showLocationSheet(BuildContext context, {int? cityId, int? districtId}) {
  return showModalBottomSheet<LocationChoice>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => LocationSheet(cityId: cityId, districtId: districtId),
  );
}

/// Bottom sheet: pick a city, then one of its districts (or the whole city).
class LocationSheet extends StatefulWidget {
  final int? cityId;
  final int? districtId;
  const LocationSheet({super.key, this.cityId, this.districtId});

  @override
  State<LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<LocationSheet> {
  late int? _city = widget.cityId;

  @override
  Widget build(BuildContext context) {
    final ar = context.locale.languageCode == 'ar';
    final districts = _city == null ? const <District>[] : Locations.districtsOf(_city!);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(LocaleKeys.locationPickTitle.tr(), style: AppTextStyles.heading3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LocationRow(
                label: LocaleKeys.locationAll.tr(),
                icon: Icons.public,
                selected: _city == null && widget.districtId == null,
                onTap: () => Navigator.pop<LocationChoice>(context, (cityId: null, districtId: null)),
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  for (final c in Locations.cities)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(ar ? c.nameAr : c.nameEn),
                        selected: _city == c.id,
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        side: BorderSide(color: _city == c.id ? AppColors.primary : AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: _city == c.id ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => setState(() => _city = c.id),
                      ),
                    ),
                ],
              ),
            ),
            if (_city != null)
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  children: [
                    LocationRow(
                      label: LocaleKeys.locationWholeCity.tr(),
                      icon: Icons.location_city_outlined,
                      selected: widget.cityId == _city && widget.districtId == null,
                      onTap: () => Navigator.pop<LocationChoice>(context, (cityId: _city, districtId: null)),
                    ),
                    for (final d in districts)
                      LocationRow(
                        label: ar ? d.nameAr : d.nameEn,
                        icon: Icons.place_outlined,
                        selected: widget.districtId == d.id,
                        onTap: () => Navigator.pop<LocationChoice>(context, (cityId: _city, districtId: d.id)),
                      ),
                  ],
                ),
              )
            else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

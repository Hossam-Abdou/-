import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../generated/locale_keys.g.dart';
import '../models/property_draft.dart';
import 'location_pickers.dart';

/// City (required, checked by the form's validation) and district (optional).
/// Writes [PropertyDraft.cityId] / [PropertyDraft.districtId].
class PropertyLocationField extends StatefulWidget {
  final PropertyDraft draft;
  const PropertyLocationField({super.key, required this.draft});

  @override
  State<PropertyLocationField> createState() => _PropertyLocationFieldState();
}

class _PropertyLocationFieldState extends State<PropertyLocationField> {
  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    return FormField<int>(
      initialValue: draft.cityId,
      validator: (city) => city == null ? LocaleKeys.propertyCityRequired.tr() : null,
      builder: (field) => LocationPickers(
        cityId: draft.cityId,
        districtId: draft.districtId,
        cityError: field.errorText,
        onCity: (id) {
          field.didChange(id);
          setState(() {
            draft.cityId = id;
            draft.districtId = null; // the districts belong to the city
          });
        },
        onDistrict: (id) => setState(() => draft.districtId = id),
      ),
    );
  }
}

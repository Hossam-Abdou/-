import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/property_type_chips.dart';
import '../models/property_draft.dart';

/// Which kind of property it is (apartment, villa...). Writes [PropertyDraft.propertyType].
class PropertyTypeField extends StatefulWidget {
  final PropertyDraft draft;
  const PropertyTypeField({super.key, required this.draft});

  @override
  State<PropertyTypeField> createState() => _PropertyTypeFieldState();
}

class _PropertyTypeFieldState extends State<PropertyTypeField> {
  @override
  Widget build(BuildContext context) {
    return PropertyTypeChips(
      selected: widget.draft.propertyType,
      onChanged: (type) => setState(() => widget.draft.propertyType = type),
    );
  }
}

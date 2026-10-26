import 'package:flutter/widgets.dart';

import '../../../listings/models/listing_model.dart';

/// The text controllers of the property form, created from the listing being
/// edited (or empty when adding). Owned by `PropertyFormCubit`, which disposes
/// them, so the screen does not have to keep any controller itself.
class PropertyFormControllers {
  final TextEditingController title;
  final TextEditingController area;
  final TextEditingController price; // sale price, or the monthly rent
  final TextEditingController lease; // lease length in months (rent only)
  final TextEditingController rooms;
  final TextEditingController baths;
  final TextEditingController description;

  PropertyFormControllers([ListingModel? l])
      : title = TextEditingController(text: l?.title ?? ''),
        area = TextEditingController(text: _num(l?.area)),
        price = TextEditingController(text: _num(l == null ? null : (l.isRent ? (l.rentMonthly ?? l.rentDaily) : l.price))),
        lease = TextEditingController(text: l?.leaseDurationMonths?.toString() ?? ''),
        rooms = TextEditingController(text: l?.rooms?.toString() ?? ''),
        baths = TextEditingController(text: l?.bathrooms?.toString() ?? ''),
        description = TextEditingController(text: l?.description ?? '');

  static String _num(double? v) => v == null ? '' : (v == v.roundToDouble() ? v.toInt().toString() : v.toString());

  void dispose() {
    for (final c in [title, area, price, lease, rooms, baths, description]) {
      c.dispose();
    }
  }
}

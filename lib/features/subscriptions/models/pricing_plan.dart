import 'package:easy_localization/easy_localization.dart';
import '../../../generated/locale_keys.g.dart';

class PricingPlan {
  final String id;
  final int months;
  final double price;
  final double? originalPrice;
  final bool isPopular;

  const PricingPlan({
    required this.id,
    required this.months,
    required this.price,
    this.originalPrice,
    this.isPopular = false,
  });

  double get monthlyEquivalent => price / months;

  int? get savingsPercent {
    if (originalPrice == null || originalPrice == 0) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  /// Duration label comes from easy_localization instead of being
  /// hardcoded in the model, so the same plan renders correctly in
  /// Arabic or English depending on the active locale.
  String get durationLabel {
    switch (months) {
      case 1:
        return LocaleKeys.oneMonth.tr();
      case 3:
        return LocaleKeys.threeMonths.tr();
      case 6:
        return LocaleKeys.sixMonths.tr();
      default:
        return '$months';
    }
  }
}

/// Mock data standing in for the backend response until it's connected.
const List<PricingPlan> mockPricingPlans = [
  PricingPlan(id: 'm1', months: 1, price: 149),
  PricingPlan(id: 'm3', months: 3, price: 349, originalPrice: 447, isPopular: true),
  PricingPlan(id: 'm6', months: 6, price: 599, originalPrice: 894),
];

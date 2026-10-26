import '../../../core/utils/json_utils.dart';

class PlanModel {
  final String id; // m1 | m3 | m6
  final int months;
  final double price;
  final double? originalPrice;
  final bool isPopular;

  const PlanModel({
    required this.id,
    required this.months,
    required this.price,
    this.originalPrice,
    this.isPopular = false,
  });

  factory PlanModel.fromJson(Map<String, dynamic> j) => PlanModel(
        id: '${j['id']}',
        months: toInt(j['months']) ?? 0,
        price: toDouble(j['price']) ?? 0,
        originalPrice: toDouble(j['original_price']),
        isPopular: j['is_popular'] == true,
      );
}

class SubscriptionModel {
  final String id;
  final String planId;
  final String status;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final PlanModel? plan;

  const SubscriptionModel({
    required this.id,
    required this.planId,
    this.status = 'active',
    this.startsAt,
    this.endsAt,
    this.plan,
  });

  bool get isActive => status == 'active' && (endsAt == null || endsAt!.isAfter(DateTime.now()));

  factory SubscriptionModel.fromJson(Map<String, dynamic> j) => SubscriptionModel(
        id: '${j['id']}',
        planId: '${j['plan_id']}',
        status: '${j['status'] ?? 'active'}',
        startsAt: toDate(j['started_at']),
        endsAt: toDate(j['expires_at']),
        plan: j['plan'] is Map ? PlanModel.fromJson(Map<String, dynamic>.from(j['plan'])) : null,
      );
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../data/subscriptions_repository.dart';
import '../models/subscription_models.dart';

class SubscriptionsState {
  final ApiStatus status;
  final List<PlanModel> plans;
  final SubscriptionModel? current;
  final ApiException? error;

  const SubscriptionsState({this.status = ApiStatus.initial, this.plans = const [], this.current, this.error});

  bool get isLoading => status == ApiStatus.loading;

  SubscriptionsState copyWith({
    ApiStatus? status,
    List<PlanModel>? plans,
    SubscriptionModel? Function()? current,
    ApiException? Function()? error,
  }) =>
      SubscriptionsState(
        status: status ?? this.status,
        plans: plans ?? this.plans,
        current: current != null ? current() : this.current,
        error: error != null ? error() : this.error,
      );
}

/// Pricing screen: the plans plus the marketer's current subscription.
class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  SubscriptionsCubit(this.subscriptionsRepository) : super(const SubscriptionsState());
  final SubscriptionsRepository subscriptionsRepository;

  Future<bool> load() async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final plans = await subscriptionsRepository.plans();
      final current = await subscriptionsRepository.current();
      emit(state.copyWith(status: ApiStatus.success, plans: plans, current: () => current));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> subscribe(String planId) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final s = await subscriptionsRepository.subscribe(planId);
      emit(state.copyWith(status: ApiStatus.success, current: () => s));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}

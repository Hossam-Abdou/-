import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/cubit/api_state.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../offers/cubit/offers_cubit.dart';
import '../../../offers/models/offer_model.dart';
import '../../../requests/cubit/requests_cubit.dart';
import '../../../requests/models/request_model.dart';
import 'marketer_request.dart';

/// Shapes a backend [RequestModel] into the [MarketerRequest] the marketer
/// cards / details / search already use.
extension MarketerRequestPreview on RequestModel {
  MarketerRequest toMarketerPreview({bool offerSent = false}) {
    final nf = NumberFormat.decimalPattern('en');
    String range(double? a, double? b, String suffix) {
      if (a == null && b == null) return '';
      if (a != null && b != null) return '${nf.format(a)} - ${nf.format(b)}$suffix';
      return '${nf.format(a ?? b)}$suffix';
    }

    final name = customer?.fullName;
    return MarketerRequest(
      id: id,
      customerId: customerId,
      customerName: (name == null || name.isEmpty) ? LocaleKeys.customerFallbackName.tr() : name,
      propertyType: propertyType ?? '',
      location: [districtNameAr, cityNameAr].whereType<String>().join('، '),
      bedsLabel: rooms == null ? '-' : '$rooms ${LocaleKeys.specRooms.tr()}',
      bathsLabel: bathrooms == null ? '-' : '$bathrooms ${LocaleKeys.specBathrooms.tr()}',
      areaLabel: range(areaFrom, areaTo, ' م²'),
      budgetRange: range(budgetFrom, budgetTo, ' ج.م'),
      description: description ?? '',
      status: offerSent ? MarketerRequestStatus.offerSent : MarketerRequestStatus.none,
      createdAt: createdAt,
    );
  }
}

/// Rebuilds [mockMarketerRequests] from the loaded requests + the marketer's
/// own offers (a request with an offer is marked `offerSent`).
List<MarketerRequest> syncMarketerRequests(List<RequestModel> requests, List<OfferModel> offers) {
  final sent = {for (final o in offers) o.requestId};
  final seen = <String>{};
  final out = <MarketerRequest>[];
  for (final r in requests) {
    if (r.isClosed && !sent.contains(r.id)) continue;
    if (seen.add(r.id)) out.add(r.toMarketerPreview(offerSent: sent.contains(r.id)));
  }
  // Requests I offered on that are no longer in the open list (e.g. closed).
  for (final o in offers) {
    final r = o.request;
    if (r != null && seen.add(r.id)) out.add(r.toMarketerPreview(offerSent: true));
  }
  mockMarketerRequests
    ..clear()
    ..addAll(out);
  return out;
}

/// Loads the open requests and the marketer's offers.
Future<void> loadMarketerRequests(BuildContext context) => Future.wait([
      context.read<RequestsCubit>().load(),
      context.read<OffersCubit>().load(),
    ]);

/// Rebuilds [builder] whenever requests or offers change.
class MarketerRequestsBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, List<MarketerRequest> requests, bool loading) builder;
  const MarketerRequestsBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, ApiState<RequestModel>>(
      builder: (context, rs) => BlocBuilder<OffersCubit, ApiState<OfferModel>>(
        builder: (context, os) {
          final list = syncMarketerRequests(rs.items, os.items);
          return builder(context, list, rs.isLoading || os.isLoading);
        },
      ),
    );
  }
}

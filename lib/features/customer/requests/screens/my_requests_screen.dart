import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/cubit/api_state.dart';
import '../../../listings/widgets/listings_message.dart';
import '../../../requests/cubit/requests_cubit.dart';
import '../../../requests/models/request_model.dart';
import '../../../requests/models/request_preview.dart';
import '../../home/models/property_request.dart';
import '../widgets/tracked_request_card.dart';

/// Content for the client "My Requests" tab only — no Scaffold/bottom
/// nav here, [ClientShellScreen] owns those.
///
/// Distinct from [HomeScreen]: home is for browsing/searching (with a
/// short "recent main_layout" preview); this tab is for tracking the
/// main_layout the client has already posted themselves, by status.
class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

enum _RequestFilter { all, active, closed }

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  _RequestFilter _filter = _RequestFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<RequestsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsCubit, ApiState<RequestModel>>(
      // Keep the shared request cache (used by details / edit) in step with the server.
      listenWhen: (a, b) => b.status == ApiStatus.success,
      listener: (context, state) {
        mockRecentRequests
          ..clear()
          ..addAll(state.items.map((r) => r.toPreview()));
      },
      builder: (context, state) => _buildList(context, state),
    );
  }

  Widget _buildList(BuildContext context, ApiState<RequestModel> state) {
    final all = state.items.map((r) => r.toPreview()).toList();
    final requests = all.where((r) {
      switch (_filter) {
        case _RequestFilter.all:
          return true;
        case _RequestFilter.active:
          return r.status != PropertyRequestStatus.closed;
        case _RequestFilter.closed:
          return r.status == PropertyRequestStatus.closed;
      }
    }).toList();

    final message = ListingsMessage.of(state, () => context.read<RequestsCubit>().load());
    final loadingOrError = message != null && state.items.isEmpty && state.status != ApiStatus.success;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<RequestsCubit>().load(),
        child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            LocaleKeys.myRequestsTitle.tr(args: ['${all.length}']),
            style: AppTextStyles.heading2,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _FilterTab(label: LocaleKeys.filterAllTab.tr(), selected: _filter == _RequestFilter.all, onTap: () => setState(() => _filter = _RequestFilter.all)),
              const SizedBox(width: 8),
              _FilterTab(label: LocaleKeys.filterActiveTab.tr(), selected: _filter == _RequestFilter.active, onTap: () => setState(() => _filter = _RequestFilter.active)),
              const SizedBox(width: 8),
              _FilterTab(label: LocaleKeys.filterClosedTab.tr(), selected: _filter == _RequestFilter.closed, onTap: () => setState(() => _filter = _RequestFilter.closed)),
            ],
          ),
          const SizedBox(height: 16),
          if (loadingOrError)
            message
          else if (requests.isEmpty)
            const _EmptyState()
          else
            ...requests.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TrackedRequestCard(
                  request: r,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: r.id),
                ),
              ),
            ),
          const SizedBox(height: 8),
          AppPrimaryButton(
            label: LocaleKeys.createRequestButton.tr(),
            icon: Icons.add,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createRequestLocation),
          ),
        ],
      ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: selected ? Colors.white : AppColors.textPrimary)),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.assignment_outlined, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(LocaleKeys.noRequestsTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(LocaleKeys.noRequestsDesc.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

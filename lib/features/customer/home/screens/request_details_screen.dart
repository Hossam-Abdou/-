import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/skeleton_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_error_text.dart';
import '../../../../core/shared/cubit/api_state.dart';
import '../../../offers/models/offer_preview_mapper.dart';
import '../../../requests/cubit/requests_cubit.dart';
import '../../../requests/models/request_model.dart';
import '../../../requests/models/request_preview.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/property_image_strip.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/shared/widgets/date_time_label.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/offer_preview.dart';
import '../widgets/request_status_title_card.dart';
import '../widgets/request_budget_card.dart';
import '../widgets/request_spec_card.dart';
import '../widgets/request_notes_card.dart';
import '../widgets/request_offer_card.dart';
import '../widgets/request_actions_bar.dart';
import '../widgets/request_offers_section.dart';
import '../models/property_request.dart';

/// Full detail view for a single client request + a preview of the
/// offers received on it, matching the Figma design (status badge,
/// budget bento card, spec grid, notes, inline offer previews, and a
/// bottom edit/pause action bar). Opened from a [RequestCard] on the
/// home tab or from search results.
///
/// Takes the request's id through `settings.arguments` (see
/// [AppRoutes.requestDetails]) and looks it up from the mock data —
/// swap [findPropertyRequestById] for a repository call once the
/// backend is wired up.
class RequestDetailsScreen extends StatefulWidget {
  final PropertyRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Loads the request together with the offers marketers sent on it.
    context.read<RequestsCubit>().open(widget.request.id);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return BlocConsumer<RequestsCubit, ApiState<RequestModel>>(
      // Make the loaded offers findable by the offer details screen.
      listenWhen: (a, b) => b.selected?.id == widget.request.id && a.selected != b.selected,
      listener: (context, state) =>
          setOfferPreviews(widget.request.id, [for (final o in state.selected!.offers) o.toPreview(lang)]),
      builder: (context, state) {
        final loaded = state.selected?.id == widget.request.id ? state.selected : null;
        final request = loaded?.toPreview() ?? widget.request;
        final offers = loaded == null ? <OfferPreview>[] : [for (final o in loaded.offers) o.toPreview(lang)];
        final loading = loaded == null && state.isLoading;
        return _buildScaffold(context, request, offers, loading);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, PropertyRequest request, List<OfferPreview> offers, bool loading) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.requestDetailsTitle.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.primaryDark)),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<RequestsCubit>().open(request.id),
          child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            RequestStatusTitleCard(request: request),
            const SizedBox(height: 16),
            RequestBudgetCard(priceRange: request.priceRange),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: RequestSpecCard(icon: Icons.bathtub_outlined, label: LocaleKeys.specBathrooms.tr(), value: '${request.bathrooms}')),
                const SizedBox(width: 16),
                Expanded(child: RequestSpecCard(icon: Icons.bed_outlined, label: LocaleKeys.specRooms.tr(), value: '${request.rooms}')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: RequestSpecCard(icon: Icons.brush_outlined, label: LocaleKeys.specFinishing.tr(), value: request.finishing)),
                const SizedBox(width: 16),
                Expanded(child: RequestSpecCard(icon: Icons.straighten, label: LocaleKeys.specArea.tr(), value: request.area)),
              ],
            ),
            const SizedBox(height: 16),
            RequestNotesCard(description: request.description),
            const SizedBox(height: 24),
            RequestOffersSection(
              count: offers.isEmpty ? request.offersCount : offers.length,
              offers: offers,
              loading: loading,
            ),
          ],
        ),
        ),
      ),
      bottomNavigationBar: RequestActionsBar(request: request),
    );
  }
}


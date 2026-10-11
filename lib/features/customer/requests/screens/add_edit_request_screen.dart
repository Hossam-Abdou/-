import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../core/shared/widgets/sticky_bottom_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../home/models/property_request.dart';
import '../widgets/labeled_dropdown_field.dart';
import '../widgets/property_type_option_grid.dart';
import '../widgets/range_field_row.dart';
import '../widgets/request_form_options.dart';
import '../widgets/request_review_row.dart';
import '../widgets/request_step_progress.dart';

/// Add-request and edit-request share this one 4-step wizard (type ->
/// location -> details -> review & publish), mirroring the Figma
/// flow: when [existingRequest] is null it's add mode (empty fields,
/// "Publish Request" on the last step); when it's provided the
/// fields are pre-filled and the wizard opens straight to step 1 in
/// edit mode.
///
/// Submission is simulated: there's no backend yet, so this shows a
/// success dialog and pops back — swap `_submit` for a real API call
/// once [mockRecentRequests] is replaced by a repository.
class AddEditRequestScreen extends StatefulWidget {
  final PropertyRequest? existingRequest;

  const AddEditRequestScreen({super.key, this.existingRequest});

  @override
  State<AddEditRequestScreen> createState() => _AddEditRequestScreenState();
}

class _AddEditRequestScreenState extends State<AddEditRequestScreen> {
  static const _totalSteps = 4;

  int _currentStep = 1;
  bool _submitting = false;

  late String _selectedType;
  String? _city;
  String? _district;
  String? _compound;
  late final TextEditingController _budgetFromController;
  late final TextEditingController _budgetToController;
  late final TextEditingController _areaFromController;
  late final TextEditingController _areaToController;
  String? _rooms;
  String? _bathrooms;
  String? _finishing;
  late final TextEditingController _notesController;

  bool get _isEditMode => widget.existingRequest != null;

  @override
  void initState() {
    super.initState();
    final r = widget.existingRequest;

    _selectedType = (r != null && requestPropertyTypeOptions.contains(r.propertyType)) ? r.propertyType : requestPropertyTypeOptions.first;

    if (r != null && r.location.contains('،')) {
      final parts = r.location.split('،').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (parts.isNotEmpty) _district = parts.first;
      if (parts.length > 1) _city = requestCityOptions.contains(parts.last) ? parts.last : null;
    }

    final priceParts = r?.priceRange.split('-').map((e) => e.trim().replaceAll(RegExp('[^0-9]'), '')).toList() ?? const [];
    _budgetFromController = TextEditingController(text: priceParts.isNotEmpty ? priceParts[0] : '');
    _budgetToController = TextEditingController(text: priceParts.length > 1 ? priceParts[1] : '');

    final areaParts = r?.area.split('-').map((e) => e.trim().replaceAll(RegExp('[^0-9]'), '')).toList() ?? const [];
    _areaFromController = TextEditingController(text: areaParts.isNotEmpty ? areaParts[0] : '');
    _areaToController = TextEditingController(text: areaParts.length > 1 ? areaParts[1] : '');

    _rooms = r != null && requestRoomsOptions.contains('${r.rooms}') ? '${r.rooms}' : null;
    _bathrooms = r != null && requestBathroomsOptions.contains('${r.bathrooms}') ? '${r.bathrooms}' : null;
    _finishing = r != null && requestFinishingOptions.contains(r.finishing) ? r.finishing : null;
    _notesController = TextEditingController(text: r?.description ?? '');
  }

  @override
  void dispose() {
    _budgetFromController.dispose();
    _budgetToController.dispose();
    _areaFromController.dispose();
    _areaToController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _goBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  String get _locationSummary {
    final parts = <String>[];
    if (_district != null && _district!.isNotEmpty) parts.add(_district!);
    if (_compound != null && _compound != requestCompoundOptions.first) parts.add(_compound!);
    if (_city != null && _city!.isNotEmpty) parts.add(_city!);
    if (parts.isNotEmpty) return parts.join('، ');
    return widget.existingRequest?.location ?? '';
  }

  String get _budgetSummary {
    final from = _budgetFromController.text.trim();
    final to = _budgetToController.text.trim();
    if (from.isEmpty && to.isEmpty) return widget.existingRequest?.priceRange ?? '';
    return '$from - $to ج.م';
  }

  String get _areaSummary {
    final from = _areaFromController.text.trim();
    final to = _areaToController.text.trim();
    if (from.isEmpty && to.isEmpty) return widget.existingRequest?.area ?? '';
    return '$from - $toم';
  }

  String get _roomsBathroomsSummary {
    final buffer = <String>[];
    if (_rooms != null) buffer.add('$_rooms غرف نوم');
    if (_bathrooms != null) buffer.add('$_bathrooms حمام');
    return buffer.isEmpty ? LocaleKeys.noneOptionLabel.tr() : buffer.join('، ');
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);

    final request = PropertyRequest(
      id: widget.existingRequest?.id ?? 'req-${DateTime.now().millisecondsSinceEpoch}',
      title: widget.existingRequest?.title ?? 'مطلوب $_selectedType',
      location: _locationSummary,
      area: _areaSummary,
      rooms: int.tryParse(_rooms?.replaceAll('+', '') ?? '') ?? 0,
      bathrooms: int.tryParse(_bathrooms?.replaceAll('+', '') ?? '') ?? 0,
      priceRange: _budgetSummary,
      propertyType: _selectedType,
      finishing: _finishing ?? '',
      description: _notesController.text.trim(),
      isNew: widget.existingRequest?.isNew ?? true,
      status: widget.existingRequest?.status ?? PropertyRequestStatus.open,
      offersCount: widget.existingRequest?.offersCount ?? 0,
    );

    if (_isEditMode) {
      updatePropertyRequest(request);
    } else {
      addPropertyRequest(request);
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(LocaleKeys.requestSavedSuccessTitle.tr(), style: AppTextStyles.heading4),
          ],
        ),
        content: Text(
          (_isEditMode ? LocaleKeys.requestUpdatedSuccessDesc : LocaleKeys.requestAddedSuccessDesc).tr(),
          style: AppTextStyles.bodyRegular,
          textAlign: TextAlign.start,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(LocaleKeys.okButton.tr())),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          // `matchTextDirection` mirrors the arrow under RTL on its
          // own; the close (X) icon is symmetric so it's unaffected.
          icon: Icon(
            _currentStep == 1 ? Icons.close : Icons.arrow_back,
            color: AppColors.primaryDark,

          ),
          onPressed: _goBack,
        ),
        title: Text((_isEditMode ? LocaleKeys.editRequestTitle : LocaleKeys.addRequestTitle).tr(), style: AppTextStyles.heading3),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: RequestStepProgress(
                currentStep: _currentStep,
                labels: [
                  LocaleKeys.stepTypeLabel.tr(),
                  LocaleKeys.propertyLocationLabel.tr(),
                  LocaleKeys.stepDetailsLabel.tr(),
                  LocaleKeys.stepConfirmLabel.tr(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: _buildStepBody(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepBody() {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(LocaleKeys.propertyTypeLabel.tr(), style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            PropertyTypeOptionGrid(selected: _selectedType, onChanged: (type) => setState(() => _selectedType = type)),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(LocaleKeys.propertyLocationLabel.tr(), style: AppTextStyles.heading2),
            const SizedBox(height: 6),
            Text(LocaleKeys.locationStepSubtitle.tr(), style: AppTextStyles.bodySmall),
            const SizedBox(height: 20),
            LabeledDropdownField(
              label: LocaleKeys.cityLabel.tr(),
              icon: Icons.location_city_outlined,
              value: _city,
              placeholder: LocaleKeys.cityPlaceholder.tr(),
              options: requestCityOptions,
              onChanged: (value) => setState(() {
                _city = value;
                _district = null;
              }),
            ),
            const SizedBox(height: 16),
            LabeledDropdownField(
              label: LocaleKeys.districtLabel.tr(),
              icon: Icons.map_outlined,
              value: _district,
              placeholder: LocaleKeys.districtPlaceholder.tr(),
              options: _city != null ? (requestDistrictsByCity[_city] ?? const []) : const [],
              enabled: _city != null,
              onChanged: (value) => setState(() => _district = value),
            ),
            const SizedBox(height: 16),
            LabeledDropdownField(
              label: LocaleKeys.compoundLabel.tr(),
              icon: Icons.holiday_village_outlined,
              value: _compound,
              placeholder: LocaleKeys.compoundPlaceholder.tr(),
              options: requestCompoundOptions,
              onChanged: (value) => setState(() => _compound = value),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(LocaleKeys.propertyDetailsStepTitle.tr(), style: AppTextStyles.heading2),
            const SizedBox(height: 20),
            RangeFieldRow(
              label: LocaleKeys.budgetCurrencyLabel.tr(),
              icon: Icons.payments_outlined,
              fromController: _budgetFromController,
              toController: _budgetToController,
              fromLabel: LocaleKeys.fromLabel.tr(),
              toLabel: LocaleKeys.toLabel.tr(),
              fromHint: LocaleKeys.budgetFromHint.tr(),
              toHint: LocaleKeys.budgetToHint.tr(),
            ),
            const SizedBox(height: 20),
            RangeFieldRow(
              label: LocaleKeys.areaSqmLabel.tr(),
              icon: Icons.square_foot_outlined,
              fromController: _areaFromController,
              toController: _areaToController,
              fromLabel: LocaleKeys.fromLabel.tr(),
              toLabel: LocaleKeys.toLabel.tr(),
              fromHint: LocaleKeys.areaFromHint.tr(),
              toHint: LocaleKeys.areaToHint.tr(),
            ),
            const SizedBox(height: 20),
            LabeledDropdownField(
              label: LocaleKeys.specRooms.tr(),
              icon: Icons.king_bed_outlined,
              value: _rooms,
              placeholder: LocaleKeys.noneOptionLabel.tr(),
              options: requestRoomsOptions,
              onChanged: (value) => setState(() => _rooms = value),
            ),
            const SizedBox(height: 16),
            LabeledDropdownField(
              label: LocaleKeys.specBathrooms.tr(),
              icon: Icons.bathtub_outlined,
              value: _bathrooms,
              placeholder: LocaleKeys.noneOptionLabel.tr(),
              options: requestBathroomsOptions,
              onChanged: (value) => setState(() => _bathrooms = value),
            ),
            const SizedBox(height: 16),
            LabeledDropdownField(
              label: LocaleKeys.specFinishing.tr(),
              icon: Icons.format_paint_outlined,
              value: _finishing,
              placeholder: LocaleKeys.anyFinishingOptionLabel.tr(),
              options: requestFinishingOptions,
              onChanged: (value) => setState(() => _finishing = value),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(LocaleKeys.additionalNotesLabel.tr(), style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    hintText: LocaleKeys.additionalNotesPlaceholder.tr(),
                    hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    hintMaxLines: 3,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return _buildReviewStep();
    }
  }

  Widget _buildReviewStep() {
    final notes = _notesController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(LocaleKeys.reviewStepFootnote.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 14),
        Text(LocaleKeys.requestDetailsTitle.tr(), style: AppTextStyles.heading2),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              RequestReviewRow(icon: Icons.apartment, label: LocaleKeys.propertyTypeLabel.tr(), value: _selectedType),
              const Divider(height: 1, color: AppColors.border),
              RequestReviewRow(
                icon: Icons.location_on_outlined,
                label: LocaleKeys.propertyLocationLabel.tr(),
                value: _locationSummary.isEmpty ? LocaleKeys.noneOptionLabel.tr() : _locationSummary,
                tinted: true,
              ),
              const Divider(height: 1, color: AppColors.border),
              RequestReviewRow(
                icon: Icons.payments_outlined,
                label: LocaleKeys.budgetLabel.tr(),
                value: _budgetSummary.isEmpty ? LocaleKeys.noneOptionLabel.tr() : _budgetSummary,
                valueStyle: AppTextStyles.priceLarge,
              ),
              const Divider(height: 1, color: AppColors.border),
              RequestReviewRow(
                icon: Icons.square_foot_outlined,
                label: LocaleKeys.specArea.tr(),
                value: _areaSummary.isEmpty ? LocaleKeys.noneOptionLabel.tr() : _areaSummary,
                tinted: true,
              ),
              const Divider(height: 1, color: AppColors.border),
              RequestReviewRow(icon: Icons.king_bed_outlined, label: LocaleKeys.specRooms.tr(), value: _roomsBathroomsSummary),
            ],
          ),
        ),
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(LocaleKeys.additionalNotesLabel.tr(), style: AppTextStyles.heading4),
              const SizedBox(width: 6),
              const Icon(Icons.notes_outlined, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(notes, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.start),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar() {
    if (_currentStep == _totalSteps) {
      return StickyBottomBar(
        buttonLabel: LocaleKeys.publishRequestButton.tr(),
        icon: Icons.send_outlined,
        isLoading: _submitting,
        onPressed: _submitting ? null : _goNext,
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _currentStep == 1 ? LocaleKeys.cancelButton.tr() : LocaleKeys.previousButton.tr(),
                  style: AppTextStyles.button.copyWith(color: AppColors.primaryDark),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: _currentStep == 1 ? 2 : 1,
              child: AppPrimaryButton(label: LocaleKeys.nextButton.tr(), onPressed: _goNext),
            ),
          ],
        ),
      ),
    );
  }
}

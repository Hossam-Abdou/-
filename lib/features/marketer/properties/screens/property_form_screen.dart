import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/fields/app_number_field.dart';
import '../../../../core/shared/widgets/fields/validated_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../models/property_draft.dart';
import '../widgets/delete_property_button.dart';
import '../widgets/listing_type_chips.dart';
import '../widgets/property_location_field.dart';
import '../widgets/property_photos_field.dart';
import '../widgets/property_type_field.dart';
import '../widgets/property_visibility_switch.dart';
import '../widgets/save_property_button.dart';

/// Add-property and edit-property share this form ([existingId] null = add).
/// The screen only lays out the form: every field is its own widget that
/// writes into a [PropertyDraft], and the save / delete buttons do the work.
class PropertyFormScreen extends StatefulWidget {
  final String? existingId;
  const PropertyFormScreen({super.key, this.existingId});

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final PropertyDraft _draft = PropertyDraft.from(
    widget.existingId == null ? null : context.read<MyListingsCubit>().state.items.where((e) => e.id == widget.existingId).firstOrNull,
  );

  bool get _isEdit => widget.existingId != null;

  @override
  Widget build(BuildContext context) {
    final isRent = _draft.isRent; // sale shows the price, rent shows rent + lease length
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text((_isEdit ? LocaleKeys.editPropertyTitle : LocaleKeys.addPropertyTitle).tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              PropertyPhotosField(draft: _draft, existingId: widget.existingId),
              const SizedBox(height: 12),
              ValidatedTextField(
                initialValue: _draft.title,
                onChanged: (v) => _draft.title = v,
                label: LocaleKeys.offerPropertyTitleLabel.tr(),
                hint: LocaleKeys.hintPropertyTitle.tr(),
              ),
              const SizedBox(height: 16),
              PropertyTypeField(draft: _draft),
              const SizedBox(height: 16),
              ListingTypeChips(value: _draft.listingType, onChanged: (v) => setState(() => _draft.listingType = v)),
              const SizedBox(height: 16),
              PropertyLocationField(draft: _draft),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppNumberField(
                      initialValue: _draft.area,
                      onChanged: (v) => _draft.area = v,
                      label: LocaleKeys.specArea.tr(),
                      hint: LocaleKeys.hintArea.tr(),
                      unit: 'م²',
                      allowDecimal: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppNumberField(
                      key: ValueKey('price-$isRent'), // a fresh field when switching sale <-> rent
                      initialValue: _draft.price,
                      onChanged: (v) => _draft.price = v,
                      label: (isRent ? LocaleKeys.propertyRentMonthlyLabel : LocaleKeys.propertyPriceLabel).tr(),
                      hint: (isRent ? LocaleKeys.hintRent : LocaleKeys.hintPrice).tr(),
                      allowDecimal: true,
                    ),
                  ),
                ],
              ),
              if (isRent) ...[
                const SizedBox(height: 16),
                AppNumberField(
                  initialValue: _draft.leaseMonths,
                  onChanged: (v) => _draft.leaseMonths = v,
                  label: LocaleKeys.propertyLeaseMonthsLabel.tr(),
                  hint: LocaleKeys.hintLease.tr(),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppNumberField(
                      initialValue: _draft.rooms,
                      onChanged: (v) => _draft.rooms = v,
                      label: LocaleKeys.specRooms.tr(),
                      hint: LocaleKeys.hintRooms.tr(),
                      required: false,
                      allowZero: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppNumberField(
                      initialValue: _draft.bathrooms,
                      onChanged: (v) => _draft.bathrooms = v,
                      label: LocaleKeys.specBathrooms.tr(),
                      hint: LocaleKeys.hintBaths.tr(),
                      required: false,
                      allowZero: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValidatedTextField(
                initialValue: _draft.description,
                onChanged: (v) => _draft.description = v,
                label: LocaleKeys.propertyDescriptionLabel.tr(),
                hint: LocaleKeys.hintPropertyDescription.tr(),
                maxLines: 4,
                required: false,
              ),
              const SizedBox(height: 16),
              PropertyVisibilitySwitch(draft: _draft),
              const SizedBox(height: 28),
              SavePropertyButton(formKey: _formKey, draft: _draft, existingId: widget.existingId),
              if (_isEdit) ...[
                const SizedBox(height: 12),
                DeletePropertyButton(propertyId: widget.existingId!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

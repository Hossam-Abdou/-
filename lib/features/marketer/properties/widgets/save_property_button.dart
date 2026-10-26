import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error_text.dart';
import '../../../../core/network/storage_service.dart';
import '../../../../core/shared/widgets/app_snack_bar.dart';
import '../../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../models/property_draft.dart';
import 'property_dialogs.dart';

/// Validates the form, uploads the photos to Storage, then creates (or
/// updates) the listing through [MyListingsCubit] and closes the screen.
class SavePropertyButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final PropertyDraft draft;
  final String? existingId; // null = add mode

  const SavePropertyButton({super.key, required this.formKey, required this.draft, this.existingId});

  @override
  State<SavePropertyButton> createState() => _SavePropertyButtonState();
}

class _SavePropertyButtonState extends State<SavePropertyButton> {
  bool _saving = false;

  bool get _isEdit => widget.existingId != null;

  Future<void> _save() async {
    if (!widget.formKey.currentState!.validate()) return;
    final draft = widget.draft;
    final listings = context.read<MyListingsCubit>();
    final navigator = Navigator.of(context);
    setState(() => _saving = true);

    // 1) photos -> Storage (links and already uploaded photos are kept as they are)
    final List<String> urls;
    try {
      urls = await StorageService().uploadAll(
        StorageService.propertyImages,
        widget.existingId ?? 'new-${DateTime.now().millisecondsSinceEpoch}',
        draft.images,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnackBar(context, e.status == null ? e.text : LocaleKeys.propertyUploadFailed.tr(), isError: true);
      return;
    }

    // 2) the listing itself
    final bool ok;
    if (_isEdit) {
      ok = await listings.update(widget.existingId!, draft.toUpdateFields());
      // photos the marketer took out of the form are removed from the listing
      final removed = [for (final u in draft.originalImages) if (!urls.contains(u)) u];
      final added = [for (final u in urls) if (!draft.originalImages.contains(u)) u];
      if (ok && removed.isNotEmpty) await listings.removeImages(widget.existingId!, removed);
      if (ok && added.isNotEmpty) await listings.addImages(widget.existingId!, added);
    } else {
      ok = await listings.create(draft.toInput(urls));
    }
    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      showAppSnackBar(context, listings.state.error?.text ?? LocaleKeys.apiErrGeneric.tr(), isError: true);
      return;
    }
    listings.load(); // refresh covers / counts
    await showPropertySavedDialog(context, edited: _isEdit);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: (_isEdit ? LocaleKeys.savePropertyButton : LocaleKeys.addPropertySubmit).tr(),
      icon: Icons.check,
      isLoading: _saving,
      onPressed: _saving ? null : _save,
    );
  }
}

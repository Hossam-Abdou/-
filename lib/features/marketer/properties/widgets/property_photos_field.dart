import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/shared/widgets/fields/multi_image_picker_field.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../models/property_draft.dart';
import 'property_dialogs.dart';

/// The photos of the property: pick from the gallery, add by link, remove.
/// Keeps [PropertyDraft.images] up to date. In edit mode it first loads the
/// full photo set (the list rows only carry the cover).
class PropertyPhotosField extends StatefulWidget {
  final PropertyDraft draft;
  final String? existingId;
  const PropertyPhotosField({super.key, required this.draft, this.existingId});

  @override
  State<PropertyPhotosField> createState() => _PropertyPhotosFieldState();
}

class _PropertyPhotosFieldState extends State<PropertyPhotosField> {
  List<String> get _images => widget.draft.images;

  @override
  void initState() {
    super.initState();
    final id = widget.existingId;
    if (id != null) _loadAll(id);
  }

  Future<void> _loadAll(String id) async {
    try {
      final full = await context.read<MyListingsCubit>().listingsRepository.details(id);
      if (!mounted || full.images.isEmpty) return;
      setState(() {
        widget.draft.images = List.of(full.images);
        widget.draft.originalImages = List.of(full.images);
      });
    } on ApiException {
      // keep the cover we already have
    }
  }

  Future<void> _pick() async {
    // Gallery only — the camera needs an extra Android manifest permission.
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty && mounted) setState(() => _images.addAll(picked.map((x) => x.path)));
  }

  bool _addLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https') || uri.host.isEmpty) return false;
    if (!_images.contains(link)) setState(() => _images.add(link));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultiImagePickerField(
          imagePaths: _images,
          onAdd: _pick,
          onRemove: (i) => setState(() => _images.removeAt(i)),
          label: LocaleKeys.propertyPhotoLabel.tr(),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: () => showImageLinkDialog(context, isValid: _addLink),
            icon: const Icon(Icons.link, size: 18),
            label: Text(LocaleKeys.propertyAddImageLink.tr()),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/storage_service.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../listings/models/listing_model.dart';
import 'property_form_controllers.dart';

/// One-shot results the screen reacts to (dialog, snack bar, closing).
enum PropertyFormEvent { saved, deleted, uploadFailed, failed }

class PropertyFormState {
  final String listingType; // sale | rent
  final String propertyType;
  final int? cityId;
  final int? districtId;
  final List<String> images; // local file paths and/or http(s) links
  final bool isPublished; // shown to all users, or hidden (only the marketer sees it)
  final bool submitting;
  final bool cityMissing;
  final PropertyFormEvent? event; // not carried over: only set by the emit that fires it
  final ApiException? error;

  const PropertyFormState({
    required this.listingType,
    required this.propertyType,
    this.cityId,
    this.districtId,
    this.images = const [],
    this.isPublished = true,
    this.submitting = false,
    this.cityMissing = false,
    this.event,
    this.error,
  });

  PropertyFormState copyWith({
    String? listingType,
    String? propertyType,
    int? Function()? cityId,
    int? Function()? districtId,
    List<String>? images,
    bool? isPublished,
    bool? submitting,
    bool? cityMissing,
    PropertyFormEvent? event,
    ApiException? error,
  }) =>
      PropertyFormState(
        listingType: listingType ?? this.listingType,
        propertyType: propertyType ?? this.propertyType,
        cityId: cityId != null ? cityId() : this.cityId,
        districtId: districtId != null ? districtId() : this.districtId,
        images: images ?? this.images,
        isPublished: isPublished ?? this.isPublished,
        submitting: submitting ?? this.submitting,
        cityMissing: cityMissing ?? this.cityMissing,
        event: event,
        error: error,
      );
}

/// Everything the add / edit property form does besides drawing widgets:
/// the chosen values, the photos, uploading them to Storage and saving the
/// listing through [MyListingsCubit].
class PropertyFormCubit extends Cubit<PropertyFormState> {
  PropertyFormCubit(this._listings, {this.existingId, StorageService? storage})
      : _storage = storage ?? StorageService(),
        existing = _find(_listings, existingId),
        fields = PropertyFormControllers(_find(_listings, existingId)),
        super(_initial(_find(_listings, existingId), defaultType)) {
    _originalUrls = List.of(state.images);
  }

  static const defaultType = 'شقة'; // شقة

  final MyListingsCubit _listings;
  final StorageService _storage;
  final String? existingId;
  final ListingModel? existing;

  /// The form's text controllers and key (disposed in [close]).
  final PropertyFormControllers fields;
  final formKey = GlobalKey<FormState>();
  List<String> _originalUrls = [];

  bool get isEdit => existingId != null;
  bool get cityChosen => state.cityId != null;

  void flagMissingCity() => emit(state.copyWith(cityMissing: true));

  static ListingModel? _find(MyListingsCubit c, String? id) =>
      id == null ? null : c.state.items.where((e) => e.id == id).firstOrNull;

  static PropertyFormState _initial(ListingModel? l, String defaultType) => PropertyFormState(
        listingType: l?.listingType ?? 'sale',
        propertyType: l?.propertyType ?? defaultType,
        cityId: l?.cityId,
        districtId: l?.districtId,
        isPublished: l?.isPublished ?? true,
        images: [if (l != null) ...(l.images.isNotEmpty ? l.images : [if (l.coverImageUrl != null) l.coverImageUrl!])],
      );

  // --- simple choices -------------------------------------------------------

  void setListingType(String v) => emit(state.copyWith(listingType: v));
  void setPropertyType(String v) => emit(state.copyWith(propertyType: v));
  void setPublished(bool v) => emit(state.copyWith(isPublished: v));

  void setCity(int? id) => emit(state.copyWith(cityId: () => id, districtId: () => null, cityMissing: false));
  void setDistrict(int? id) => emit(state.copyWith(districtId: () => id));

  // --- photos ---------------------------------------------------------------

  Future<void> pickFromGallery() async {
    // Gallery only — the camera needs an extra Android manifest permission.
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) emit(state.copyWith(images: [...state.images, ...picked.map((x) => x.path)]));
  }

  /// Adds a photo by link. Returns false when it is not an http(s) URL.
  bool addImageLink(String link) {
    final uri = Uri.tryParse(link.trim());
    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https') || uri.host.isEmpty) return false;
    if (!state.images.contains(link.trim())) emit(state.copyWith(images: [...state.images, link.trim()]));
    return true;
  }

  void removeImageAt(int index) => emit(state.copyWith(images: [...state.images]..removeAt(index)));

  /// Edit mode: the list rows carry only the cover, so fetch the full photo
  /// set (and the description, if the row had none).
  Future<void> loadDetails() async {
    if (existingId == null) return;
    try {
      final full = await _listings.listingsRepository.details(existingId!);
      if (isClosed) return;
      if (fields.description.text.isEmpty && full.description != null) fields.description.text = full.description!;
      if (full.images.isNotEmpty) {
        _originalUrls = List.of(full.images);
        emit(state.copyWith(images: List.of(full.images)));
      }
    } on ApiException {
      // keep what we have
    }
  }

  // --- save / delete --------------------------------------------------------

  double? _num(String s) => double.tryParse(s.trim());
  int? _int(String s) => int.tryParse(s.trim());

  /// Validates the form, uploads the photos, then creates or updates the
  /// listing with what is in [fields].
  Future<void> submit() async {
    final fieldsOk = formKey.currentState?.validate() ?? false;
    if (state.cityId == null) {
      emit(state.copyWith(cityMissing: true)); // shown even when the text fields are fine
      return;
    }
    if (!fieldsOk) return;
    emit(state.copyWith(submitting: true));

    List<String> urls;
    try {
      urls = await _storage.uploadAll(StorageService.propertyImages, existingId ?? 'new-${DateTime.now().millisecondsSinceEpoch}', state.images);
    } on ApiException catch (e) {
      emit(state.copyWith(submitting: false, event: e.status == null ? PropertyFormEvent.failed : PropertyFormEvent.uploadFailed, error: e));
      return;
    }

    final isRent = state.listingType == 'rent';
    final desc = fields.description.text.trim();
    bool ok;
    if (isEdit) {
      ok = await _listings.update(existingId!, {
        'title': fields.title.text.trim(),
        'property_type': state.propertyType,
        'listing_type': state.listingType,
        'city_id': state.cityId,
        'district_id': state.districtId,
        'area': _num(fields.area.text),
        'rooms': _int(fields.rooms.text),
        'bathrooms': _int(fields.baths.text),
        'description': desc,
        'is_published': state.isPublished,
        if (isRent) 'rent_monthly': _num(fields.price.text) else 'price': _num(fields.price.text),
        if (isRent) 'lease_duration_months': _int(fields.lease.text),
      });
      if (ok) {
        // Photos the marketer deleted in the form: they were on the listing
        // before, and are not in the final list any more.
        final removed = [for (final u in _originalUrls) if (!urls.contains(u)) u];
        if (removed.isNotEmpty) ok = await _listings.removeImages(existingId!, removed);
      }
      if (ok) {
        final added = [for (final u in urls) if (!_originalUrls.contains(u)) u];
        if (added.isNotEmpty) ok = await _listings.addImages(existingId!, added);
      }
    } else {
      ok = await _listings.create(ListingInput(
        title: fields.title.text.trim(),
        listingType: state.listingType,
        propertyType: state.propertyType,
        cityId: state.cityId,
        districtId: state.districtId,
        area: _num(fields.area.text),
        rooms: _int(fields.rooms.text),
        bathrooms: _int(fields.baths.text),
        price: isRent ? null : _num(fields.price.text),
        rentMonthly: isRent ? _num(fields.price.text) : null,
        leaseDurationMonths: isRent ? _int(fields.lease.text) : null,
        description: desc.isEmpty ? null : desc,
        isPublished: state.isPublished,
        images: urls,
      ));
    }

    if (ok) {
      _listings.load(); // refresh covers / counts
      emit(state.copyWith(submitting: false, event: PropertyFormEvent.saved));
    } else {
      emit(state.copyWith(submitting: false, event: PropertyFormEvent.failed, error: _listings.state.error));
    }
  }

  Future<void> delete() async {
    if (existingId == null) return;
    final ok = await _listings.delete(existingId!);
    emit(state.copyWith(event: ok ? PropertyFormEvent.deleted : PropertyFormEvent.failed, error: ok ? null : _listings.state.error));
  }

  @override
  Future<void> close() {
    fields.dispose();
    return super.close();
  }
}

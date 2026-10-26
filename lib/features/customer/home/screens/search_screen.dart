import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/cubit/api_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../listings/data/listings_repository.dart';
import '../../../listings/models/listing_model.dart';
import '../../../listings/widgets/listings_message.dart';
import '../widgets/listing_card.dart';

/// Search over the marketers' listings (`GET listings?q=&property_type=`):
/// a text field plus the same category chips used on the home tab.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListingsCubit(ListingsRepository()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;
  String? _selectedCategory; // localized label of the chip
  bool _initialized = false;

  /// The chips are localized labels, but `property_type` is stored in Arabic.
  Map<String, String> get _typeOf => {
        LocaleKeys.categoryOffice.tr(): 'مكتب',
        LocaleKeys.categoryLand.tr(): 'أرض',
        LocaleKeys.categoryStudio.tr(): 'استوديو',
        LocaleKeys.categoryVilla.tr(): 'فيلا',
        LocaleKeys.categoryApartment.tr(): 'شقة',
      };

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 300) {
        context.read<ListingsCubit>().loadMore();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A category tapped on the home tab arrives as the route argument.
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) _selectedCategory = args;
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => search());
    }
  }

  void search() {
    context.read<ListingsCubit>().load(ListingFilter(
          q: _controller.text.trim(),
          propertyType: _typeOf[_selectedCategory],
        ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _typeOf.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.searchTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          hintText: LocaleKeys.searchPlaceholder.tr(),
                          hintStyle: AppTextStyles.bodyRegular,
                        ),
                        onChanged: (_) {
                          // wait for a pause in typing before calling the API
                          _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 400), search);
                          setState(() {});
                        },
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                          search();
                        },
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: categories.map((label) {
                  final isSelected = _selectedCategory == label;
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: ChoiceChip(
                      label: Text(label, style: AppTextStyles.bodySmall.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                      onSelected: (selected) {
                        setState(() => _selectedCategory = selected ? label : null);
                        search();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ListingsCubit, ApiState<ListingModel>>(
                builder: (context, state) {
                  final message = ListingsMessage.of(state, search);
                  if (message != null) return SingleChildScrollView(child: message);
                  return ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final l = state.items[index];
                      return ListingCard(
                        listing: l,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.listingDetails, arguments: l.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

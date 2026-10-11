import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/property_request.dart';
import '../widgets/request_card.dart';

/// Full search screen for the client flow — a live text field plus
/// the same category chips used on the home tab, filtering the mock
/// request list as the user types. Backed by [searchPropertyRequests];
/// swap that for a repository/API call once the backend exists.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String? _selectedCategory;
  bool _initializedFromArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A category tapped on the home tab arrives as this route's
    // arguments (see ClientShellScreen -> HomeScreen), so the chip
    // shows pre-selected instead of the user re-picking it here.
    if (!_initializedFromArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _selectedCategory = args;
      }
      _initializedFromArgs = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      LocaleKeys.categoryOffice.tr(),
      LocaleKeys.categoryLand.tr(),
      LocaleKeys.categoryStudio.tr(),
      LocaleKeys.categoryVilla.tr(),
      LocaleKeys.categoryApartment.tr(),
    ];
    final results = searchPropertyRequests(_query, category: _selectedCategory);

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
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                        onPressed: () => setState(() {
                          _controller.clear();
                          _query = '';
                        }),
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
                      onSelected: (selected) => setState(() => _selectedCategory = selected ? label : null),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: results.isEmpty
                  ? _EmptyResults(query: _query)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final r = results[index];
                        return RequestCard(
                          request: r,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: r.id),
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

class _EmptyResults extends StatelessWidget {
  final String query;
  const _EmptyResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(LocaleKeys.searchNoResultsTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(LocaleKeys.searchNoResultsDesc.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/saved_property.dart';
import '../widgets/saved_property_card.dart';

/// Shows the customer's saved/favorited properties. Starts from
/// [mockSavedProperties] and removes locally on tap — swap for a
/// repository call once the backend is wired up.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<SavedProperty> _favorites = List.of(mockSavedProperties);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.profileFavoritesTitle.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: _favorites.isEmpty
            ? _EmptyState()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: _favorites
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SavedPropertyCard(
                          property: p,
                          onRemove: () => setState(() => _favorites.remove(p)),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(LocaleKeys.noFavoritesTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(LocaleKeys.noFavoritesDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class NavBarItem {
  final IconData icon;
  final String label;
  const NavBarItem({required this.icon, required this.label});
}

/// One bottom nav bar shape reused by every screen in either flow —
/// fixes the earlier Figma inconsistency where the client and
/// marketer screens each drew their own bottom bar with different
/// languages and active-tab styling.
///
/// Each item is wrapped in `Expanded` so 5 items always fit the
/// screen width exactly, no matter how long a label is in Arabic vs
/// English — this is what was overflowing before (items sized to
/// their own content, so combined they could exceed screen width).
class AppBottomNavBar extends StatelessWidget {
  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 9, 4, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isActive = index == currentIndex;
          final item = items[index];
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accentMint : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 20, color: isActive ? AppColors.primaryDark : AppColors.textSecondary),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.badgeTracked.copyWith(
                        fontSize: 10,
                        color: isActive ? AppColors.primaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

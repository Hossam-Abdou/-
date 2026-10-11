import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/cubit/locale_cubit.dart';
import '../../../../core/shared/widgets/bottom_bar_screen.dart';
import '../../../../core/shared/widgets/place_holders/placeholder_tab_content.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../messages/screens/chat_list_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../requests/screens/my_requests_screen.dart';
import 'home_screen.dart';

/// The client account's app shell: 5 tabs, Home first (index 0).
class ClientBottomNavBar extends StatelessWidget {
  const ClientBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // This shell is built once when its route is pushed and then
    // persists underneath every screen pushed on top of it — tab
    // switches don't reconstruct it, so its `items`/`layouts` (and
    // every `.tr()` call baked into them at build time) would
    // otherwise stay frozen in whatever language was active back
    // then, even after the person picks a new one from Profile. This
    // `watch` doesn't need the value — it just makes Flutter rebuild
    // this screen (and so re-resolve every `.tr()` below with the
    // current language) the moment `LocaleCubit` changes.
    context.watch<LocaleCubit>();

    return BottomBarScreen(
      layouts: [
        const HomeScreen(),
        const MyRequestsScreen(),
        const ChatListScreen(),
        PlaceholderTabContent(title: LocaleKeys.navNotifications.tr()),
        const ProfileScreen(),
      ],
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: LocaleKeys.navHome.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.assignment_outlined), label: LocaleKeys.navRequests.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), label: LocaleKeys.navMessages.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), label: LocaleKeys.navNotifications.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: LocaleKeys.navProfile.tr()),
      ],
    );
  }
}

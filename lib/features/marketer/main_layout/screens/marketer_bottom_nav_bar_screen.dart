import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/cubit/locale_cubit.dart';
import '../../../../core/shared/widgets/bottom_bar_screen.dart';
import '../../../../core/shared/widgets/place_holders/placeholder_tab_content.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../home/screens/marketer_home_screen.dart';
import '../../messages/screens/marketer_chat_list_screen.dart';
import '../../profile/screens/marketer_profile_screen.dart';
import 'marketer_requests_screen.dart';

/// The marketer account's app shell — mirrors `ClientBottomNavBar` so
/// both flows behave identically: Home is tab 0 (dashboard/overview),
/// Requests is tab 1 (the full browsable list of client requests).
class MarketerBottomNavBarScreen extends StatelessWidget {
  const MarketerBottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // See the matching comment in ClientBottomNavBar: this shell
    // persists across tab switches, so without watching LocaleCubit
    // its nav-bar labels would stay stuck in whatever language was
    // active when the shell was first built.
    context.watch<LocaleCubit>();

    return BottomBarScreen(
      layouts: [
        const MarketerHomeScreen(),
        const MarketerRequestsScreen(),
        const MarketerChatListScreen(),
        PlaceholderTabContent(title: LocaleKeys.navNotifications.tr()),
        const MarketerProfileScreen(),
      ],
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: LocaleKeys.navHome.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.assignment_outlined), label: LocaleKeys.navMarketerRequests.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), label: LocaleKeys.navMessages.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), label: LocaleKeys.navNotifications.tr()),
        BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: LocaleKeys.navProfile.tr()),
      ],
    );
  }
}

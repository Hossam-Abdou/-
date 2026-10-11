import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_colors.dart';
import '../cubit/bottom_bar_cubit.dart';

/// One shell shape reused by both the client and marketer flows:
/// a native `BottomNavigationBar` + a Cubit tracking the active tab.
/// `layouts` and `items` are supplied per role by `ClientBottomNavBar`
/// / `MarketerBottomNavBarScreen` — this widget just wires the Cubit
/// + Scaffold.
///
/// Note: unlike the old IndexedStack version, only the active tab is
/// built at a time, so switching tabs rebuilds that tab fresh (no
/// kept-alive scroll position) — matches the requested pattern.
class BottomBarScreen extends StatelessWidget {
  final List<Widget> layouts;
  final List<BottomNavigationBarItem> items;

  const BottomBarScreen({super.key, required this.layouts, required this.items});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomBarCubit(),
      child: BlocConsumer<BottomBarCubit, BottomBarState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = BottomBarCubit.get(context);
          return PopScope(
            // Only pop the whole shell (e.g. back to role selection)
            // when already on the first tab; otherwise the back
            // button just returns to the first tab.
            canPop: cubit.currentIndex == 0,
            onPopInvoked: (didPop) {
              if (!didPop && cubit.currentIndex != 0) {
                cubit.changeIndex(0);
              }
            },
            child: Scaffold(
              body: layouts[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.surface,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textMuted,
                showUnselectedLabels: true,
                currentIndex: cubit.currentIndex,
                onTap: cubit.changeIndex,
                items: items,
              ),
            ),
          );
        },
      ),
    );
  }
}

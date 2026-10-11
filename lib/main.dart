import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/router/app_router.dart';
import 'core/shared/cubit/locale_cubit.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: LocaleCubit.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const PropertySeekerApp(),
    ),
  );
}

class PropertySeekerApp extends StatelessWidget {
  const PropertySeekerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Seeded from whatever easy_localization already resolved on
      // launch (its own saved-locale/startLocale logic), so the
      // Cubit and the loaded translations start in sync.
      create: (_) => LocaleCubit(context.locale),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,

            // Named routes: initialRoute picks the first screen, and every
            // other screen is resolved by name through onGenerateRoute.
            initialRoute: AppRoutes.roleSelection,
            onGenerateRoute: onGenerateRoute,

            // `locale` comes from LocaleCubit rather than
            // `context.locale` directly — this one value is also the
            // *only* thing that decides the whole app's text
            // direction (RTL for 'ar', LTR for 'en'). MaterialApp
            // inserts one top-level Directionality from it
            // automatically, so no manual Directionality widgets are
            // needed anywhere in the app.
            locale: locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
          );
        },
      ),
    );
  }
}


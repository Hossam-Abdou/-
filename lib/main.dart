import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/router/app_router.dart';
import 'core/network/api_client.dart';
import 'core/realtime/realtime_sync.dart';
import 'core/network/api_endpoints.dart';
import 'core/shared/cubit/locale_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/offers/cubit/offers_cubit.dart';
import 'features/offers/data/offers_repository.dart';
import 'features/requests/cubit/requests_cubit.dart';
import 'features/requests/data/requests_repository.dart';
import 'features/listings/cubit/listings_cubit.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/listings/data/listings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);

  ApiClient.onSessionLost = AuthRepository.silentLogin;
  final startRoute = await AuthRepository.startRoute();

  runApp(
    EasyLocalization(
      supportedLocales: LocaleCubit.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: PropertySeekerApp(initialRoute: startRoute),
    ),
  );
}

class PropertySeekerApp extends StatelessWidget {
  final String initialRoute;
  const PropertySeekerApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit(context.locale)),
        // Saved listings, shared so every heart button stays in sync.
        BlocProvider(create: (_) => FavoritesCubit(ListingsRepository())),
        // The customer's own requests (My Requests tab + the add/edit wizard).
        BlocProvider(create: (_) => RequestsCubit(RequestsRepository())),
        // Marketer side: offers they sent + their own listings.
        BlocProvider(create: (_) => OffersCubit(OffersRepository())),
        BlocProvider(create: (_) => MyListingsCubit(ListingsRepository())),
        // The signed-in user's profile (name, phone, avatar...).
        BlocProvider(create: (_) => ProfileCubit(ProfileRepository())),
      ],
      // LocaleCubit is seeded from whatever easy_localization already resolved on
      // launch (its own saved-locale/startLocale logic), so the
      // Cubit and the loaded translations start in sync.
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,

            // Named routes: initialRoute picks the first screen, and every
            // other screen is resolved by name through onGenerateRoute.
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,

            // `locale` comes from LocaleCubit rather than
            // `context.locale` directly — this one value is also the
            // *only* thing that decides the whole app's text
            // direction (RTL for 'ar', LTR for 'en'). MaterialApp
            // inserts one top-level Directionality from it
            // automatically, so no manual Directionality widgets are
            // needed anywhere in the app.
            locale: locale,
            builder: (context, child) => RealtimeSync(child: child ?? const SizedBox.shrink()),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
          );
        },
      ),
    );
  }
}


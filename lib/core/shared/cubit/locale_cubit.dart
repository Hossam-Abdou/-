import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Single source of truth for the app's current language ('ar' or
/// 'en'). Widgets that need to react to a language change — like the
/// language picker highlighting the active option, or a profile menu
/// showing the current language name — watch this Cubit instead of
/// reading `context.locale` directly, so the whole feature goes
/// through one clear state-management pattern.
///
/// [changeLocale] still delegates the actual switch to
/// easy_localization's `context.setLocale`: that's what reloads the
/// translation JSON and persists the choice for next launch. Once
/// [PropertySeekerApp] (in `main.dart`) feeds this Cubit's state into
/// `MaterialApp.locale`, Flutter derives text direction for the
/// *entire* app from that one value and inserts a single top-level
/// `Directionality` on its own — so no manual `Directionality`
/// widgets are needed anywhere else. Screens just need to use
/// direction-agnostic properties instead of hardcoded left/right:
/// `TextAlign.start`/`end`, `EdgeInsetsDirectional`,
/// `AlignmentDirectional`, and `Icon(..., matchTextDirection: true)`
/// for arrows/chevrons that should flip between RTL and LTR.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(super.initialLocale);

  static const supportedLocales = [Locale('ar'), Locale('en')];
  // bool get isRtl => state.languageCode == 'ar';


  Future<void> changeLocale(BuildContext context, Locale locale) async {
    if (state.languageCode == locale.languageCode) return;
    await context.setLocale(locale);
    if (!context.mounted) return;
    emit(locale);
  }
}

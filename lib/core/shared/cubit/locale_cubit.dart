import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

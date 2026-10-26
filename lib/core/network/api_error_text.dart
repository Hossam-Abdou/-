import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';
import 'api_client.dart';

/// The message to show the user for a failed request.
extension ApiErrorText on ApiException {
  String get text {
    if (isNetwork) return LocaleKeys.apiErrNetwork.tr();
    switch (status) {
      case 400:
        return LocaleKeys.apiErrInvalid.tr();
      case 401:
        return LocaleKeys.apiErrUnauthorized.tr();
      case 403:
        return LocaleKeys.apiErrForbidden.tr();
      case 404:
        return LocaleKeys.apiErrNotFound.tr();
      case 409:
        return LocaleKeys.apiErrConflict.tr();
      default:
        return LocaleKeys.apiErrGeneric.tr();
    }
  }
}

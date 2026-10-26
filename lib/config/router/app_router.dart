import 'package:flutter/material.dart';
import '../../core/shared/widgets/locale_aware_builder.dart';
import '../../core/shared/screens/about_us_screen.dart';
import '../../core/shared/widgets/place_holders/placeholder_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/customer/home/models/property_request.dart';
import '../../features/customer/home/models/offer_preview.dart';
import '../../features/customer/home/screens/client_bottom_nav_bar_screen.dart';
import '../../features/customer/home/screens/offer_details_screen.dart';
import '../../features/customer/home/screens/request_details_screen.dart';
import '../../features/customer/home/screens/search_screen.dart';
import '../../features/listings/screens/listing_details_screen.dart';
import '../../features/customer/messages/models/conversation.dart' as customer_msg;
import '../../features/customer/profile/screens/favorites_screen.dart';
import '../../features/customer/profile/screens/my_information_screen.dart';
import '../../features/customer/messages/screens/chat_list_screen.dart';
import '../../features/customer/messages/screens/chat_thread_screen.dart';
import '../../features/customer/requests/screens/add_edit_request_screen.dart';
import '../../features/customer/requests/screens/my_requests_screen.dart';
import '../../features/marketer/messages/models/conversation.dart' as marketer_msg;
import '../../features/marketer/messages/screens/marketer_chat_list_screen.dart';
import '../../features/marketer/messages/screens/marketer_chat_thread_screen.dart';
import '../../features/marketer/profile/screens/my_information_screen.dart';
import '../../features/marketer/properties/screens/my_properties_screen.dart';
import '../../features/marketer/properties/screens/property_form_screen.dart';
import '../../features/marketer/main_layout/models/marketer_request.dart';
import '../../features/marketer/main_layout/screens/marketer_request_details_screen.dart';
import '../../features/marketer/main_layout/screens/marketer_search_screen.dart';
import '../../features/marketer/main_layout/screens/marketer_bottom_nav_bar_screen.dart';
import '../../features/marketer/main_layout/screens/send_offer_screen.dart';
import '../../features/subscriptions/screens/upgrade_screen.dart';

/// Route names as constants so screens navigate via
/// `Navigator.pushNamed(context, AppRoutes.upgrade)` instead of
/// typed-out strings. Screens that need an id (request details, a
/// chat thread, etc.) take it through `arguments`, read back with
/// `ModalRoute.of(context)!.settings.arguments`.
class AppRoutes {
  AppRoutes._();
  static const aboutUs = '/about-us';

  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const home = '/home';
  static const search = '/search';
  static const requestsTracking = '/main_layout';
  static const requestDetails = '/request-details'; // arguments: requestId
  static const listingDetails = '/listing-details'; // arguments: listingId
  static const editRequest = '/main_layout/edit'; // arguments: requestId
  static const createRequestLocation = '/main_layout/create/location';
  static const createRequestPropertyType = '/main_layout/create/property-type';
  static const createRequestReview = '/main_layout/create/review';
  static const offerDetails = '/offer-details'; // arguments: offerId
  static const requestOffers = '/request-offers'; // arguments: requestId
  static const profile = '/profile';
  static const myInformation = '/my-information';
  static const favorites = '/favorites';
  static const notifications = '/notifications';
  static const chatList = '/chat';
  static const chatThread = '/chat-thread'; // arguments: chatId
  static const loading = '/loading';
  static const requestsEmpty = '/main_layout/empty';
  static const chatEmpty = '/chat/empty';
  static const upgrade = '/upgrade';

  // Marketer flow
  static const marketerRequests = '/marketer/main_layout';
  static const marketerRequestDetails = '/marketer/request-details'; // arguments: requestId
  static const marketerProperties = '/marketer/properties';
  static const marketerProfile = '/marketer/profile';
  static const marketerMyInformation = '/marketer/my-information';
  static const marketerSendOffer = '/marketer/send-offer'; // arguments: requestId
  static const marketerOffers = '/marketer/offers';
  static const marketerAddProperty = '/marketer/properties/add';
  static const marketerEditProperty = '/marketer/edit-property'; // arguments: propertyId
  static const marketerSearch = '/marketer/search';
  static const marketerNotifications = '/marketer/notifications';
  static const marketerChat = '/marketer/chat';
  static const marketerChatThread = '/marketer/chat-thread'; // arguments: chatId
}

/// Screens that take no arguments — plain name -> builder map.
/// Login/Register are handled separately since they read `UserRole`
/// back from `settings.arguments` themselves.
final Map<String, WidgetBuilder> _simpleRoutes = {

  '/': (_) => const LoginScreen(),
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.register: (_) => const RegisterScreen(),
  // AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
  AppRoutes.upgrade: (_) => const UpgradeScreen(),

  // --- Client flow: real screens ---
  AppRoutes.home: (_) => const ClientBottomNavBar(),
  AppRoutes.search: (_) => const SearchScreen(),
  AppRoutes.requestsTracking: (_) => const MyRequestsScreen(),
  AppRoutes.chatList: (_) => const Scaffold(body: ChatListScreen()),

  // --- Client flow: not built yet ---
  AppRoutes.createRequestLocation: (_) => const AddEditRequestScreen(),
  AppRoutes.createRequestPropertyType: (_) => const PlaceholderScreen(title: 'إنشاء طلب - نوع العقار'),
  AppRoutes.createRequestReview: (_) => const PlaceholderScreen(title: 'مراجعة ونشر الطلب'),
  AppRoutes.profile: (_) => const PlaceholderScreen(title: 'الملف الشخصي'),
  AppRoutes.myInformation: (_) => const MyInformationScreen(),
  AppRoutes.favorites: (_) => const FavoritesScreen(),
  AppRoutes.notifications: (_) => const PlaceholderScreen(title: 'الإشعارات'),
  AppRoutes.loading: (_) => const PlaceholderScreen(title: 'جاري التحميل'),
  AppRoutes.requestsEmpty: (_) => const PlaceholderScreen(title: 'لا توجد طلبات'),
  AppRoutes.chatEmpty: (_) => const PlaceholderScreen(title: 'لا توجد رسائل'),

  // --- Marketer flow: real screens ---
  AppRoutes.marketerRequests: (_) => const MarketerBottomNavBarScreen(),
  AppRoutes.marketerSearch: (_) => const MarketerSearchScreen(),
  AppRoutes.marketerChat: (_) => const Scaffold(body: MarketerChatListScreen()),
  AppRoutes.aboutUs: (_) => const AboutUsScreen(),

  // --- Marketer flow: not built yet ---
  AppRoutes.marketerProperties: (_) => const MyPropertiesScreen(),
  AppRoutes.marketerProfile: (_) => const PlaceholderScreen(title: 'ملف المسوق'),
  AppRoutes.marketerMyInformation: (_) => const MarketerMyInformationScreen(),
  AppRoutes.marketerOffers: (_) => const PlaceholderScreen(title: 'عروضي'),
  AppRoutes.marketerAddProperty: (_) => const PropertyFormScreen(),
  AppRoutes.marketerNotifications: (_) => const PlaceholderScreen(title: 'الإشعارات'),
};

/// Screens that need an id — read it back from `settings.arguments`.
Widget? _buildArgumentRoute(RouteSettings settings) {
  final id = settings.arguments is String ? settings.arguments as String : null;

  switch (settings.name) {
    case AppRoutes.listingDetails:
      return id != null ? ListingDetailsScreen(listingId: id) : null;
    case AppRoutes.requestDetails:
      final request = findPropertyRequestById(id);
      return request != null
          ? RequestDetailsScreen(request: request)
          : PlaceholderScreen(title: 'تفاصيل الطلب${id != null ? ' #$id' : ''}');
    case AppRoutes.editRequest:
      final request = findPropertyRequestById(id);
      return AddEditRequestScreen(existingRequest: request);
    case AppRoutes.offerDetails:
      final offer = findOfferPreviewById(id);
      return offer != null ? OfferDetailsScreen(offer: offer) : PlaceholderScreen(title: 'تفاصيل العرض${id != null ? ' #$id' : ''}');
    case AppRoutes.requestOffers:
      return PlaceholderScreen(title: 'عروض الطلب${id != null ? ' #$id' : ''}');
    case AppRoutes.chatThread:
      final conversation = customer_msg.findCustomerConversationById(id);
      return conversation != null
          ? ChatThreadScreen(conversation: conversation)
          : PlaceholderScreen(title: 'المحادثة${id != null ? ' #$id' : ''}');
    case AppRoutes.marketerRequestDetails:
      final request = findMarketerRequestById(id);
      return request != null
          ? MarketerRequestDetailsScreen(request: request)
          : PlaceholderScreen(title: 'تفاصيل الطلب${id != null ? ' #$id' : ''}');
    case AppRoutes.marketerSendOffer:
      final request = findMarketerRequestById(id);
      return request != null
          ? SendOfferScreen(request: request)
          : PlaceholderScreen(title: 'إرسال عرض${id != null ? ' لطلب #$id' : ''}');
    case AppRoutes.marketerChatThread:
      final conversation = marketer_msg.findMarketerConversationById(id);
      return conversation != null
          ? MarketerChatThreadScreen(conversation: conversation)
          : PlaceholderScreen(title: 'المحادثة${id != null ? ' #$id' : ''}');
    case AppRoutes.marketerEditProperty:
      return id != null
          ? PropertyFormScreen(existingId: id)
          : PlaceholderScreen(title: 'تعديل العقار');
    default:
      return null;
  }
}
//
// /// Pass this to `MaterialApp(onGenerateRoute: ...)`. Handles every
// /// screen from the Figma file — the built ones open their real
// /// widget, everything else opens `PlaceholderScreen` with the right
/// title, so the whole app is navigable today.
///
/// Login and Register are resolved here (not in `_simpleRoutes`)
/// because they need to read the `UserRole` passed in as `arguments`
/// — the widgets themselves read it via `ModalRoute.of(context)`,
/// so a plain `MaterialPageRoute` with `settings` attached is enough.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Every branch below is wrapped in `LocaleAwareBuilder` so *every*
  // screen — including the very first one, `initialRoute` — rebuilds
  // correctly when the language changes, without each screen having
  // to remember `context.watch<LocaleCubit>()` itself. See that
  // widget's doc comment for why this is needed at all.
  final simpleBuilder = _simpleRoutes[settings.name];
  if (simpleBuilder != null) {
    return MaterialPageRoute(builder: (context) => LocaleAwareBuilder(builder: simpleBuilder), settings: settings);
  }

  final argumentScreen = _buildArgumentRoute(settings);
  if (argumentScreen != null) {
    return MaterialPageRoute(builder: (_) => LocaleAwareBuilder(builder: (_) => argumentScreen), settings: settings);
  }

  return MaterialPageRoute(
    builder: (_) => LocaleAwareBuilder(builder: (_) => PlaceholderScreen(title: settings.name ?? 'غير موجود')),
    settings: settings,
  );
}

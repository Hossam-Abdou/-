/// Connection details for the Supabase project. The anon key is a public key
/// (it is meant to be inside the app). Never put the service_role key here.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://fwzlzezjiinbwlsdsofk.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3emx6ZXpqaWluYndsc2Rzb2ZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE0Njc4MDYsImV4cCI6MjEwNzA0MzgwNn0.7CS7BOxFxl5o6BByKV_AL9jSVsDckK34YO1muS5G1Bw';
}

/// Every Edge Function route of the backend (same list as the Postman collection).
/// Paths are relative to `{url}/functions/v1/`. The HTTP method is in the comment.
///
/// Query parameters are not part of the path, pass them to `ApiClient.get(query: {...})`.
class ApiEndpoints {
  ApiEndpoints._();

  // ---------------- auth (no token needed except `me`) ----------------
  static const String signup = 'auth/signup'; // POST  {email, password, full_name, phone, role}
  static const String login = 'auth/login'; // POST  {email, password}
  static const String refresh = 'auth/refresh'; // POST  {refresh_token}
  static const String resetPassword = 'auth/reset-password'; // POST  {email}
  static const String me = 'auth/me'; // GET profile, PATCH {full_name, phone, avatar_url, bio}

  // ---------------- locations (public) ----------------
  static const String locations = 'locations'; // GET  cities + districts
  static const String cities = 'locations/cities'; // GET
  static const String districts = 'locations/districts'; // GET  ?city_id=

  // ---------------- property requests ----------------
  static const String requests = 'requests'; // GET ?status&city_id&district_id&property_type&limit&offset | POST (customer)
  static String request(String id) => 'requests/$id'; // GET | PATCH | DELETE (customer)
  static String closeRequest(String id) => 'requests/$id/close'; // POST (customer)

  // ---------------- property listings ----------------
  static const String listings = 'listings'; // GET browse (filters below) | POST create (marketer)
  // GET filters: reference_code, city_id, district_id, property_type, listing_type, category,
  //   furnishing, finishing, marketer_id, min_price, max_price, min_rent, max_rent,
  //   max_rent_daily, max_lease_months, min_area, max_area, min_rooms, min_bathrooms,
  //   floor, features (comma separated), q, sort (newest|price_asc|price_desc|rent_asc|rent_desc),
  //   limit, offset
  static const String listingsMeta = 'listings/meta'; // GET allowed values for the pickers
  static const String myListings = 'listings/mine'; // GET (marketer)
  static const String favorites = 'listings/favorites'; // GET (customer)
  static String listing(String id) => 'listings/$id'; // GET | PATCH | DELETE (marketer)
  static String listingImages(String id) => 'listings/$id/images'; // POST {images: [url]}
  static String listingRemoveImages(String id) => 'listings/$id/remove-images'; // POST {images: [url]}
  static String listingFavorite(String id) => 'listings/$id/favorite'; // POST | DELETE (customer)

  // ---------------- offers ----------------
  static const String offers = 'offers'; // GET ?request_id&status | POST (marketer) {request_id, property_id, message, images}
  static String offer(String id) => 'offers/$id'; // GET
  static String acceptOffer(String id) => 'offers/$id/accept'; // POST (customer)
  static String declineOffer(String id) => 'offers/$id/decline'; // POST (customer)

  // ---------------- chat ----------------
  static const String conversations = 'chat/conversations'; // GET | POST {other_user_id, related_request_id}
  static String messages(String conversationId) => 'chat/conversations/$conversationId/messages'; // GET ?limit | POST {content}
  static String markRead(String conversationId) => 'chat/conversations/$conversationId/read'; // POST

  // ---------------- subscriptions (marketer) ----------------
  static const String plans = 'subscriptions/plans'; // GET
  static const String subscribe = 'subscriptions/subscribe'; // POST {plan_id}
  static const String currentSubscription = 'subscriptions/current'; // GET
}

/// Mock option lists for the create-request wizard's location and
/// details steps. Plain Arabic data (not localized) — same
/// convention as [requestPropertyTypeOptions] — swap for a real
/// lookup/API once the backend exists.
library;

const List<String> requestCityOptions = ['القاهرة', 'الجيزة', 'الإسكندرية', 'القاهرة الجديدة'];

const Map<String, List<String>> requestDistrictsByCity = {
  'القاهرة': ['مدينة نصر', 'المعادي', 'مصر الجديدة', 'وسط البلد'],
  'الجيزة': ['الشيخ زايد', '6 أكتوبر', 'الدقي', 'المهندسين'],
  'الإسكندرية': ['سموحة', 'ميامي', 'سيدي جابر', 'المنتزه'],
  'القاهرة الجديدة': ['التجمع الخامس', 'التجمع الأول', 'الرحاب', 'مدينتي'],
};

const List<String> requestCompoundOptions = ['بدون كمبوند', 'كمبوند 1', 'كمبوند 2', 'كمبوند 3'];

const List<String> requestRoomsOptions = ['1', '2', '3', '4', '5+'];

const List<String> requestBathroomsOptions = ['1', '2', '3', '4+'];

const List<String> requestFinishingOptions = ['تشطيب متكامل', 'نصف تشطيب', 'سوبر لوكس', 'على الطوب الأحمر'];

/// Small helpers for reading backend JSON safely (numbers can arrive as int,
/// double or String, and any field can be null).
int? toInt(Object? v) => v is num ? v.toInt() : (v == null ? null : int.tryParse('$v'));
double? toDouble(Object? v) => v is num ? v.toDouble() : (v == null ? null : double.tryParse('$v'));
DateTime? toDate(Object? v) => v == null ? null : DateTime.tryParse('$v');
List<String> toStringList(Object? v) => v is List ? [for (final e in v) '$e'] : const [];

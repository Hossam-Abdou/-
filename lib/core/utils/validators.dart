/// Pure validation helpers for the auth forms (no Flutter imports).
class Validators {
  Validators._();

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Turns "01098765432", "1098765432", "+201098765432" or "0020 10 9876 5432"
  /// into "+201098765432". Returns null when it is not an Egyptian mobile.
  static String? normalizeEgyptPhone(String input) {
    var d = input.replaceAll(RegExp(r'[\s\-()]'), '');
    if (d.startsWith('+')) d = d.substring(1);
    if (d.startsWith('0020')) d = d.substring(4);
    if (d.startsWith('20') && d.length == 12) d = d.substring(2);
    if (d.startsWith('0')) d = d.substring(1);
    return RegExp(r'^1[0125][0-9]{8}$').hasMatch(d) ? '+20$d' : null;
  }

  static bool isEmail(String v) => _email.hasMatch(v.trim());

  /// 8+ characters with at least one digit (a symbol is allowed but not required).
  static bool isStrongPassword(String v) => v.length >= 8 && RegExp(r'[0-9]').hasMatch(v);

  /// True while the user is typing something that looks like an e-mail.
  static bool looksLikeEmail(String v) => v.contains('@') || RegExp(r'[A-Za-z]').hasMatch(v);
}

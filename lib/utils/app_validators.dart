/// Pure validators kept free of any Flutter UI dependencies so they're easy
/// to unit test and reuse from providers.
class AppValidators {
  AppValidators._();

  /// Accepts Indian mobile numbers — 10 digits starting with 6/7/8/9.
  /// Adjust the regex if Knocksy expands to other regions.
  static bool isValidIndianMobile(String value) {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(value);
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number required';
    if (!isValidIndianMobile(value)) return 'Enter a valid 10-digit number';
    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) return 'OTP required';
    if (value.length != length) return 'Enter the $length-digit code';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Numbers only';
    return null;
  }

  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    final regex = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }
}

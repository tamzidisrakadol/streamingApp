/// Validation utility functions
class Validators {
  Validators._();

  /// Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Password validation (minimum 8 characters, at least one letter and one number)
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;

    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return hasLetter && hasNumber;
  }

  /// Phone number validation (basic)
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone);
  }

  /// URL validation
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Check if string is empty or null
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Check if string is not empty
  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }

  /// Minimum length validation
  static bool hasMinLength(String value, int length) {
    return value.length >= length;
  }

  /// Maximum length validation
  static bool hasMaxLength(String value, int length) {
    return value.length <= length;
  }

  /// Username validation (alphanumeric, underscore, 3-20 characters)
  static bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }
}

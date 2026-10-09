abstract final class AppValidators {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? requiredField(
    String? value, {
    String message = 'Bu sahəni doldurun.',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'E-poçtunuzu daxil edin.';
    }

    if (!_emailPattern.hasMatch(email)) {
      return 'Düzgün e-poçt ünvanı daxil edin.';
    }

    return null;
  }

  static String? loginPassword(String? value) {
    // Şifrəni trim etmirik: boşluq onun bir hissəsi ola bilər.
    if (value == null || value.isEmpty) {
      return 'Şifrənizi daxil edin.';
    }

    return null;
  }
}

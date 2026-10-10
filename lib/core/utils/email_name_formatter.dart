class EmailNameFormatter {
  EmailNameFormatter._();

  static String format(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'İstifadəçi';
    }

    final username = email.trim().split('@').first;

    final normalized = username
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.isEmpty) {
      return 'İstifadəçi';
    }

    return normalized
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';

          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

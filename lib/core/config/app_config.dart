class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  factory AppConfig.fromEnvironment() {
    return const AppConfig(apiBaseUrl: 'https://dayaq.livementors.org');
  }

  final String apiBaseUrl;

  bool get hasApiUrl {
    final uri = Uri.tryParse(apiBaseUrl);

    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }
}

class AppConfig {
  const AppConfig({required this.apiBaseUrl});
  factory AppConfig.fromEnvironment() =>
      const AppConfig(apiBaseUrl: String.fromEnvironment('API_BASE_URL'));
  final String apiBaseUrl;
  bool get hasApiUrl {
    final uri = Uri.tryParse(apiBaseUrl);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }
}

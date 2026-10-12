abstract final class ApiEndpoints {
  // AUTH
  static const String login = '/api/login';

  // FAMILIES
  static const String families = '/api/familylist';

  static String familyDetails(int id) => '$families/$id';

  // FAMILY REGISTRATION
  static const String registerFamily = '/api/volunteerform';
}

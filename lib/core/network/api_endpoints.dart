abstract final class ApiEndpoints {
  // AUTH
  static const String login = '/api/login';
  static const String logout = '/api/logout';

  // FAMILIES
  static const String families = '/api/familylist';

  static String familyDetails(int id) => '$families/$id';

  // FAMILY REGISTRATION
  static const String registerFamily = '/api/volunteerform';

  static const String about = '/api/about';
  static const String termCondition = '/api/term-condition';
  static const String rule = '/api/rule';
}

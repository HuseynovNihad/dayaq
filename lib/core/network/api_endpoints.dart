abstract final class ApiEndpoints {
  static const login = '/api/login';

  static const families = '/api/familylist';

  static String familyDetails(int id) => '$families/$id';
}

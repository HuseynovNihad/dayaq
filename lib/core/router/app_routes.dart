abstract final class AppRoutes {
  static const String home = '/';
  static const String families = '/families';
  static const String familyDetails = '/family-details/:id';
  static const String familyRegistration = '/family-registration';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String map = '/map';

  static const String about = '/about';
  static const String termConditions = '/term-conditions';
  static const String rules = '/rules';
  static const String notifications = '/notifications';

  static String familyDetailsPath(int id) => '/family-details/$id';
}

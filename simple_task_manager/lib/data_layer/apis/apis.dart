final class Apis {
  static const authRoute = "/auth";
  static const docsRoute = "/docs";

  static const register = "$authRoute/register";
  static const login = "$authRoute/login";
  static todosByUser(String userId) => "/todos/user/$userId";
  static todosBy(String byCriteria) => "/todos/$byCriteria";
}

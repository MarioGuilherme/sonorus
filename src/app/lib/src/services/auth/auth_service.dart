abstract class AuthService {
  Future<bool> isAuthenticated();
  Future<void> login(String login, String password);
  Future<void> register(String fullname, String nickname, String email, String password);
}
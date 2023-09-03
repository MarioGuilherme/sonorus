abstract class AuthService {
  Future<void> login(String login, String password);
  Future<void> register(String fullname, String nickname, String email, String password);
}
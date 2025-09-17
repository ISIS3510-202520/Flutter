import 'package:here4u/mvvm/data/services/user_service.dart';

class LoginViewModel {
  final UserService _userService = UserService();

  Future<String?> login(String email, String password) async {
    final user = await _userService.signInWithEmail(email, password);
    if (user == null) return 'Login failed';
    if (!user.emailVerified) {
      await user.sendEmailVerification();
      return 'Please verify your email. A new verification email has been sent.';
    }
    // Proceed with login (return null or success)
    return null;
  }
}
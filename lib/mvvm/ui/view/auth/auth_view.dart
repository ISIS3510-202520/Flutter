import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here4u/home_page.dart';
import 'package:here4u/mvvm/ui/view/auth/login_view.dart';
class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final user = snapshot.data!;
          if (!user.emailVerified) {
            // Logout and redirect
            FirebaseAuth.instance.signOut();
            return const LoginView();
          }
          // Show homepage if email is verified and user is logged in
          return const MyHomePage(title: 'Flutter Demo Home Page');
        }
        return const LoginView();
      },
    );
  }
}
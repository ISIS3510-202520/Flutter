import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here4u/mvvm/ui/view/auth/login_view.dart';
import 'package:here4u/mvvm/ui/view/home/home_view.dart';
import 'package:here4u/mvvm/ui/view_model/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';
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
            return ChangeNotifierProvider(
              create: (_) => LoginViewModel(),
              child: const LoginView(),
            );
          }
          // Show homepage if email is verified and user is logged in
          return ChangeNotifierProvider(
            create: (_) => HomeViewModel(),
            child: const HomeView(),
          );
        }
        return ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: const LoginView(),
        );
      },
    );
  }
}
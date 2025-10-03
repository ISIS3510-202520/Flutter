import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view/auth/login_view.dart';
import 'package:here4u/mvvm/ui/view/home/home_view.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/login_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authViewModel.isAuthenticated) {
          if (!authViewModel.isEmailVerified) {
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

        // User is not authenticated
        return ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: const LoginView(),
        );
      },
    );
  }
}
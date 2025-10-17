import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view/auth/login_view.dart';
import 'package:here4u/mvvm/ui/view/home/home_view.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/login_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late DateTime _startTime;
  bool _hasLoggedEngagement = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'AuthView',
      screenClass: 'AuthView',
    );
  }

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
          // Log user engagement time before navigating
          final engagementTime = DateTime.now().difference(_startTime).inMilliseconds;
          if (engagementTime > 2000 && !_hasLoggedEngagement) {
            debugPrint('[AuthView] User engagement time: $engagementTime ms');
            FirebaseAnalytics.instance.logEvent(
              name: 'screen_engagement_flutter',
              parameters: {
                'screen_name': 'AuthView',
                'engagement_time_msec': engagementTime,
              },
            );
            _hasLoggedEngagement = true; // Ensure we log this only once
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

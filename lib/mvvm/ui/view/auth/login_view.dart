import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/auth/recover_password_view.dart';
import 'package:here4u/mvvm/ui/view/auth/register_view.dart';
import 'package:here4u/mvvm/ui/view_model/login_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/recover_password_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/register_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';
import 'package:here4u/mvvm/ui/widgets/inputs/rounded_textbox.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late DateTime _startTime;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    debugPrint("[LoginView] logging screen view");
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'LoginView',
      screenClass: 'LoginView',
    );
  }

  void _login() {
    final viewModel = context.read<LoginViewModel>();
    viewModel.loginWithCallback(
      _emailController.text,
      _passwordController.text,
      context,
      (result) {
        if (result != null) {
          try {
            SnackWarning.show(context, "Invalid credentials!");
          } catch (e) {
            debugPrint("Error showing SnackWarning: $e");
          }
          return;
        } else {
          final engagementTime = DateTime.now().difference(_startTime).inMilliseconds;
          debugPrint('[LoginView] User engagement time: $engagementTime ms');
          FirebaseAnalytics.instance.logEvent(
            name: 'screen_engagement_flutter',
            parameters: {
              'screen_name': 'LoginView',
              'engagement_time_msec': engagementTime,
            },
          );
        }
      },
    );
  }

  void _register() {
    final engagementTime = DateTime.now().difference(_startTime).inMilliseconds;
    debugPrint('[LoginView] User engagement time: $engagementTime ms');
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_engagement_flutter',
      parameters: {
        'screen_name': 'LoginView',
        'engagement_time_msec': engagementTime,
      },
    );
    final viewModel = RegisterViewModel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => viewModel,
          child: const RegisterView(),
        ),
      ),
    );
    _startTime = DateTime.now(); // Reset start time for next engagement tracking
  }

  void _recoverPassword() {
    final engagementTime = DateTime.now().difference(_startTime).inMilliseconds;
    debugPrint('[LoginView] User engagement time: $engagementTime ms');
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_engagement_flutter',
      parameters: {
        'screen_name': 'LoginView',
        'engagement_time_msec': engagementTime,
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => RecoverPasswordViewModel(),
          child: RecoverPasswordView(),
        ),
      ),
    );
    _startTime = DateTime.now(); // Reset start time for next engagement tracking
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),

                    Image.asset(
                      'assets/here4u_logo_350x350.png',
                      width: 200,
                      height: 200,
                    ),

                    const SizedBox(height: 32),
                    RoundedTextbox(hintText: 'Email', controller: _emailController, enabled: viewModel.isOnline && !viewModel.isLoading),
                    const SizedBox(height: 16),
                    RoundedTextbox(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      enabled: viewModel.isOnline && !viewModel.isLoading,
                    ),

                    // Forgot Password
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Forgot my ', style: TextStyle(fontSize: 14)),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: _recoverPassword,
                            child: Text(
                              'password',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login Button
                    const SizedBox(height: 16),
                    RoundedButton(
                      text: viewModel.isOnline ? 'Login' : 'Offline',
                      onPressed: viewModel.isOnline && !viewModel.isLoading ? _login : null,
                      icon: Icons.login,
                      color: viewModel.isOnline ? const Color(0xFF86D9F0) : Colors.grey,
                    ),

                    const SizedBox(height: 16),

                    // Register Button
                    RoundedButton(
                      text: 'Signup',
                      onPressed: _register,
                      color: const Color(0xFF8CC0CF),
                      textColor: Colors.black,
                      icon: Icons.app_registration,
                    ),
                  ],
                ), // Column
              ), // SingleChildScrollView
            ), // Center
          ); // Scaffold
        }, // builder
    ); // Consumer
  }
}

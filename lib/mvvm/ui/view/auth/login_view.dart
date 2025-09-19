import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/auth/auth_view.dart';
import 'package:here4u/mvvm/ui/view/auth/register_view.dart';
import 'package:here4u/mvvm/ui/view_model/login_view_model.dart';
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
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
  final viewModel = LoginViewModel();
  
  void _login() async {
    final viewModel = context.read<LoginViewModel>();
    final result = await viewModel.login(_emailController.text, _passwordController.text);
    if (result != null && mounted) {
      SnackWarning.show(context, result);
      return; // Abort login
    }
    if (!mounted) return;
    // Proceed to home via auth_view
	Navigator.pop(context); // Close login view
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthView(),
      ),
    );
	return;
  }

  void _register() {
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
  }

	@override
	Widget build(BuildContext context) {
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
								RoundedTextbox(
									hintText: 'Email',
									controller: _emailController,
								),
								const SizedBox(height: 16),
								RoundedTextbox(
									hintText: 'Password',
									controller: _passwordController,
									obscureText: true,
								),
								const SizedBox(height: 32),
								
                // Login Button
								const SizedBox(height: 16),
								RoundedButton(
									text: 'Login',
									onPressed: _login,
                  icon: Icons.login,
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
						),
					),
				),
			);
	}
}

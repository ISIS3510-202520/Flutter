import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/auth/register_view.dart';
import 'package:here4u/mvvm/ui/view_model/login_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';
import 'package:here4u/mvvm/ui/widgets/inputs/rounded_textbox.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';

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
    final result = await viewModel.login(_emailController.text, _passwordController.text);
    if (result != null && mounted) {
      SnackWarning.show(context, result);
      return; // Abort login
    }
    // Proceed to home
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
									'Login',
									style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
								),

                // Register Button
                RoundedButton(
									text: 'Register',
									onPressed: () {
										Navigator.push(
											context,
											MaterialPageRoute(builder: (context) => const RegisterView()),
										);
									},
									color: Colors.grey[300]!,
									textColor: Colors.black,
								),
							],
						),
					),
				),
			);
	}
}

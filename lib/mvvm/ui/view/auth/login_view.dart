import 'package:flutter/material.dart';
import '../../widgets/inputs/rounded_textbox.dart';
import '../../widgets/buttons/rounded_button.dart';

class LoginView extends StatefulWidget {
	const LoginView({super.key});

	@override
	State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

	void _login() {
		// TODO: Implement login logic using your controller
		final email = _emailController.text;
		final password = _passwordController.text;
		// Call your controller's login method here
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
							RoundedButton(
								text: 'Login',
								onPressed: _login,
							),
						],
					),
				),
			),
		);
	}
}

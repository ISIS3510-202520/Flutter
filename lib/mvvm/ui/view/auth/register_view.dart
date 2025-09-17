import 'package:flutter/material.dart';
import 'package:here4u/core/utils/validators.dart';
import 'package:here4u/mvvm/data/services/user_service.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';
import 'package:here4u/mvvm/ui/widgets/inputs/rounded_textbox.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final userService = UserService();
    await userService.registerWithEmail(email, password, name);
    if (!mounted) return;
    SnackWarning.show(context, 'Please check your email to verify your account.');
    Navigator.pop(context); // Go back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                RoundedTextbox(
                  hintText: 'Name',
                  controller: _nameController,
                  validator: nameValidator,
                ),
                const SizedBox(height: 16),
                RoundedTextbox(
                  hintText: 'Email',
                  controller: _emailController,
                  validator: emailValidator,
                ),
                const SizedBox(height: 16),
                RoundedTextbox(
                  hintText: 'Password',
                  controller: _passwordController,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 32),
                // Register Button
                RoundedButton(
									text: 'Signup',
									onPressed: _register,
                  icon: Icons.app_registration,
								),

                const SizedBox(height: 16),

                // Back to Login Button
                RoundedButton(
                  text: 'Back to Login',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: const Color(0xFF8CC0CF),
                  textColor: Colors.black,
                  icon: Icons.login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
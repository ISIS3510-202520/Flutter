import 'package:flutter/material.dart';
import 'package:here4u/core/utils/validators.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/recover_password_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/inputs/rounded_textbox.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';
import 'package:here4u/mvvm/ui/widgets/warnings/snack_warning.dart';

class RecoverPasswordView extends StatefulWidget {
  const RecoverPasswordView({super.key});

  @override
  State<RecoverPasswordView> createState() => _RecoverPasswordViewState();
}

class _RecoverPasswordViewState extends State<RecoverPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _recover() async {
    if (!_formKey.currentState!.validate()) return;
    final viewModel = context.read<RecoverPasswordViewModel>();
    final error = await viewModel.recoverPassword(_emailController.text);
    if (!mounted) return;
    if (error == null) {
      SnackWarning.show(
        context,
        'Recovery email sent. Please check your inbox.',
      );
      if (mounted) Navigator.pop(context);
    } else {
      SnackWarning.show(context, error);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecoverPasswordViewModel(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recover Password',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 64),
                    child: Text(
                      'Please enter your registered email to recover your password.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  RoundedTextbox(
                    hintText: 'Email',
                    controller: _emailController,
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 32),
                  // Register Button
                  RoundedButton(
                    text: 'Recover',
                    onPressed: _recover,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  // Back to Login Button
                  RoundedButton(
                    text: 'Back',
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
      ),
    );
  }
}

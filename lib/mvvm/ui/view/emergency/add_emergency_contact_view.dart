import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/add_emergency_contact_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/inputs/rounded_textbox.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class AddEmergencyContactView extends StatelessWidget {
  const AddEmergencyContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddEmergencyContactViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create an Emergency contact",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.person, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),

                  // Campos controlados por el VM
                  RoundedTextbox(
                    hintText: "Name",
                    controller: vm.nameController,
                  ),
                  const SizedBox(height: 16),
                  RoundedTextbox(
                    hintText: "Relationship",
                    controller: vm.relationController,
                  ),
                  const SizedBox(height: 16),
                  RoundedTextbox(
                    hintText: "Number",
                    controller: vm.phoneController,
                  ),
                  const SizedBox(height: 16),
                  RoundedTextbox(
                    hintText: "Email",
                    controller: vm.emailController,
                  ),

                  const SizedBox(height: 20),
                  RoundedButton(
                    text: "add",
                    icon: Icons.person_add,
                    // 👉 Toda la lógica se ejecuta en el VM
                    onPressed: () => vm.onAddPressed(context),
                  ),
                  const SizedBox(height: 16),
                  RoundedButton(
                    text: "Back",
                    // 👉 Navegación delegada al VM
                    onPressed: () => vm.onBackPressed(context),
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

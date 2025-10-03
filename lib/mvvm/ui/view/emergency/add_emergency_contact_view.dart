import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/add_emergency_contact_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/emergency_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/inputs/rounded_textbox.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class AddEmergencyContactView extends StatelessWidget {
  const AddEmergencyContactView({super.key});

  bool _isValidEmail(String email) {
    // Basic, case-insensitive email pattern
    final regex = RegExp(
      r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
      caseSensitive: false,
    );
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddEmergencyContactViewModel>();
    final emergencyVm = context.read<EmergencyViewModel>();

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

                  RoundedTextbox(hintText: "Name", controller: vm.nameController),
                  const SizedBox(height: 16),
                  RoundedTextbox(hintText: "Relationship", controller: vm.relationController),
                  const SizedBox(height: 16),
                  RoundedTextbox(hintText: "Number", controller: vm.phoneController),
                  const SizedBox(height: 16),
                  RoundedTextbox(hintText: "Email", controller: vm.emailController),

                  const SizedBox(height: 20),
                  RoundedButton(
                    text: "add",
                    icon: Icons.person_add,
                    onPressed: () {
                      final name = vm.nameController.text.trim();
                      final relation = vm.relationController.text.trim();
                      final phone = vm.phoneController.text.trim();
                      final email = vm.emailController.text.trim();

                      if (name.isEmpty || relation.isEmpty || phone.isEmpty || email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      if (!_isValidEmail(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email address'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      // Update controllers with trimmed values (optional)
                      vm.nameController.text = name;
                      vm.relationController.text = relation;
                      vm.phoneController.text = phone;
                      vm.emailController.text = email;

                      final newContact = vm.createContact(); // TODO: use real userId if needed
                      emergencyVm.addContact(newContact);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contacto agregado'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  RoundedButton(
                    text: "Back",
                    onPressed: () => Navigator.pop(context),
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

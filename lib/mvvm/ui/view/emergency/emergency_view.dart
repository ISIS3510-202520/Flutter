import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/emergency_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';
import 'package:here4u/mvvm/ui/view/emergency/add_emergency_contact_view.dart';
import 'package:here4u/mvvm/ui/view_model/add_emergency_contact_view_model.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

  void _soonSnack(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Próximamente podrás llamar a $name'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmergencyViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Emergency Contacts",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Mostrar mensaje si no hay contactos
                  if (vm.contacts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "There are no contacts.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 28,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: vm.contacts.map((c) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => _soonSnack(context, c.name),
                                child: Ink(
                                  width: 96,
                                  height: 96,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF86D9F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 44,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              c.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 28),

                  // Botón para añadir contacto
                  RoundedButton(
                    text: "Add Contact",
                    color: Colors.pink[200]!,
                    textColor: Colors.black,
                    onPressed: () {
                      final emergencyVm = context.read<EmergencyViewModel>();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => AddEmergencyContactViewModel(
                                  authViewModel: context.read<AuthViewModel>(),
                                ),
                              ),
                              ChangeNotifierProvider.value(value: emergencyVm),
                            ],
                            child: const AddEmergencyContactView(),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                  Text(
                    "Stay calm breath deeply",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  RoundedButton(
                    text: "Back",
                    onPressed: () => Navigator.pop(context),
                    color: const Color(0xFF86D9F0),
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

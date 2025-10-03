import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/emergency_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

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

                  // Empty state
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
                                onTap: () => vm.onTapContact(context, c.name),
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

                  // Add contact
                  RoundedButton(
                    text: "Add Contact",
                    color: Colors.pink[200]!,
                    textColor: Colors.black,
                    onPressed: () => vm.startAddContactFlow(context),
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
                    onPressed: () => vm.goBack(context),
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

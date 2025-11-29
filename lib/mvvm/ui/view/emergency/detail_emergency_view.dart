import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/detail_emergency_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class DetailEmergencyView extends StatelessWidget {
  const DetailEmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailEmergencyViewModel>();
    final contact = vm.contact;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Emergency contact of ${contact.name.split(' ').first}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.person, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _labelAndValue('Name', contact.name),
                        const SizedBox(height: 12),
                        _labelAndValue('Email', contact.email),
                        const SizedBox(height: 12),
                        _labelAndValue('Phone', contact.phone),
                        const SizedBox(height: 12),
                        _labelAndValue('Relation', contact.relation),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    text: 'Delete Contact',
                    color: const Color(0xFFFFDBD2),
                    textColor: Colors.black,
                    onPressed: () => vm.deleteContact(context),
                    icon: Icons.delete_forever,
                    width: 200,
                  ),

                  const SizedBox(height: 12),

                  RoundedButton(
                    text: 'Back',
                    color: const Color(0xFF86D9F0),
                    textColor: Colors.black,
                    onPressed: () => vm.goBack(context),
                    icon: Icons.arrow_back,
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelAndValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

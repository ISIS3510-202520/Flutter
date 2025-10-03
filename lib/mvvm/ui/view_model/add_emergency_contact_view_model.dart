import 'package:flutter/material.dart';
import 'package:here4u/models/emergency_contact.dart';

class AddEmergencyContactViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final relationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  EmergencyContact createContact(String userId) {
    return EmergencyContact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      relation: relationController.text.trim(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    relationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

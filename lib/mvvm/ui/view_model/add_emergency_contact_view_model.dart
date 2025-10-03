import 'package:flutter/material.dart';
import 'package:here4u/models/emergency_contact.dart';
import 'auth_view_model.dart';

class AddEmergencyContactViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final relationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final AuthViewModel _authViewModel;

  AddEmergencyContactViewModel({
    required AuthViewModel authViewModel,
  }) : _authViewModel = authViewModel;



  EmergencyContact createContact() {
    final uId = _authViewModel.currentUser?.uid;
    return EmergencyContact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: uId ?? "",
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

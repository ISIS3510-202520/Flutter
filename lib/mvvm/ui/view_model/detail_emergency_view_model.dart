import 'package:flutter/material.dart';
import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/ui/view_model/emergency_view_model.dart';

class DetailEmergencyViewModel extends ChangeNotifier {
  final EmergencyContact contact;
  final EmergencyViewModel emergencyViewModel;

  DetailEmergencyViewModel({
    required this.contact,
    required this.emergencyViewModel,
  });

  /// Deletes the contact via the parent EmergencyViewModel then closes the view.
  Future<void> deleteContact(BuildContext context) async {
    emergencyViewModel.deleteContact(contact);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact deleted'), duration: Duration(seconds: 2)),
      );
      Navigator.of(context).pop();
    }
  }

  /// Simple wrapper to pop the current view
  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/ui/view/emergency/add_emergency_contact_view.dart';
import 'package:here4u/mvvm/ui/view_model/add_emergency_contact_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';

class EmergencyViewModel extends ChangeNotifier {
  final List<EmergencyContact> _contacts;

  EmergencyViewModel({required List<EmergencyContact> contacts})
      : _contacts = contacts;

  /// Exposes contacts as an unmodifiable view so the UI can't mutate directly.
  List<EmergencyContact> get contacts => List.unmodifiable(_contacts);

  /// Adds a new contact and notifies listeners so the UI re-builds.
  void addContact(EmergencyContact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  /// Handles a tap on a contact.
  /// Current behavior: show a short SnackBar informing that calling
  /// will be available soon.
  /// - Keeps the exact copy: "Soon you will be able to call $name"
  void onTapContact(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Soon you will be able to call $name'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Starts the "Add Contact" flow by navigating to AddEmergencyContactView.
  /// Behavior preserved:
  /// - Pushes a route with a MultiProvider:
  ///   * AddEmergencyContactViewModel (needs AuthViewModel from context)
  ///   * This EmergencyViewModel instance (so the add screen can call back)
  void startAddContactFlow(BuildContext context) {
    final authVm = context.read<AuthViewModel>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => AddEmergencyContactViewModel(authViewModel: authVm),
            ),
            // Expose THIS EmergencyViewModel to the add screen
            ChangeNotifierProvider.value(value: this),
          ],
          child: const AddEmergencyContactView(),
        ),
      ),
    );
  }

  /// Handles the "Back" button behavior.
  /// Current behavior: pop the current route.
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

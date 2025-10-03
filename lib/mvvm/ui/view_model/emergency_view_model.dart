import 'package:flutter/material.dart';
import 'package:here4u/models/emergency_contact.dart';

class EmergencyViewModel extends ChangeNotifier {
  
  final List<EmergencyContact> _contacts = [
    EmergencyContact(
      id: '1',
      userId: 'me',
      name: 'Mom',
      phone: '123456789',
      email: 'mom@email.com',
      relation: 'Mother',
    ),
    EmergencyContact(
      id: '2',
      userId: 'me',
      name: 'Psicologist',
      phone: '987654321',
      email: 'psicologist@email.com',
      relation: 'Therapist',
    ),
  ];

  List<EmergencyContact> get contacts => List.unmodifiable(_contacts);

  void addContact(EmergencyContact contact) {
    _contacts.add(contact);
    notifyListeners();
  }
}

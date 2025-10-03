import 'package:flutter/material.dart';
import 'package:here4u/models/emergency_contact.dart';

class EmergencyViewModel extends ChangeNotifier {

  final List<EmergencyContact> _contacts;

  EmergencyViewModel({required List<EmergencyContact> contacts}) :  
  _contacts = contacts;

  List<EmergencyContact> get contacts => List.unmodifiable(_contacts);

  void addContact(EmergencyContact contact) {
    _contacts.add(contact);
    notifyListeners();
  }
}

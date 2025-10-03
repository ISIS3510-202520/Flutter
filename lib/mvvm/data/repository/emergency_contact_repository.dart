import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/data/services/emergency_contact_service.dart';

class EmergencyContactRepository {
  // Implementation of the repository

  final EmergencyContactService _service;
  EmergencyContactRepository(this._service);

  Future<void> saveContact(contact) {
    return _service.saveContact(contact);
  }

  Future<List<EmergencyContact>> getContacts(String userId) {
    return _service.getContacts(userId);
  }

  
}
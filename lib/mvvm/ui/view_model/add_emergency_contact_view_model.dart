import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/data/repository/emergency_contact_repository.dart';
import 'package:here4u/mvvm/data/services/emergency_contact_service.dart';
import 'package:here4u/mvvm/ui/view_model/emergency_view_model.dart';
import 'auth_view_model.dart';

class AddEmergencyContactViewModel extends ChangeNotifier {
  // Controladores de texto expuestos a la vista (la vista solo renderiza).
  final nameController = TextEditingController();
  final relationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // Repositorio para persistir el contacto (misma lógica que tenías).
  final EmergencyContactRepository _repository =
      EmergencyContactRepository(EmergencyContactService());

  // Dependencia para leer el usuario actual.
  final AuthViewModel _authViewModel;

  AddEmergencyContactViewModel({
    required AuthViewModel authViewModel,
  }) : _authViewModel = authViewModel;

  /// Valida el formato de email con una expresión regular
  /// case-insensitive (mismo comportamiento del método privado que estaba en la view).
  bool _isValidEmail(String email) {
    final regex = RegExp(
      r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
      caseSensitive: false,
    );
    return regex.hasMatch(email);
  }

  /// Crea la entidad `EmergencyContact`, persiste en el repositorio
  /// y devuelve una copia con un id local para reflejarse en UI inmediatamente.
  ///
  /// - Mantiene el `saveContact` al repositorio (como en tu código).
  /// - Usa el `uid` del usuario actual si está disponible.
  EmergencyContact _createAndSaveContact() {
    final uId = _authViewModel.currentUser?.uid ?? "";

    final trimmed = (
      name: nameController.text.trim(),
      relation: relationController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
    );

    // Persistencia (p.ej. Firestore autogenerará ID en backend).
    _repository.saveContact(
      EmergencyContact(
        id: "", // lo establece Firestore
        userId: uId,
        name: trimmed.name,
        phone: trimmed.phone,
        email: trimmed.email,
        relation: trimmed.relation,
      ),
    );

    // Entidad con id local para añadirla a la lista en memoria inmediatamente.
    return EmergencyContact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: uId,
      name: trimmed.name,
      phone: trimmed.phone,
      email: trimmed.email,
      relation: trimmed.relation,
    );
  }

  /// Handler del botón "add".
  /// El flujo es:
  /// 1) Lee y recorta valores
  /// 2) Valida campos vacíos -> SnackBar y return
  /// 3) Valida email -> SnackBar y return
  /// 4) Sobrescribe controllers con los recortes (misma "opcionalidad")
  /// 5) Crea y guarda contacto
  /// 6) Lo añade al EmergencyViewModel para refrescar la UI
  /// 7) Hace pop de la pantalla
  /// 8) Muestra SnackBar "Contacto agregado"
  void onAddPressed(BuildContext context) {
    final name = nameController.text.trim();
    final relation = relationController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    // 2) Validación de requeridos
    if (name.isEmpty || relation.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 3) Validación de email
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 4) Sobrescribir controllers con los valores recortados
    nameController.text = name;
    relationController.text = relation;
    phoneController.text = phone;
    emailController.text = email;

    // 5) Crear y guardar contacto
    final newContact = _createAndSaveContact();

    // 6) Añadir al EmergencyViewModel (presente en el árbol por el MultiProvider)
    final emergencyVm =
        Provider.of<EmergencyViewModel>(context, listen: false);
    emergencyVm.addContact(newContact);

    // 7) Cerrar pantalla
    Navigator.pop(context);

    // 8) Confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Handler del botón "Back": hace pop de la ruta actual (mismo comportamiento).
  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
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

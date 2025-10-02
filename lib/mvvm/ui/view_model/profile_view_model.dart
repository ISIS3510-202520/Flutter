import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here4u/mvvm/ui/view/auth/login_view.dart';

class ProfileViewModel extends ChangeNotifier {
  // Datos mínimos para pintar la pantalla
  final String displayName;
  final String? photoUrl;

  ProfileViewModel({
    this.displayName = 'Jane Doe',
    this.photoUrl,
  });

  // Si luego necesitas cargar datos remotos:
  Future<void> init() async {
    // TODO: cargar foto/nombre desde tu fuente (Firebase, API, etc.)
  }

  // Navegaciones aún no implementadas (las vistas no existen)
  void onTapSummaries(BuildContext context) {
    // TODO: navegar a Summaries cuando exista
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summaries: próximamente')),
    );
  }

  void onTapJournal(BuildContext context) {
    // TODO: navegar a Journal cuando exista
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal: próximamente')),
    );
  }

  // Cerrar sesión (por ahora solo feedback visual)
  Future<void> onTapSignOut(BuildContext context) async {
    
    FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada')),
    );

    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (_) => false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/auth/auth_view.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  // Remove local data storage since we'll get it from AuthViewModel

  ProfileViewModel();

  // Remove init() method - no longer needed since AuthViewModel handles data loading

  // Get data from global AuthViewModel instead
  String getDisplayName(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    return authViewModel.displayName;
  }

  String getEmail(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    return authViewModel.currentUser?.email ?? 'No email';
  }

  // Navigation methods remain the same
  void onTapSummaries(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Summaries: soon!')));
  }

  void onTapJournal(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Journal: soon!')));
  }

  Future<void> onTapSignOut(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();

    try {
      await authViewModel.signOut();

      // Check if the context is still mounted before using it
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully!')),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthView()),
          (_) => false,
        );
      }
    } catch (e) {
      // Handle any sign-out errors
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<Position?> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  String _formatLocation(Position position) {
    return 'Lat: ${position.latitude.toStringAsFixed(6)}, '
           'Lng: ${position.longitude.toStringAsFixed(6)}';
  }

  String _getGoogleMapsLink(Position position) {
    return 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
  }

  /// Sends an emergency email to a specific contact
  Future<bool> _sendEmergencyEmail(String recipientEmail, String recipientName, String locationMessage, String senderName) async {
    try {
      final username = dotenv.env['GMAIL_USERNAME'];
      final password = dotenv.env['GMAIL_APP_PASSWORD'];

      if (username == null || password == null) {
        debugPrint('Gmail credentials not found in .env file');
        return false;
      }

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username, 'Here4U Emergency Alert')
        ..recipients.add(recipientEmail)
        ..subject = '🚨 Emergency Alert from $senderName - Here4U App'
        ..html = '''
        <h2 style="color: #d32f2f;">🚨 EMERGENCY ALERT</h2>
        <p>Dear <strong>$recipientName</strong>,</p>
        
        <p>This is an <strong>emergency alert</strong> from <strong>$senderName</strong> using the Here4U app.</p>
        
        <div style="background-color: #ffebee; padding: 15px; border-left: 4px solid #d32f2f; margin: 15px 0;">
          <h3 style="color: #d32f2f; margin-top: 0;">Location Information:</h3>
          <p style="font-family: monospace; background: #f5f5f5; padding: 10px; border-radius: 4px;">
            ${locationMessage.replaceAll('\n', '<br>')}
          </p>
        </div>
        
        <p><strong>Please reach out to $senderName as soon as possible.</strong></p>
        
        <p style="margin-top: 30px; font-size: 14px; color: #666;">
          Best regards,<br>
          <strong>Here4U Team</strong><br>
          <em>Mental Health Support App</em>
        </p>
        ''';

      final sendReport = await send(message, smtpServer);
      debugPrint('Email sent to $recipientEmail: ${sendReport.toString()}');
      return true;

    } catch (e) {
      debugPrint('Error sending email to $recipientEmail: $e');
      return false;
    }
  }

  void notifyAllContacts(BuildContext context) async {
    // Check if the user has any contacts
    if (_contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No contacts to notify. Please add contacts first.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Getting your location and sending alerts...'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );

    // Get current user's name from AuthViewModel
    final authViewModel = context.read<AuthViewModel>();
    final senderName = authViewModel.displayName;
    
    // Gather users current location to send in message
    final userLocation = await _getCurrentLocation();
    
    String locationMessage;
    if (userLocation != null) {
      final locationString = _formatLocation(userLocation);
      final mapsLink = _getGoogleMapsLink(userLocation);
      locationMessage = 'Current location: $locationString\nView on map: $mapsLink';
    } else {
      locationMessage = 'Location not available - please contact immediately';
    }

    // Send emails to all contacts
    int successCount = 0;
    int totalContacts = _contacts.length;

    for (var contact in _contacts) {
      final success = await _sendEmergencyEmail(
        contact.email,
        contact.name,
        locationMessage,
        senderName,
      );
      
      if (success) {
        successCount++;
      }
    }
    
    // Show result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successCount == totalContacts
            ? '✅ All $totalContacts contacts have been notified!'
            : '⚠️ $successCount of $totalContacts contacts were notified. Some emails may have failed.'
        ),
        backgroundColor: successCount == totalContacts ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );

    // For debugging
    debugPrint('Emergency alert sent: $successCount/$totalContacts emails successful');
    debugPrint('Location: $locationMessage');
  }
}

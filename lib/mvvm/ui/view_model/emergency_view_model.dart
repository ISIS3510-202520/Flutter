import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:isolate';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:here4u/core/services/network_service.dart';

import 'package:here4u/models/emergency_contact.dart';
import 'package:here4u/mvvm/ui/view/emergency/add_emergency_contact_view.dart';
import 'package:here4u/mvvm/ui/view_model/add_emergency_contact_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';

class EmergencyViewModel extends ChangeNotifier {
  final List<EmergencyContact> _contacts;
  DateTime? _startTime;
  bool _engagementLogged = false;

  EmergencyViewModel({required List<EmergencyContact> contacts})
      : _contacts = contacts;

  /// Exposes contacts as an unmodifiable view so the UI can't mutate directly.
  List<EmergencyContact> get contacts => List.unmodifiable(_contacts);

  /// Adds a new contact and notifies listeners so the UI re-builds.
  void addContact(EmergencyContact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  /// Start tracking engagement time for analytics. Call when the view is shown.
  void startEngagementTimer() {
    _startTime = DateTime.now();
    _engagementLogged = false;
  }

  /// Returns engagement time in milliseconds.
  int getEngagementTime() {
    if (_startTime == null) return 0;
    return DateTime.now().difference(_startTime!).inMilliseconds;
  }

  /// Logs engagement analytics once for the view. Subsequent calls are no-ops.
  Future<void> logEngagement(String screenName) async {
    if (_startTime == null) return;
    if (_engagementLogged) return;
    final engagementTime = getEngagementTime();
    await FirebaseAnalytics.instance.logEvent(
      name: 'screen_engagement_flutter',
      parameters: {
        'screen_name': screenName,
        'engagement_time_msec': engagementTime,
      },
    );
    _engagementLogged = true;
    debugPrint('[EmergencyViewModel] Logged engagement: $engagementTime ms for $screenName');
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
  Future<void> goBack(BuildContext context) async {
    // Log engagement before navigating back.
    await logEngagement('EmergencyView');
    if (context.mounted) Navigator.pop(context);
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
  // (Per-email sending now handled by top-level helper `_sendEmailSerialized`)

  void notifyAllContacts(BuildContext context) async {
    // Prevent sending when offline
    try {
      final network = context.read<NetworkService>();
      if (!network.isOnline) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot notify contacts while offline')),
          );
        }
        return;
      }
    } catch (_) {
      // If we cannot read the NetworkService (e.g., provider not available), proceed conservatively.
    }
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

    // Send emails to all contacts using 2 background isolates + main isolate.
    int successCount = 0;
    int totalContacts = _contacts.length;

    // Serialize contacts for isolate-friendly messaging
    final serialized = _contacts
        .map((c) => {'email': c.email, 'name': c.name})
        .toList(growable: false);

    // If there are no contacts, bail out (shouldn't happen due to check above)
    if (serialized.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No contacts to notify. Please add contacts first.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Credentials - pass into isolates so they don't need dotenv
    final username = dotenv.env['GMAIL_USERNAME'];
    final password = dotenv.env['GMAIL_APP_PASSWORD'];
    if (username == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email credentials are not configured.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Split into 3 chunks: two will be processed in isolates, one on main isolate
    final int n = serialized.length;
    final int chunkSize = (n / 3).ceil();
    final List<List<Map<String, dynamic>>> chunks = [];
    for (int i = 0; i < n; i += chunkSize) {
      final end = (i + chunkSize) > n ? n : (i + chunkSize);
      chunks.add(serialized.sublist(i, end).cast<Map<String, dynamic>>());
    }

    // Ensure we have exactly 3 chunk slots (some may be empty)
    while (chunks.length < 3) chunks.add(<Map<String, dynamic>>[]);

    // Prepare params for isolates (for chunk 1 and 2). We'll process chunks[0] on main thread.
    final paramsForIsolate1 = {
      'contacts': chunks[1],
      'username': username,
      'password': password,
      'locationMessage': locationMessage,
      'senderName': senderName,
    };

    final paramsForIsolate2 = {
      'contacts': chunks[2],
      'username': username,
      'password': password,
      'locationMessage': locationMessage,
      'senderName': senderName,
    };

    final receive1 = ReceivePort();
    final receive2 = ReceivePort();

    Isolate? iso1;
    Isolate? iso2;

    Future<int> iso1Future = Future.value(0);
    Future<int> iso2Future = Future.value(0);

    try {
      // Spawn isolate 1 if it has work
      if ((paramsForIsolate1['contacts'] as List).isNotEmpty) {
        iso1 = await Isolate.spawn(_emailIsolateEntry, [receive1.sendPort, paramsForIsolate1]);
        iso1Future = receive1.first.then((v) => v as int);
      }

      // Spawn isolate 2 if it has work
      if ((paramsForIsolate2['contacts'] as List).isNotEmpty) {
        iso2 = await Isolate.spawn(_emailIsolateEntry, [receive2.sendPort, paramsForIsolate2]);
        iso2Future = receive2.first.then((v) => v as int);
      }

      // Process chunk 0 on main isolate
      final chunk0 = chunks[0];
      for (final c in chunk0) {
        final ok = await _sendEmailSerialized({
          'username': username,
          'password': password,
          'recipientEmail': c['email'],
          'recipientName': c['name'],
          'locationMessage': locationMessage,
          'senderName': senderName,
        });
        if (ok) successCount++;
      }

      // Await isolate results
  final List<int> results = await Future.wait<int>([iso1Future, iso2Future]);
  successCount += results.fold<int>(0, (p, e) => p + e);

    } catch (e) {
      debugPrint('Error dispatching isolates for emergency emails: $e');
    } finally {
      // Clean up isolates and ports
      try {
        receive1.close();
      } catch (_) {}
      try {
        receive2.close();
      } catch (_) {}
      try {
        iso1?.kill(priority: Isolate.immediate);
      } catch (_) {}
      try {
        iso2?.kill(priority: Isolate.immediate);
      } catch (_) {}
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

// ---------------------------------------------------------------------------
// Top-level helpers for background email sending (Isolate-friendly)
// ---------------------------------------------------------------------------

/// Send a single email using serialized params. This is a top-level
/// function so it can be invoked from spawned isolates. The params map
/// must contain: username, password, recipientEmail, recipientName,
/// locationMessage, senderName.
Future<bool> _sendEmailSerialized(Map<String, dynamic> params) async {
  try {
    final username = params['username'] as String;
    final password = params['password'] as String;
    final recipientEmail = params['recipientEmail'] as String;
    final recipientName = params['recipientName'] as String;
    final locationMessage = params['locationMessage'] as String;
    final senderName = params['senderName'] as String;

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
    debugPrint('Error sending serialized email: $e');
    return false;
  }
}

/// Send a list of contacts sequentially. Returns number of successful sends.
Future<int> _sendEmailsInIsolate(Map<String, dynamic> params) async {
  final contacts = (params['contacts'] as List<dynamic>).cast<Map<String, dynamic>>();
  int successCount = 0;
  for (final c in contacts) {
    final singleParams = {
      'username': params['username'],
      'password': params['password'],
      'recipientEmail': c['email'],
      'recipientName': c['name'],
      'locationMessage': params['locationMessage'],
      'senderName': params['senderName'],
    };
    final ok = await _sendEmailSerialized(singleParams);
    if (ok) successCount++;
  }
  return successCount;
}

/// Entry point for an isolate. Expects a 2-element list: [SendPort, paramsMap].
void _emailIsolateEntry(dynamic rawMessage) async {
  try {
    final message = rawMessage as List<dynamic>;
    final SendPort sendPort = message[0] as SendPort;
    final Map<String, dynamic> params = Map<String, dynamic>.from(message[1] as Map);

    final result = await _sendEmailsInIsolate(params);
    sendPort.send(result);
  } catch (e) {
    // If anything fails, send 0 successes back.
    try {
      final message = rawMessage as List<dynamic>;
      final SendPort sendPort = message[0] as SendPort;
      sendPort.send(0);
    } catch (_) {}
  }
}


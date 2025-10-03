import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:here4u/app.dart';
import 'firebase_options.dart';
import 'package:firebase_performance/firebase_performance.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file before running the app
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Start the startup trace at the very beginning
  final trace = FirebasePerformance.instance.newTrace("app_flutter_startup");
  await trace.start();

  try {
    // Load the app
    runApp(App(onAppReady: () async {
      // Stop the trace when the app is fully ready
      await trace.stop();
    }));

  } catch (e) {
    trace.putAttribute("startup_error", e.toString());
    await trace.stop();
    rethrow;
  }
}

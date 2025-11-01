import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:here4u/app.dart';
import 'firebase_options.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file before running the app
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Force enable data collection
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Forward Flutter framework errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Start the startup trace at the very beginning
  final trace = FirebasePerformance.instance.newTrace("app_flutter_startup");
  await trace.start();

  try {
    // Load the app
    runApp(App(
      analytics: analytics,
      onAppReady: () async {
        // Stop the trace when the app is fully ready
        await trace.stop();
        
        // Log app open event
        await analytics.logAppOpen();
      }
    ));

  } catch (e) {
    trace.putAttribute("startup_error", e.toString());
    await trace.stop();
    rethrow;
  }
}


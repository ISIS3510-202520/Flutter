import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:here4u/app.dart';
import 'package:here4u/mvvm/ui/view_model/Identify_emotions_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Load the .env file before running the app
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load the app
  runApp(const App());

  // If you want to use IdentifyEmotionsView with its ViewModel, uncomment below

  // runApp(
  //   ChangeNotifierProvider(
  //     create: (_) => IdentifyEmotionsViewModel(),
  //     child: const App(),
  //   ),
  // );
}
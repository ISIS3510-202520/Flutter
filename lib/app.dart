import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:here4u/mvvm/ui/view/Identify_emotions/Identify_emotions_view.dart';
import 'package:here4u/mvvm/ui/view/auth/auth_view.dart';
import 'package:here4u/mvvm/ui/view/home/home_view.dart';
class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'here4u',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        textTheme: GoogleFonts.openSansTextTheme(), // Apply Google Fonts Sans-serif
      ),
      //home: const AuthView(),

      // If you want to use Home and IdentifyEmotionsView with its ViewModel, uncomment below

      home: const HomeView(),
      routes: {
        '/identify': (_) => const IdentifyEmotionsView(),
        // Descomentar cuando sean reales:
        // '/profile': (_) => const ProfileView(),
        // '/achievements': (_) => const AchievementsView(),
        // '/exercises': (_) => const ExercisesView(),
        // '/emergency': (_) => const EmergencyView(),
      },

    );
  }
}
import 'package:flutter/material.dart';
import 'package:here4u/mvvm/ui/view/Identify_emotions/identify_emotions_view.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/identify_emotions_view_model.dart';
import 'package:provider/provider.dart';

import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

// Sub-widgets del Home
import 'package:here4u/mvvm/ui/widgets/home/home_header.dart';
import 'package:here4u/mvvm/ui/widgets/home/streak_badge.dart';
import 'package:here4u/mvvm/ui/widgets/home/emergency_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  // Define button width as a constant
  static const double buttonW = 220.0;
  static const double emergencyW = 260.0;
  
  void _identifyEmotions() {
    final authViewModel = context.read<AuthViewModel>();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => IdentifyEmotionsViewModel(userId: authViewModel.currentUser?.uid ?? "guest"),
          child: IdentifyEmotionsView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final authViewModel = context.watch<AuthViewModel>(); // Add this
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  HomeHeader(
                    titlePrefix: "Welcome ",
                    titleName: authViewModel.displayName, // Use authViewModel
                    onProfileTap: () => viewModel.onTapProfile(context),
                  ),
                  const Divider(height: 16, thickness: 1, color: Color(0xFFEDEDED)),
                  const SizedBox(height: 8),

                  // ZONA CENTRAL CENTRADA
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, inner) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: inner.maxHeight),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Streak
                                  StreakBadge(days: authViewModel.currentStreak), // Use authViewModel

                                  const SizedBox(height: 24),

                                  // Achievements
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: "Achievements",
                                      onPressed: () => viewModel.onTapAchievements(context),
                                      isBold: true,
                                      color: const Color(0xFF7CC1C3),
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Register Mood
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: viewModel.getMoodButtonText(),
                                      onPressed: _identifyEmotions,
                                      isBold: true,
                                      color: const Color(0xFF86D9F0),
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Daily exercises
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: "Daily exercises",
                                      onPressed: () => viewModel.onTapExercises(context),
                                      isBold: true,
                                      color: const Color(0xFF86D9F0),
                                      textColor: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // Emergency (grande)
                                  EmergencyButton(
                                    width: emergencyW,
                                    onPressed: () => viewModel.onTapEmergency(context),
                                    textStyle: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

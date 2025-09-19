import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

// Sub-widgets del Home
import 'package:here4u/mvvm/ui/widgets/home/home_header.dart';
import 'package:here4u/mvvm/ui/widgets/home/streak_badge.dart';
import 'package:here4u/mvvm/ui/widgets/home/emergency_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            // Botones medios ~70% del ancho, tope 360
            final buttonW = maxW * 0.70 > 360 ? 360.0 : maxW * 0.70;
            // Botón Emergency ~85% del ancho, tope 420
            final emergencyW = maxW * 0.85 > 420 ? 420.0 : maxW * 0.85;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HEADER (no centrado)
                  HomeHeader(
                    titlePrefix: "Welcome  ",
                    titleName: vm.displayName,
                    onProfileTap: () => vm.onTapProfile(context),
                  ),
                  const SizedBox(height: 8),
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
                                  StreakBadge(days: vm.streakDays),

                                  const SizedBox(height: 24),

                                  // Achievements
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: "Achievements",
                                      onPressed: () => vm.onTapAchievements(context),
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
                                      text: "Register Mood",
                                      onPressed: () => vm.onTapRegisterMood(context),
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
                                      onPressed: () => vm.onTapExercises(context),
                                      isBold: true,
                                      color: const Color(0xFF86D9F0),
                                      textColor: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // Emergency (grande)
                                  EmergencyButton(
                                    width: emergencyW,
                                    onPressed: () => vm.onTapEmergency(context),
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

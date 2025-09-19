import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here4u/mvvm/ui/view_model/home_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart'; // ajusta la ruta si cambia

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
              final buttonW = maxW * 0.70 > 360 ? 360.0 : maxW * 0.70;
              final emergencyW = maxW * 0.85 > 420 ? 420.0 : maxW * 0.85;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---------- HEADER ARRIBA (NO CENTRADO) ----------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Welcome  ",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                ),
                                TextSpan(
                                  text: "${context.read<HomeViewModel>().displayName} !!",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF8D9D6),
                          ),
                          onPressed: () => context.read<HomeViewModel>().onTapProfile(context),
                          icon: const Icon(Icons.person_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 16, thickness: 1, color: Color(0xFFEDEDED)),
                    const SizedBox(height: 8),

                    // ---------- CONTENIDO INFERIOR CENTRADO ----------
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, inner) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: inner.maxHeight),
                              child: Center( // 👈 centra vertical y horizontalmente el bloque
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Streak
                                    Column(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF8D9D6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.local_fire_department, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),
                                        Text("Streak",
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        Text("${context.watch<HomeViewModel>().streakDays} Days",
                                            style: Theme.of(context).textTheme.bodyLarge),
                                      ],
                                    ),

                                    const SizedBox(height: 24),

                                    // Botones medianos
                                    SizedBox(
                                      width: buttonW,
                                      child: RoundedButton(
                                        text: "Achievements",
                                        onPressed: () => context.read<HomeViewModel>().onTapAchievements(context),
                                        isBold: true,
                                        color: const Color(0xFF7CC1C3),
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      width: buttonW,
                                      child: RoundedButton(
                                        text: "Register Mood",
                                        onPressed: () => context.read<HomeViewModel>().onTapRegisterMood(context),
                                        isBold: true,
                                        color: const Color(0xFF86D9F0),
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      width: buttonW,
                                      child: RoundedButton(
                                        text: "Daily excercises",
                                        onPressed: () => context.read<HomeViewModel>().onTapExercises(context),
                                        isBold: true,
                                        color: const Color(0xFF86D9F0),
                                        textColor: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    // Botón grande Emergency
                                    SizedBox(
                                      width: emergencyW,
                                      child: ElevatedButton(
                                        onPressed: () => context.read<HomeViewModel>().onTapEmergency(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF8D9D6),
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          "Emergency",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
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

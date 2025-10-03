import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:here4u/mvvm/ui/view_model/profile_view_model.dart';
import 'package:here4u/mvvm/ui/view_model/auth_view_model.dart';
import 'package:here4u/mvvm/ui/widgets/buttons/rounded_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;

            // Botones medios ~70% del ancho, tope 420 (un poco más anchos en profile)
            final buttonW = maxW * 0.70 > 420 ? 420.0 : maxW * 0.70;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ========= SECCIÓN SUPERIOR (ajustada arriba) =========
                  Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Avatar + Nombre (también arriba, no centrado verticalmente)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: const Color(0xFFF7CFC6), // rosado suave
                        child: Icon(
                          Icons.person, 
                          size: 56, 
                          color: Colors.black.withValues(alpha: 0.8)
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        authViewModel.displayName,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ========= CONTENIDO CENTRAL (centrado en ancho y largo) =========
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
                                  // Summaries
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: "Summaries",
                                      onPressed: () => vm.onTapSummaries(context),
                                      isBold: true,
                                      color: const Color(0xFFF7CFC6), // mismo rosa del mock
                                      textColor: Colors.black,
                                      icon: Icons.summarize,
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Journal
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: "Journal",
                                      onPressed: () => vm.onTapJournal(context),
                                      isBold: true,
                                      color: const Color(0xFFF7CFC6),
                                      textColor: Colors.black,
                                      icon: Icons.book,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Sign Out (estilo parecido al Home)
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: "Sign Out",
                                      onPressed: () => vm.onTapSignOut(context),
                                      isBold: true,
                                      color: const Color(0xFF7CB4C3), // azul medio
                                      textColor: Colors.black,
                                      icon: Icons.logout,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Add the Back button here
                                  SizedBox(
                                    width: buttonW,
                                    child: RoundedButton(
                                      text: 'Back',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: const Color(0xFF8CC0CF),
                                      textColor: Colors.black,
                                      icon: Icons.arrow_back,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
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

import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String titlePrefix;
  final String titleName;
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.titlePrefix,
    required this.titleName,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineMedium;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Changed from start to center
      children: [
        // "Welcome  you !!"
        Expanded(
          child: Center( // Add Center widget
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: titlePrefix,
                    style: headline?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                  TextSpan(
                    text: '$titleName !!',
                    style: headline?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Botón perfil
        IconButton.filledTonal(
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF8D9D6),
          ),
          onPressed: onProfileTap,
          icon: const Icon(Icons.person_outline),
        ),
      ],
    );
  }
}

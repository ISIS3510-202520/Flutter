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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // “Welcome  you !!”
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: titlePrefix,
                  style: headline?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "$titleName !!",
                  style: headline?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
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

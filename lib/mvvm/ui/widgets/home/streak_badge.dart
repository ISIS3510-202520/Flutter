import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  final int days;

  const StreakBadge({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
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
        Text(
          "Streak",
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          "$days Days",
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}

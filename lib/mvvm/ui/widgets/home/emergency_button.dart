import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  final double width;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

  const EmergencyButton({
    super.key,
    required this.width,
    required this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
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
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

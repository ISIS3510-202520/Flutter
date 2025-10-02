import 'package:flutter/material.dart';

class Emotion {
  final String id;
  final String name;
  final String description;
  final String colorHex;

  const Emotion({
    required this.id,
    required this.name,
    required this.description,
    required this.colorHex,
  });

  /// Helper to convert hex string into Flutter [Color]
  Color get color {
    final hex = colorHex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}


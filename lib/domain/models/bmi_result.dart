import 'package:flutter/material.dart';

@immutable
class BMIResult {
  const BMIResult({
    required this.value,
    required this.category,
    required this.guidance,
    required this.color,
  });

  final double value;
  final String category;
  final String guidance;
  final Color color;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BMIResult &&
        other.value == value &&
        other.category == category &&
        other.guidance == guidance &&
        other.color == color;
  }

  @override
  int get hashCode {
    return Object.hash(value, category, guidance, color);
  }
}


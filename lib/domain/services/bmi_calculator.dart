import 'package:flutter/material.dart';
import '../models/bmi_input.dart';
import '../models/bmi_result.dart';

class BMICalculator {
  const BMICalculator();

  BMIResult calculate(BMIInput input) {
    final validationErrors = input.validate();
    if (validationErrors.isNotEmpty) {
      throw ArgumentError(validationErrors.join(', '));
    }

    final bmi = input.weight / ((input.height / 100) * (input.height / 100));
    return _createResult(bmi);
  }

  BMIResult _createResult(double bmi) {
    if (bmi < 16) {
      return BMIResult(
        value: bmi,
        category: 'Severe Thinness',
        guidance: 'Please consult a healthcare provider for healthy weight gain strategies.',
        color: const Color(0xFF1976D2),
      );
    } else if (bmi < 17) {
      return BMIResult(
        value: bmi,
        category: 'Moderate Thinness',
        guidance: 'Consider consulting a healthcare provider for healthy weight gain strategies.',
        color: const Color(0xFF2196F3),
      );
    } else if (bmi < 25) {
      return BMIResult(
        value: bmi,
        category: 'Normal',
        guidance: 'Great! You\'re in the healthy weight range. Keep up the good work!',
        color: const Color(0xFF2E7D32),
      );
    } else if (bmi < 30) {
      return BMIResult(
        value: bmi,
        category: 'Overweight',
        guidance: 'Consider lifestyle changes like diet and exercise to reach a healthier weight.',
        color: const Color(0xFFF57C00),
      );
    } else {
      return BMIResult(
        value: bmi,
        category: 'Obese',
        guidance: 'Please consult with a healthcare provider for weight management guidance.',
        color: const Color(0xFFD32F2F),
      );
    }
  }
}

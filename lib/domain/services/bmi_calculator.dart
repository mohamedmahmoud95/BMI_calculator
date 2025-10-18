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
    return BMIResult(
      value: bmi,
      category: _getBMICategory(bmi),
      guidance: _getBMIGuidance(bmi),
      color: _getBMIColor(bmi),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16) {
      return 'Severe Thinness';
    } else if (bmi < 17) {
      return 'Moderate Thinness';
    } else if (bmi < 18.5) {
      return 'Mild Thinness';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else if (bmi < 35) {
      return 'Obese Class I';
    } else if (bmi < 40) {
      return 'Obese Class II';
    } else {
      return 'Obese Class III';
    }
  }

  String _getBMIGuidance(double bmi) {
    if (bmi < 16) {
      return 'Please consult a healthcare provider immediately for healthy weight gain strategies.';
    } else if (bmi < 17) {
      return 'Consider consulting a healthcare provider for healthy weight gain strategies.';
    } else if (bmi < 18.5) {
      return 'You may be underweight. Consider consulting a healthcare provider for guidance.';
    } else if (bmi < 25) {
      return 'Great! You\'re in the healthy weight range. Maintain your current lifestyle.';
    } else if (bmi < 30) {
      return 'Consider lifestyle changes like diet and exercise to reach a healthier weight.';
    } else if (bmi < 35) {
      return 'Please consult with a healthcare provider for weight management guidance.';
    } else if (bmi < 40) {
      return 'Strongly recommend consulting with a healthcare provider for comprehensive weight management.';
    } else {
      return 'Please seek immediate medical advice for weight management and health assessment.';
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 16) {
      return const Color(0xFF1976D2);
    } else if (bmi < 17) {
      return const Color(0xFF2196F3);
    } else if (bmi < 18.5) {
      return const Color(0xFF03A9F4);
    } else if (bmi < 25) {
      return const Color(0xFF2E7D32);
    } else if (bmi < 30) {
      return const Color(0xFFF57C00);
    } else if (bmi < 35) {
      return const Color(0xFFFF5722);
    } else if (bmi < 40) {
      return const Color(0xFFD32F2F);
    } else {
      return const Color(0xFFB71C1C);
    }
  }
}

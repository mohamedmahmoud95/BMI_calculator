import 'package:flutter/material.dart';
import '../models/bmi_input.dart';
import '../models/bmi_result.dart';

class BMIRanges {
  const BMIRanges({
    required this.severeThinness,
    required this.moderateThinness,
    required this.mildThinness,
    required this.normal,
    required this.overweight,
    required this.obese1,
    required this.obese2,
  });

  final double severeThinness;
  final double moderateThinness;
  final double mildThinness;
  final double normal;
  final double overweight;
  final double obese1;
  final double obese2;
}

class BMICalculator {
  const BMICalculator();

  BMIResult calculate(BMIInput input) {
    final validationErrors = input.validate();
    if (validationErrors.isNotEmpty) {
      throw ArgumentError(validationErrors.join(', '));
    }

    final bmi = input.weight / ((input.height / 100) * (input.height / 100));
    return _createResult(bmi, input.gender);
  }

  BMIResult _createResult(double bmi, Gender gender) {
    return BMIResult(
      value: bmi,
      category: _getBMICategory(bmi, gender),
      guidance: _getBMIGuidance(bmi, gender),
      color: _getBMIColor(bmi),
    );
  }

  String _getBMICategory(double bmi, Gender gender) {
    final ranges = _getGenderSpecificRanges(gender);
    
    if (bmi < ranges.severeThinness) {
      return 'Severe Thinness';
    } else if (bmi < ranges.moderateThinness) {
      return 'Moderate Thinness';
    } else if (bmi < ranges.mildThinness) {
      return 'Mild Thinness';
    } else if (bmi < ranges.normal) {
      return 'Normal';
    } else if (bmi < ranges.overweight) {
      return 'Overweight';
    } else if (bmi < ranges.obese1) {
      return 'Obese Class I';
    } else if (bmi < ranges.obese2) {
      return 'Obese Class II';
    } else {
      return 'Obese Class III';
    }
  }

  String _getBMIGuidance(double bmi, Gender gender) {
    final ranges = _getGenderSpecificRanges(gender);
    
    if (bmi < ranges.severeThinness) {
      return 'Please consult a healthcare provider immediately for healthy weight gain strategies.';
    } else if (bmi < ranges.moderateThinness) {
      return 'Consider consulting a healthcare provider for healthy weight gain strategies.';
    } else if (bmi < ranges.mildThinness) {
      return 'You may be underweight. Consider consulting a healthcare provider for guidance.';
    } else if (bmi < ranges.normal) {
      return gender == Gender.male 
          ? 'Great! You\'re in the healthy weight range. Males typically have higher muscle mass, so this BMI is appropriate.'
          : 'Great! You\'re in the healthy weight range. Maintain your current lifestyle.';
    } else if (bmi < ranges.overweight) {
      return gender == Gender.male
          ? 'Consider lifestyle changes. Males with higher muscle mass may have elevated BMI while still being healthy.'
          : 'Consider lifestyle changes like diet and exercise to reach a healthier weight.';
    } else if (bmi < ranges.obese1) {
      return 'Please consult with a healthcare provider for weight management guidance.';
    } else if (bmi < ranges.obese2) {
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

  BMIRanges _getGenderSpecificRanges(Gender gender) {
    switch (gender) {
      case Gender.male:
        return const BMIRanges(
          severeThinness: 16.0,
          moderateThinness: 17.0,
          mildThinness: 18.5,
          normal: 26.0,        
          overweight: 31.0,   
          obese1: 36.0,
          obese2: 41.0,
        );
      case Gender.female:
        return const BMIRanges(
          severeThinness: 16.0,
          moderateThinness: 17.0,
          mildThinness: 18.5,
          normal: 25.0,       
          overweight: 30.0,   
          obese1: 35.0,
          obese2: 40.0,
        );
    }
  }
}

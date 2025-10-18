import 'package:flutter/material.dart';

@immutable
class BMIInput {
  const BMIInput({
    required this.height,
    required this.weight,
    required this.gender,
  });

  final double height;
  final double weight;
  final Gender gender;

  List<String> validate() {
    final errors = <String>[];
    
    if (height <= 0) {
      errors.add('Height must be greater than 0');
    }
    
    if (height > 300) {
      errors.add('Height must be realistic (≤ 300 cm)');
    }
    
    if (weight <= 0) {
      errors.add('Weight must be greater than 0');
    }
    
    if (weight > 1000) {
      errors.add('Weight must be realistic (≤ 1000 kg)');
    }
    
    return errors;
  }

  BMIInput copyWith({
    double? height,
    double? weight,
    Gender? gender,
  }) {
    return BMIInput(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BMIInput &&
        other.height == height &&
        other.weight == weight &&
        other.gender == gender;
  }

  @override
  int get hashCode => Object.hash(height, weight, gender);
}

enum Gender { male, female }

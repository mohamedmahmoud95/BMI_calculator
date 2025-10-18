import 'package:flutter/material.dart';
import '../../domain/models/bmi_result.dart';

class BMIResultDisplay extends StatelessWidget {
  const BMIResultDisplay({
    super.key,
    required this.result,
  });

  final BMIResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your BMI',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: result.color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Health Status',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.category,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: result.color,
            ),
          ),
        ],
      ),
    );
  }
}


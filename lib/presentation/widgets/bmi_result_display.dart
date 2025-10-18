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
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
                  Text(
                    'Your BMI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
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

           const SizedBox(height: 8),
          Text(
            result.guidance,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),

        ],
      ),
    );
  }
}


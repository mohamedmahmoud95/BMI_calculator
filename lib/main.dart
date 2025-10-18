import 'package:flutter/material.dart';
import 'presentation/screens/bmi_calculator_screen.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: _buildLightTheme(),
      home: const BMICalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3498DB),
        secondary: Color(0xFF2ECC71),
        surface: Colors.white,
        background: Color(0xFFF8F9FA),
        error: Color(0xFFE74C3C),
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
        labelSmall: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: Color(0xFF95A5A6)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../domain/models/bmi_input.dart';
import '../../domain/models/bmi_result.dart';
import '../../domain/services/bmi_calculator.dart';

class BMIViewModel extends ChangeNotifier {
  BMIViewModel({BMICalculator? calculator}) : _calculator = calculator ?? const BMICalculator();

  final BMICalculator _calculator;
  
  final ValueNotifier<Gender> _selectedGender = ValueNotifier(Gender.male);
  final ValueNotifier<String> _heightText = ValueNotifier('');
  final ValueNotifier<String> _weightText = ValueNotifier('');
  
  BMIResult? _result;
  String? _errorMessage;

  Gender get selectedGender => _selectedGender.value;
  String get heightText => _heightText.value;
  String get weightText => _weightText.value;
  BMIResult? get result => _result;
  String? get errorMessage => _errorMessage;

  ValueNotifier<Gender> get genderNotifier => _selectedGender;
  ValueNotifier<String> get heightNotifier => _heightText;
  ValueNotifier<String> get weightNotifier => _weightText;

  void updateGender(Gender gender) {
    _selectedGender.value = gender;
  }

  void updateHeight(String height) {
    _heightText.value = height;
  }

  void updateWeight(String weight) {
    _weightText.value = weight;
  }

  void calculateBMI() {
    try {
      _errorMessage = null;
      
      final height = double.tryParse(_heightText.value);
      final weight = double.tryParse(_weightText.value);
      
      if (height == null || weight == null) {
        _errorMessage = 'Please enter valid numbers for height and weight';
        notifyListeners();
        return;
      }
      
      final input = BMIInput(
        height: height,
        weight: weight,
        gender: _selectedGender.value,
      );
      
      _result = _calculator.calculate(input);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _result = null;
      notifyListeners();
    }
  }

  void reset() {
    _heightText.value = '';
    _weightText.value = '';
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _selectedGender.dispose();
    _heightText.dispose();
    _weightText.dispose();
    super.dispose();
  }
}


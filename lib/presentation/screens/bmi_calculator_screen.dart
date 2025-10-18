import 'package:flutter/material.dart';
import '../../data/view_models/bmi_view_model.dart';
import '../../domain/models/bmi_input.dart';
import '../widgets/action_buttons.dart';
import '../widgets/bmi_result_display.dart';
import '../widgets/error_display.dart';
import '../widgets/gender_selector.dart';
import '../widgets/input_fields.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  late final BMIViewModel _viewModel;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _viewModel = BMIViewModel();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    
    _viewModel.heightNotifier.addListener(_updateHeightController);
    _viewModel.weightNotifier.addListener(_updateWeightController);
  }

  void _updateHeightController() {
    if (_heightController.text != _viewModel.heightText) {
      _heightController.text = _viewModel.heightText;
    }
  }

  void _updateWeightController() {
    if (_weightController.text != _viewModel.weightText) {
      _weightController.text = _viewModel.weightText;
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildCentralIcon(),
              const SizedBox(height: 40),
              _buildInputSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
              const SizedBox(height: 32),
              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  if (_viewModel.errorMessage != null) {
                    return ErrorDisplay(message: _viewModel.errorMessage!);
                  }
                  
                  if (_viewModel.result != null) {
                    return BMIResultDisplay(result: _viewModel.result!);
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.favorite,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'BMI Calculator',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Calculate your Body Mass Index and check your health status',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCentralIcon() {
    return ValueListenableBuilder<Gender>(
      valueListenable: _viewModel.genderNotifier,
      builder: (context, gender, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(gender),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                gender == Gender.male 
                    ? 'assets/images/male_avatar.jpg'
                    : 'assets/images/female_avatar.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    gender == Gender.male ? Icons.male : Icons.female,
                    size: 48,
                    color: const Color(0xFF90A4AE),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        _buildInputField(
          label: 'Gender',
          child: ValueListenableBuilder<Gender>(
            valueListenable: _viewModel.genderNotifier,
            builder: (context, gender, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: gender == Gender.male 
                        ? const Color(0xFF3498DB) 
                        : const Color(0xFFE91E63),
                    width: 2,
                  ),
                ),
                child: DropdownButtonFormField<Gender>(
                  value: gender,
                  decoration: const InputDecoration(
                    hintText: 'Select your gender',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: Gender.values.map((Gender gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: gender == Gender.male 
                                  ? const Color(0xFF3498DB).withOpacity(0.1)
                                  : const Color(0xFFE91E63).withOpacity(0.1),
                            ),
                            child: Icon(
                              gender == Gender.male ? Icons.male : Icons.female,
                              size: 16,
                              color: gender == Gender.male 
                                  ? const Color(0xFF3498DB)
                                  : const Color(0xFFE91E63),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            gender == Gender.male ? 'Male' : 'Female',
                            style: TextStyle(
                              color: gender == Gender.male 
                                  ? const Color(0xFF3498DB)
                                  : const Color(0xFFE91E63),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Gender? newValue) {
                    if (newValue != null) {
                      _viewModel.updateGender(newValue);
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Height (cm)',
          child: TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter your height',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Weight (kg)',
          child: TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter your weight',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              _viewModel.updateHeight(_heightController.text);
              _viewModel.updateWeight(_weightController.text);
              _viewModel.calculateBMI();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Calculate BMI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _heightController.clear();
              _weightController.clear();
              _viewModel.reset();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reset',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBMICategories() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BMI Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoryRow('Severe Thinness', '< 16', const Color(0xFF1976D2)),
            _buildCategoryRow('Moderate Thinness', '16 - 17', const Color(0xFF2196F3)),
            _buildCategoryRow('Normal', '17 - 25', const Color(0xFF2E7D32)),
            _buildCategoryRow('Overweight', '25 - 30', const Color(0xFFF57C00)),
            _buildCategoryRow('Obese', '≥ 30', const Color(0xFFD32F2F)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


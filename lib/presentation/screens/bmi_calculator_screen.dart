import 'package:flutter/material.dart';
import '../../data/view_models/bmi_view_model.dart';
import '../../domain/models/bmi_input.dart';
import '../widgets/bmi_result_display.dart';
import '../widgets/error_display.dart';

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

  void _incrementHeight() {
    final currentValue = double.tryParse(_heightController.text) ?? 0;
    final newValue = (currentValue + 1).clamp(50, 250);
    _heightController.text = newValue.toString();
    _viewModel.updateHeight(_heightController.text);
  }

  void _decrementHeight() {
    final currentValue = double.tryParse(_heightController.text) ?? 0;
    final newValue = (currentValue - 1).clamp(50, 250);
    _heightController.text = newValue.toString();
    _viewModel.updateHeight(_heightController.text);
  }

  void _incrementWeight() {
    final currentValue = double.tryParse(_weightController.text) ?? 0;
    final newValue = (currentValue + 0.5).clamp(20, 300);
    _weightController.text = newValue.toString();
    _viewModel.updateWeight(_weightController.text);
  }

  void _decrementWeight() {
    final currentValue = double.tryParse(_weightController.text) ?? 0;
    final newValue = (currentValue - 0.5).clamp(20, 300);
    _weightController.text = newValue.toString();
    _viewModel.updateWeight(_weightController.text);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceBright,
          title: const Text('BMI Calculator'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
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



  Widget _buildCentralIcon() {
    return ValueListenableBuilder<Gender>(
      valueListenable: _viewModel.genderNotifier,
      builder: (context, gender, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Container(
            key: ValueKey(gender),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                ),
                child: DropdownButtonFormField<Gender>(
                  value: gender,
                  decoration: const InputDecoration(
                    hintText: 'Select your gender',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items:
                      Gender.values.map((Gender gender) {
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
                                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                                      : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                                ),
                                child: Icon(
                                  gender == Gender.male
                                      ? Icons.male
                                      : Icons.female,
                                  size: 16,
                                  color: gender == Gender.male
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                gender == Gender.male ? 'Male' : 'Female',
                                style: TextStyle(
                                  color: gender == Gender.male
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
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
          child: _buildNumberInputField(
            controller: _heightController,
            hintText: 'Enter your height',
            onIncrement: () => _incrementHeight(),
            onDecrement: () => _decrementHeight(),
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Weight (kg)',
          child: _buildNumberInputField(
            controller: _weightController,
            hintText: 'Enter your weight',
            onIncrement: () => _incrementWeight(),
            onDecrement: () => _decrementWeight(),
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildNumberInputField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
          ),
          Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outline),
          Column(
            children: [
              _buildArrowButton(
                icon: Icons.keyboard_arrow_up,
                onTap: onIncrement,
              ),
              Container(width: 1, height: 1, color: Theme.of(context).colorScheme.outline),
              _buildArrowButton(
                icon: Icons.keyboard_arrow_down,
                onTap: onDecrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceBright),
        child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
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
            ),
            child: const Text(
              'Calculate BMI',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            style: OutlinedButton.styleFrom(),
            child: Text(
              'Reset',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

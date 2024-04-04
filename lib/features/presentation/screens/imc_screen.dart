import 'package:flutter/material.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  double _height = 0.0; // Stores user entered height
  double _weight = 0.0; // Stores user entered weight
  double _imc = 0.0; // Stores calculated BMI
  String _interpretation = ""; // Stores BMI interpretation text

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _calculateImc() {
    setState(() {
      _imc = _weight / (_height * _height);
      _interpretation = _interpretImc(_imc);
    });
  }

  String _interpretImc(double imc) {
    if (imc < 18.5) {
      return "Underweight";
    } else if (imc < 25.0) {
      return "Normal weight";
    } else if (imc < 30.0) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Height (in meters)",
              ),
              onChanged: (value) {
                _height = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight (in kilograms)",
              ),
              onChanged: (value) {
                _weight = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _calculateImc,
              child: const Text('Calculate BMI'),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Your BMI: $_imc ($_interpretation)',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

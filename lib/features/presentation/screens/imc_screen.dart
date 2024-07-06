import 'package:flutter/material.dart';
import '../widgets.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  double _height = 0.0; 
  double _weight = 0.0; 
  double _imc = 0.0; 
  String _interpretation = ""; 
  bool _showResult = false; 

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _calculateImc() {
    if (_height <= 0 || _weight <= 0) {
      return;
    }
    setState(() {
      _imc = _weight / (_height * _height);
      _interpretation = _interpretImc(_imc);
      _showResult = true;
    });
  }

  String _interpretImc(double imc) {
    if (imc < 18.5) {
      return "Bajo de peso";
    } else if (imc < 25.0) {
      return "Peso normal";
    } else if (imc < 30.0) {
      return "Sobrepeso";
    } else {
      return "Obesidad";
    }
  }

  Color getColorForImc(double imc) {
    if (imc < 18.5) {
      return Colors.blue;
    } else if (imc < 25.0) {
      return Colors.green;
    } else if (imc < 30.0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextFormField(
              label: 'Ingresa tu altura (Mts)',
              controller: _heightController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _height = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              label: 'Ingresa tu peso (Kg)',
              onChanged: (value) {
                _weight = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomFilledButton(
                onPressed: _calculateImc,
                text: 'Calcular',
              ),
            ),
            const SizedBox(height: 20.0),
            if (_showResult)
              Column(
                children: [
                  Text(
                    'Tu indice es : ${_imc.toStringAsFixed(2)} ($_interpretation)',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  _buildImcThermometer(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImcThermometer() {
    return Column(
      children: [
        _buildThermometerSegment('Obesidad', Colors.red, 30, 40),
        _buildThermometerSegment('Sobrepeso', Colors.yellow, 25, 30),
        _buildThermometerSegment('Peso normal', Colors.green, 18.5, 25),
        _buildThermometerSegment('Bajo de peso', Colors.blue, 0, 18.5),
      ],
    );
  }

  Widget _buildThermometerSegment(String label, Color color, double minValue, double maxValue) {
    final isActive = _imc >= minValue && _imc < maxValue;

    return Row(
      children: [
        Container(
          height: 50,
          width: 20,
          color: isActive ? color : color.withOpacity(0.3),
        ),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: isActive ? color : color.withOpacity(0.3))),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class PersonalRecordScreen extends StatefulWidget {
  @override
  _PersonalRecordScreenState createState() => _PersonalRecordScreenState();
}

class _PersonalRecordScreenState extends State<PersonalRecordScreen> {
  String? selectedRoutine;
  final TextEditingController _pesoController = TextEditingController();
  DateTime? selectedDate;

  // Simulación de rutinas asignadas
  List<String> userRoutines = ['Rutina de Piernas', 'Rutina de Pecho', 'Rutina de Espalda'];

  // Función para seleccionar una fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar PR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown para seleccionar rutina
            DropdownButtonFormField<String>(
              value: selectedRoutine,
              onChanged: (newValue) {
                setState(() {
                  selectedRoutine = newValue;
                });
              },
              items: userRoutines.map((routine) {
                return DropdownMenuItem(
                  value: routine,
                  child: Text(routine),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Seleccionar Rutina',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo para el peso
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso levantado (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Botón para seleccionar la fecha
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? 'Seleccionar Fecha'
                      : 'Fecha: ${selectedDate!.toLocal()}'.split(' ')[0],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Seleccionar Fecha'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botón para guardar el PR
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar validaciones
                  if (selectedRoutine != null &&
                      _pesoController.text.isNotEmpty &&
                      selectedDate != null) {
                    // Aquí iría la lógica para enviar los datos
                    print('Rutina: $selectedRoutine');
                    print('Peso: ${_pesoController.text} kg');
                    print('Fecha: $selectedDate');
                  } else {
                    print('Por favor, completa todos los campos');
                  }
                },
                child: const Text('Agregar PR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

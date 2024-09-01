import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/providers.dart';
import 'package:time_to_train/features/presentation/widgets.dart';

class RoutineModal extends ConsumerStatefulWidget {
  const RoutineModal({super.key});

  @override
  _RoutineModalState createState() => _RoutineModalState();
}

class _RoutineModalState extends ConsumerState<RoutineModal> {
  String? selectedGroup;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<TextEditingController> videoControllers = [];
  bool addVideoField = false;
  DateTime _selectedDate = DateTime.now(); // Variable para almacenar la fecha seleccionada

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> saveRoutine() async {
    if (selectedGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un grupo')),
      );
      return;
    }

    final routineRepository = ref.read(routineRepositoryProvider);

    final routine = {
      'nombre': titleController.text,
      'descripcion': descriptionController.text,
      'usuario_id': 1, // Aquí deberías obtener el ID del usuario actual
      'grupo_id': int.parse(selectedGroup!),
      'fecha_ejercicio': _selectedDate.toIso8601String(), // Agregar la fecha seleccionada
    };

    // Solo incluir 'video_url' si hay un enlace proporcionado
    if (videoControllers.isNotEmpty && videoControllers.first.text.isNotEmpty) {
      routine['video_url'] = videoControllers.first.text;
    }

    try {
      final response = await routineRepository.createRoutine(routine);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ref.invalidate(routineProvider); // Invalida el provider para recargar las rutinas
        Navigator.pop(context);
      } else {
        print('Error: ${response.body}');
        final snackBar = SnackBar(content: Text('Error al guardar la rutina: ${response.body}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      final snackBar = SnackBar(content: Text('Error al enviar la solicitud: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Método para mostrar el DatePicker y actualizar la fecha seleccionada
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupProvider);
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9, // Ajustado para abrirse más arriba
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: scaffoldBackgroundColor, // Fondo blanco puro
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Agregar Rutina', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    groupState.groups.isEmpty
                        ? const CircularProgressIndicator()
                        : DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar Grupo',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedGroup,
                            items: groupState.groups.map<DropdownMenuItem<String>>((group) {
                              return DropdownMenuItem<String>(
                                value: group['id'].toString(),
                                child: Text(group['nombre'], style: const TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGroup = value;
                              });
                            },
                            validator: (value) => value == null ? 'Por favor selecciona un grupo' : null,
                          ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: titleController,
                      label: 'Nombre',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x0fffffff),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Selector de fecha
                    Row(
                      children: [
                        Text('Fecha: ${_selectedDate.toLocal()}'.split(' ')[0]),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Seleccionar fecha'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text('Agregar enlace de YouTube'),
                      value: addVideoField,
                      onChanged: (bool value) {
                        setState(() {
                          addVideoField = value;
                          if (!value) videoControllers.clear();
                        });
                      },
                    ),
                    if (addVideoField)
                      Column(
                        children: [
                          ...videoControllers.map((controller) {
                            final index = videoControllers.indexOf(controller);
                            return Column(
                              children: [
                                CustomTextFormField(
                                  controller: controller,
                                  label: 'Enlace de YouTube',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa un enlace de YouTube';
                                    }
                                    return null;
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => setState(() {
                                    videoControllers.removeAt(index);
                                  }),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                          CustomFilledButton(
                            onPressed: () => setState(() {
                              videoControllers.add(TextEditingController());
                            }),
                            text: 'Agregar Enlace',
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomFilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Cancelar',
                        ),
                        CustomFilledButton(
                          onPressed: saveRoutine,
                          text: 'Guardar Rutina',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

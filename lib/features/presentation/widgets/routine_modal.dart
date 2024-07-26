import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/data/repositories/routine_repository.dart';
import 'package:time_to_train/features/presentation/providers/group_provider.dart';
import 'package:time_to_train/features/presentation/providers/routine_provider.dart';
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
    final routineRepository = ref.read(routineRepositoryProvider);

    final routine = {
      'nombre': titleController.text,
      'descripcion': descriptionController.text,
      'usuario_id': 1, // Aquí deberías obtener el ID del usuario actual
      'grupo_id': int.parse(selectedGroup!),
      'video_url': videoControllers.isNotEmpty ? videoControllers.first.text : null,
    };

    await routineRepository.createRoutine(routine);
    ref.invalidate(routineProvider); // Invalida el provider para recargar las rutinas
    Navigator.pop(context);
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
                          ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: titleController,
                      label: 'Nombre',
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
                      ),
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

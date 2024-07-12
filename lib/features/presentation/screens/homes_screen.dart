import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/widgets.dart';
import 'package:time_to_train/features/presentation/providers/auth_provider.dart';
import 'package:time_to_train/features/presentation/providers/group_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Time to Train'),
      ),
      body: _Home(authState.rol),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
    );
  }
}

class _Home extends StatelessWidget {
  final String rol;
  const _Home(this.rol);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              SizedBox(height: 15),
              HorizontalCardView(),
              SizedBox(height: 15),
              HorizontalCardView(),
            ],
          ),
        ),
        if (rol == 'entrenador' || rol == 'admin')
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const RoutineModal(),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}

class RoutineModal extends ConsumerStatefulWidget {
  const RoutineModal({super.key});

  @override
  _RoutineModalState createState() => _RoutineModalState();
}

class _RoutineModalState extends ConsumerState<RoutineModal> {
  final List<Map<String, String>> sections = [];
  String? selectedGroup;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<TextEditingController> videoControllers = [];

  bool addVideoField = false;

  void addSection() {
    setState(() {
      sections.add({'title': '', 'content': ''});
    });
  }

  void removeSection(int index) {
    setState(() {
      sections.removeAt(index);
    });
  }

  void addVideoUrlField() {
    setState(() {
      videoControllers.add(TextEditingController());
    });
  }

  void removeVideoUrlField(int index) {
    setState(() {
      videoControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupProvider);
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Agregar Rutina', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar Grupo',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedGroup,
                      items: groups.groups.map<DropdownMenuItem<String>>((group) {
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
                      label: 'Título',
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
                      title: const Text('Agregar enlaces de YouTube'),
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
                                  onPressed: () => removeVideoUrlField(index),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                          CustomFilledButton(
                            onPressed: addVideoUrlField,
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
                          onPressed: addSection,
                          text: 'Agregar Sección',
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

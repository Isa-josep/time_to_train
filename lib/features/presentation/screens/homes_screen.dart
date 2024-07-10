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
                  builder: (context) => const SectionModal(),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}

class SectionModal extends ConsumerStatefulWidget {
  const SectionModal({super.key});

  @override
  _SectionModalState createState() => _SectionModalState();
}

class _SectionModalState extends ConsumerState<SectionModal> {
  final List<Map<String, String>> sections = [];
  String? selectedGroup;

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

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Agregar Secciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Seleccionar Grupo'),
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CustomTextFormField(
                          label: 'Título de Sección',
                          onChanged: (value) {
                            sections[index]['title'] = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: 'Contenido de Sección',
                          onChanged: (value) {
                            sections[index]['content'] = value;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => removeSection(index),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomFilledButton(
                      onPressed: addSection,
                      text: 'Agregar Sección',
                    ),
                    CustomFilledButton(
                      onPressed: () {
                        // Lógica para guardar las secciones
                        Navigator.pop(context);
                      },
                      text: 'Guardar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
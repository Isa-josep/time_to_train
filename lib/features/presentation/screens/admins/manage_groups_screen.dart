import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/providers/group_provider.dart';

class ManageGroupsScreen extends ConsumerStatefulWidget {
  const ManageGroupsScreen({super.key});

  @override
  ConsumerState<ManageGroupsScreen> createState() => _ManageGroupsScreenState();
}

class _ManageGroupsScreenState extends ConsumerState<ManageGroupsScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  int? _selectedGroupId;

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Grupos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Grupo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final groupName = _groupNameController.text.trim();
                if (groupName.isNotEmpty) {
                  ref.read(groupProvider.notifier).createGroup(groupName);
                  _groupNameController.clear();
                }
              },
              child: const Text('Crear Grupo'),
            ),
            const SizedBox(height: 20),
            const Text('Grupos Disponibles', style: TextStyle(fontSize: 18)),
            groupState.groups.isEmpty
                ? const Text('No hay grupos disponibles')
                : DropdownButton<int>(
                    hint: const Text('Seleccionar Grupo'),
                    value: _selectedGroupId,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedGroupId = newValue;
                      });
                    },
                    items: groupState.groups.map<DropdownMenuItem<int>>((group) {
                      return DropdownMenuItem<int>(
                        value: group['id'],
                        child: Text(group['nombre']),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 20),
            const Text('Usuarios Sin Grupo', style: TextStyle(fontSize: 18)),
            groupState.usersWithoutGroup.isEmpty
                ? const Text('No hay usuarios disponibles')
                : Expanded(
                    child: ListView.builder(
                      itemCount: groupState.usersWithoutGroup.length,
                      itemBuilder: (context, index) {
                        final user = groupState.usersWithoutGroup[index];
                        return ListTile(
                          title: Text(user['nombre']),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (_selectedGroupId != null) {
                                ref.read(groupProvider.notifier).addUserToGroup(user['id'], _selectedGroupId!);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

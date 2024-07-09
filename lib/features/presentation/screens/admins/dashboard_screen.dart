import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/providers/user_provider.dart';
import 'package:time_to_train/features/presentation/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> updateUserRole(int userId, String newRole) async {
    final response = await http.put(
      Uri.parse('http://192.168.1.25:3000/api/users/$userId/rol'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rol': newRole,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user role');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(
                    user['nombre'],
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  subtitle: Text(
                    user['correo'],
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  trailing: authState.rol == 'admin'
                      ? DropdownButton<String>(
                          value: user['rol'],
                          items: ['usuario', 'entrenador']
                              .map(
                                (role) => DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: TextStyle(
                                      fontSize: 16, // Ajuste del tamaño del texto
                                      fontWeight: FontWeight.w500,
                                      color: role == 'usuario'
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (newRole) {
                            if (newRole != null) {
                              updateUserRole(user['id'], newRole).then((_) {
                                ref.read(userProvider.notifier).loadUsers();
                              });
                            }
                          },
                        )
                      : null,
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/presentation/providers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // Función para actualizar el rol de un usuario
  // Función para actualizar el rol de un usuario con GraphQL
Future<void> updateUserRole(int userId, String newRole) async {
  const mutation = '''
    mutation UpdateUserRole(\$id: Int!, \$rol: String!) {
      updateUserRole(id: \$id, rol: \$rol) {
        id
        nombre_usuario
        rol
      }
    }
  ''';

  try {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'), // Asegúrate de que la URL esté bien definida
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'query': mutation,
        'variables': {
          'id': userId,
          'rol': newRole,
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['errors'] != null) {
        print('Error al actualizar el rol: ${data['errors']}');
        throw Exception('Error al actualizar el rol');
      } else {
        print('Rol actualizado correctamente');
      }
    } else {
      print('Error al actualizar el rol. Código de estado: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      throw Exception('Error al actualizar el rol del usuario');
    }
  } catch (e) {
    print('Error al actualizar el rol del usuario: $e');
    throw Exception('Error al actualizar el rol');
  }
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos los datos del usuario desde el Provider
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
                
                // Aseguramos que las propiedades existen antes de acceder a ellas
                final nombreUsuario = user['nombre_usuario'] ?? 'Nombre no disponible';
                final correo = user['correo'] ?? 'Correo no disponible';
                final rol = user['rol'] ?? 'usuario';  // Rol predeterminado si no está definido

                return ListTile(
                  title: Text(
                    nombreUsuario,  // Mostramos el nombre de usuario
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  subtitle: Text(
                    correo,  // Mostramos el correo
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  trailing: authState.rol == 'admin'
                      ? DropdownButton<String>(
                          value: rol,  // Aseguramos que siempre haya un rol
                          items: ['user', 'entrenador']
                              .map(
                                (role) => DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: role == 'user'
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
                                // Recargamos la lista de usuarios tras actualizar el rol
                                ref.read(userProvider.notifier).loadUsers();
                              });
                            }
                          },
                        )
                      : null,  // Si no es admin, no se muestra el dropdown
                );
              },
            ),
    );
  }
}

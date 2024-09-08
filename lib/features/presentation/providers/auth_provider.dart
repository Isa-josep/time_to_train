import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Definir el provider para autenticar el estado
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// AuthNotifier para gestionar el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'correo': email,
        'contrasena': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'] ?? '';
      final Map<String, dynamic>? user = data['user'];
      final String nombre = user?['nombre_usuario'] ?? 'Usuario';
      final String rol = user?['rol'] ?? 'usuario';
      final String apellido = user?['apellido'] ?? '';
      final int usuarioId = user?['id'] ?? 0; // Obtén el ID del usuario
      
      // Actualiza el estado con el token, nombre, rol, apellido e ID del usuario
      state = state.copyWith(
        token: token,
        isAuthenticated: true,
        nombre: nombre,
        rol: rol,
        apellido: apellido,
        usuarioId: usuarioId,
      );
    } else {
      throw Exception('Failed to login');
    }
  }

  // Método para registrar un nuevo usuario
  Future<void> register(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'] ?? '';
      final Map<String, dynamic>? user = data['user'];
      final String nombre = user?['nombre_usuario'] ?? 'Usuario';
      final String rol = user?['rol'] ?? 'usuario';
      final String apellido = user?['apellido'] ?? '';
      final int usuarioId = user?['id'] ?? 0; // Obtén el ID del usuario
      print('Usuario ID: $usuarioId');
      // Actualiza el estado con el token, nombre, rol, apellido e ID del usuario
      state = state.copyWith(
        token: token,
        isAuthenticated: true,
        nombre: nombre,
        rol: rol,
        apellido: apellido,
        usuarioId: usuarioId,
      );
    } else {
      throw Exception('Failed to register');
    }
  }

  // Método para cerrar sesión
  void logout() {
    state = AuthState(); // Resetea el estado
  }
}

// Clase AuthState para almacenar el estado de autenticación
class AuthState {
  final String token;
  final bool isAuthenticated;
  final String nombre;
  final String rol;
  final String apellido;
  final int usuarioId; // Nuevo campo para almacenar el ID del usuario

  AuthState({
    this.token = '',
    this.isAuthenticated = false,
    this.nombre = '',
    this.rol = 'usuario',
    this.apellido = '',
    this.usuarioId = 0, // Por defecto 0
  });

  // Método para actualizar el estado con los nuevos valores
  AuthState copyWith({
    String? token,
    bool? isAuthenticated,
    String? nombre,
    String? rol,
    String? apellido,
    int? usuarioId,
  }) {
    return AuthState(
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      apellido: apellido ?? this.apellido,
      usuarioId: usuarioId ?? this.usuarioId, // Mantén el ID del usuario
    );
  }
}

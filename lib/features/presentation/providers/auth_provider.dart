import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    const query = '''
    mutation Login(\$correo: String!, \$contrasena: String!) {
      login(correo: \$correo, contrasena: \$contrasena) {
        token
        user {
          id
          nombre_usuario
          rol
          apellido
        }
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'query': query,
        'variables': {
          'correo': email,
          'contrasena': password,
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data']['login'];
      final String token = data['token'];
      final Map<String, dynamic>? user = data['user'];
      final String nombre = user?['nombre_usuario'] ?? 'Usuario';
      final String rol = user?['rol'] ?? 'usuario';
      final String apellido = user?['apellido'] ?? '';
      final int usuarioId = user?['id'] ?? 0;

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
  const mutation = '''
  mutation Register(\$nombre: String!, \$apellido: String!, \$nombre_usuario: String!, \$correo: String!, \$contrasena: String!, \$rol: String!) {
    createUser(nombre: \$nombre, apellido: \$apellido, nombre_usuario: \$nombre_usuario, correo: \$correo, contrasena: \$contrasena, rol: \$rol) {
      id
      nombre
      apellido
      nombre_usuario
      correo
      rol
    }
  }
  ''';

  // Si el rol no está en userData, lo establecemos como "usuario" por defecto
  if (!userData.containsKey('rol')) {
    userData['rol'] = 'usuario'; // Valor por defecto
  }

  final response = await http.post(
    Uri.parse('${dotenv.env['API_URL']}graphql'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'query': mutation,
      'variables': userData,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['errors'] != null) {
      print('GraphQL errors: ${jsonResponse['errors']}');
      jsonResponse['errors'].forEach((error) {
        print('Error message: ${error['message']}');
        print('Error locations: ${error['locations']}');
        print('Error path: ${error['path']}');
      });
      throw Exception('Failed to register due to GraphQL errors.');
    }

    final Map<String, dynamic>? data = jsonResponse['data']?['createUser'];

    if (data == null) {
      throw Exception('Failed to register: createUser data is null');
    }

    final String nombre = data['nombre'];
    final String apellido = data['apellido'];
    final String nombreUsuario = data['nombre_usuario'];
    final int usuarioId = data['id'];

    state = state.copyWith(
      nombre: nombreUsuario,
      apellido: apellido,
      usuarioId: usuarioId,
      isAuthenticated: true,
    );
  } else {
    print('HTTP error: ${response.statusCode}');
    throw Exception('Failed to register due to HTTP error');
  }
}





  void logout() {
    state = AuthState();
  }
}

class AuthState {
  final String token;
  final bool isAuthenticated;
  final String nombre;
  final String rol;
  final String apellido;
  final int usuarioId;

  AuthState({
    this.token = '',
    this.isAuthenticated = false,
    this.nombre = '',
    this.rol = 'usuario',
    this.apellido = '',
    this.usuarioId = 0,
  });

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
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.35:3000/api/users/login'),
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
      final String token = data['token'];
      final Map<String, dynamic>? user = data['user'];
      final String nombre = user?['nombre'] ?? 'Usuario';
      state = state.copyWith(token: token, isAuthenticated: true, nombre: nombre);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.35:3000/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'];
      final Map<String, dynamic>? user = data['user'];
      final String nombre = user?['nombre'] ?? 'Usuario';
      state = state.copyWith(token: token, isAuthenticated: true, nombre: nombre);
    } else {
      throw Exception('Failed to register');
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

  AuthState({this.token = '', this.isAuthenticated = false, this.nombre = ''});

  AuthState copyWith({String? token, bool? isAuthenticated, String? nombre}) {
    return AuthState(
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      nombre: nombre ?? this.nombre,
    );
  }
}

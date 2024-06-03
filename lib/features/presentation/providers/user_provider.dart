import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modelo de usuario
class User {
  final String name;
  final String email;
  final String username;

  User(this.name, this.email, this.username);
}

// Proveedor de estado del usuario
final userProvider = StateProvider<User?>((ref) => null);

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final userProvider = StateNotifierProvider<UserNotifier, List<dynamic>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<dynamic>> {
  UserNotifier() : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    const query = '''
    query {
      obtenerUsuarios {
        id
        nombre_usuario
        rol
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']['obtenerUsuarios'];
      final List<dynamic> filteredData = data.where((user) => user['rol'] != 'admin').toList();
      state = filteredData;
    } else {
      throw Exception('Failed to load users');
    }
  }
}

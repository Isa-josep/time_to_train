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
    final response = await http.get(Uri.parse('${dotenv.env['API_URL']}api/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<dynamic> filteredData = data.where((user) => user['rol'] != 'admin').toList();
      state = filteredData;
    } else {
      throw Exception('Failed to load users');
    }
  }
}

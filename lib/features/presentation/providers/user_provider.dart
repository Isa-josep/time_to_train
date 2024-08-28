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
    final response = await http.get(Uri.parse('http://192.168.1.170:3000/api/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<dynamic> filteredData = data.where((user) => user['rol'] != 'admin').toList();
      state = filteredData;
    } else {
      throw Exception('Failed to load users');
    }
  }
}

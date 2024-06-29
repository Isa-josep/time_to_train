import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final groupProvider = StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  return GroupNotifier();
});

class GroupNotifier extends StateNotifier<GroupState> {
  GroupNotifier() : super(GroupState()) {
    loadGroups();
    loadUsersWithoutGroup();
  }

  Future<void> loadGroups() async {
    final response = await http.get(Uri.parse('http://192.168.1.25:3000/api/groups'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      state = state.copyWith(groups: data);
    }
  }

  Future<void> loadUsersWithoutGroup() async {
    final response = await http.get(Uri.parse('http://192.168.1.25:3000/api/users/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      state = state.copyWith(usersWithoutGroup: data);
    }
  }

  Future<void> createGroup(String nombre) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.25:3000/api/groups'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'creador_id': '1', // Cambia esto según el ID del usuario creador (entrenador/admin)
      }),
    );

    if (response.statusCode == 200) {
      loadGroups();
    } else {
      throw Exception('Failed to create group');
    }
  }

  Future<void> addUserToGroup(int userId, int groupId) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.25:3000/api/groups/$groupId/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      loadUsersWithoutGroup();
    } else {
      throw Exception('Failed to add user to group');
    }
  }
}

class GroupState {
  final List<dynamic> groups;
  final List<dynamic> usersWithoutGroup;

  GroupState({this.groups = const [], this.usersWithoutGroup = const []});

  GroupState copyWith({List<dynamic>? groups, List<dynamic>? usersWithoutGroup}) {
    return GroupState(
      groups: groups ?? this.groups,
      usersWithoutGroup: usersWithoutGroup ?? this.usersWithoutGroup,
    );
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    const query = '''
    query {
      groups {
        id
        nombre
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']['groups'];
      final List<Map<String, dynamic>> groups = data.map((group) {
        return {
          'id': group['id'],
          'nombre': group['nombre'],
        };
      }).toList();
      state = state.copyWith(groups: groups);
    }
  }

  Future<void> loadUsersWithoutGroup() async {
    const query = '''
    query {
      obtenerUsuariosSinGrupo {
        id
        nombre_usuario
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']['obtenerUsuariosSinGrupo'];
      state = state.copyWith(usersWithoutGroup: data);
    }
  }

  Future<void> createGroup(String nombre) async {
    const mutation = '''
    mutation CrearGrupo(\$nombre: String!, \$creador_id: Int!) {
      createGroup(nombre: \$nombre, creador_id: \$creador_id) {
        id
        nombre
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'query': mutation,
        'variables': {
          'nombre': nombre,
          'creador_id': 1,
        },
      }),
    );

    if (response.statusCode == 200) {
      loadGroups();
    } else {
      throw Exception('Failed to create group');
    }
  }

  Future<void> addUserToGroup(int userId, int groupId) async {
    const mutation = '''
      mutation AgregarUsuarioAGrupo(\$userId: Int!, \$groupId: Int!) {
        addUserToGroup(userId: \$userId, groupId: \$groupId)
      }
      ''';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}graphql'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'query': mutation,
        'variables': {
          'userId': userId,
          'groupId': groupId,
        },
      }),
    );

    final responseBody = json.decode(response.body);
      print('Response body: $responseBody'); // Verifica el contenido completo de la respuesta

      if (responseBody['data'] != null && responseBody['data']['addUserToGroup'] == true) {
        loadUsersWithoutGroup();
      } 
      else {
        throw Exception('Failed to add user to group');
      }

  }
}

class GroupState {
  final List<Map<String, dynamic>> groups;
  final List<dynamic> usersWithoutGroup;

  GroupState({this.groups = const [], this.usersWithoutGroup = const []});

  GroupState copyWith({List<Map<String, dynamic>>? groups, List<dynamic>? usersWithoutGroup}) {
    return GroupState(
      groups: groups ?? this.groups,
      usersWithoutGroup: usersWithoutGroup ?? this.usersWithoutGroup,
    );
  }
}

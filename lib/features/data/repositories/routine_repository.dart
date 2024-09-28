import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_to_train/features/models/routine_model.dart';

class RoutineRepository {
  final String baseUrl;

  RoutineRepository(this.baseUrl);

  // Método para obtener todas las rutinas
  Future<List<Routine>> fetchRoutines() async {
    const query = '''
    query {
      obtenerRutinas {
        id
        nombre
        descripcion
        usuario_id
        grupo_id
        video_url
        fecha_ejercicio
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('$baseUrl/graphql'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['obtenerRutinas'] as List;
      return data.map((json) => Routine.fromJson(json)).toList();
    } else {
      print('Error al obtener rutinas: ${response.body}');
      throw Exception('Failed to load routines');
    }
  }

  // Método para crear una rutina
  Future<http.Response> createRoutine(Map<String, dynamic> routine) async {
    const mutation = '''
    mutation CrearRutina(\$nombre: String!, \$descripcion: String, \$usuario_id: Int!, \$grupo_id: Int!, \$video_url: String, \$fecha_ejercicio: String) {
      createRoutine(nombre: \$nombre, descripcion: \$descripcion, usuario_id: \$usuario_id, grupo_id: \$grupo_id, video_url: \$video_url, fecha_ejercicio: \$fecha_ejercicio) {
        id
        nombre
      }
    }
    ''';

    final response = await http.post(
      Uri.parse('$baseUrl/graphql'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': mutation,
        'variables': routine,
      }),
    );

    return response;
  }

  // Método para obtener las rutinas por fecha
  Future<List<Routine>> fetchRoutinesByDate(DateTime date) async {
  const query = '''
    query ObtenerRutinasPorFecha(\$fecha: DateTime!) {
      routinesByDate(fecha_ejercicio: \$fecha) {
        id
        nombre
        descripcion
        usuario_id
        grupo_id
        video_url
        fecha_ejercicio
      }
    }
  ''';

  final response = await http.post(
    Uri.parse('$baseUrl/graphql'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'query': query,
      'variables': {'fecha': date.toIso8601String()},
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['data']['routinesByDate'] == null) {
      return [];
    }
    final List routines = data['data']['routinesByDate'];
    return routines.map((json) => Routine.fromJson(json)).toList();
  } else {
    print('Error al obtener rutinas por fecha: ${response.body}');
    throw Exception('Failed to load routines by date');
  }
}

}

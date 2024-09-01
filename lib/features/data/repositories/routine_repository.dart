import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_to_train/features/models/routine_model.dart';

class RoutineRepository {
  final String baseUrl;

  RoutineRepository(this.baseUrl);

  // Método para obtener todas las rutinas
  Future<List<Routine>> fetchRoutines() async {
    final response = await http.get(Uri.parse('$baseUrl/routines'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Routine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load routines');
    }
  }

  // Método para crear una rutina
  Future<http.Response> createRoutine(Map<String, dynamic> routine) async {
    final response = await http.post(
      Uri.parse('$baseUrl/routines'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(routine),
    );
    return response;
  }

  // Método para obtener las rutinas por fecha
  Future<List<Routine>> fetchRoutinesByDate(DateTime date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/routines?date=${date.toIso8601String()}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Routine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load routines');
    }
  }
}

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:time_to_train/features/models/routine_model.dart';

class RoutineRepository {
  final String baseUrl;

  RoutineRepository(this.baseUrl);

  Future<List<Routine>> fetchRoutines() async {
    final response = await http.get(Uri.parse('$baseUrl/routines'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Routine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load routines');
    }
  }

  Future<void> createRoutine(Map<String, dynamic> routine) async {
    final response = await http.post(
      Uri.parse('$baseUrl/routines'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(routine),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create routine');
    }
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  const baseUrl = 'http://192.168.1.28:3000/api'; // Ajusta esto según tu configuración
  return RoutineRepository(baseUrl);
});

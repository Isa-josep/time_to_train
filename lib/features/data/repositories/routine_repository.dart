import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:time_to_train/features/models/routine_model.dart';

class RoutineRepository {
  final String baseUrl;

  RoutineRepository(this.baseUrl);

  Future<http.Response> createRoutine(Map<String, dynamic> routine) async {
    final response = await http.post(
      Uri.parse('$baseUrl/routines'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(routine),
    );
    return response;
  }

  // Asegúrate de que esta función esté aquí si se usa en otro lugar
  Future<List<Routine>> fetchRoutines() async {
    final response = await http.get(Uri.parse('$baseUrl/routines'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Routine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load routines');
    }
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  String baseUrl = 'http://${dotenv.env['PATH']}:3000/api';
  return RoutineRepository(baseUrl);
});

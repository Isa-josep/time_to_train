import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/data/repositories/routine_repository.dart';
import 'package:time_to_train/features/models/routine_model.dart';

class RoutineNotifier extends StateNotifier<AsyncValue<List<Routine>>> {
  RoutineNotifier(this._repository) : super(const AsyncLoading()) {
    loadRoutines();
  }

  final RoutineRepository _repository;

  Future<void> loadRoutines() async {
    try {
      final routines = await _repository.fetchRoutines();
      state = AsyncData(routines);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addRoutine(Map<String, dynamic> routineData) async {
    try {
      state = const AsyncLoading();
      await _repository.createRoutine(routineData);
      await loadRoutines();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  String baseUrl = '${dotenv.env['API_URL']}graphql'; // Cambiar al endpoint de GraphQL
  return RoutineRepository(baseUrl);
});


final routineProvider = StateNotifierProvider<RoutineNotifier, AsyncValue<List<Routine>>>((ref) {
  return RoutineNotifier(ref.read(routineRepositoryProvider));
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/data/repositories/routine_repository.dart';
import 'package:time_to_train/features/models/routine_model.dart';

final routineProvider = FutureProvider<List<Routine>>((ref) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  return await routineRepository.fetchRoutines();
});

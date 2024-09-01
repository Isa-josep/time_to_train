import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/models/routine_model.dart';
import 'package:time_to_train/features/presentation/providers/routine_provider.dart';

final routineByDateProvider = FutureProvider.family<List<Routine>, DateTime>((ref, fecha) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  return await routineRepository.fetchRoutinesByDate(fecha);
});

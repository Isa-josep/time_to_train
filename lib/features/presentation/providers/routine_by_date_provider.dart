import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_to_train/features/models/routine_model.dart';
import 'package:time_to_train/features/presentation/providers/routine_provider.dart';

final routineByDateProvider = FutureProvider.family<List<Routine>, DateTime>((ref, fecha) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  final allRoutines = await routineRepository.fetchRoutinesByDate(fecha);

  // Filtrar las rutinas para que solo se muestren las que coinciden con la fecha específica (ignorando la hora)
  return allRoutines.where((routine) {
    return routine.fechaEjercicio != null &&
           routine.fechaEjercicio!.year == fecha.year &&
           routine.fechaEjercicio!.month == fecha.month &&
           routine.fechaEjercicio!.day == fecha.day;
  }).toList();
});
